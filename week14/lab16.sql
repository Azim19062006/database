\set ON_ERROR_STOP on
\pset pager off
\echo '16.1 Create the exercise tables; account opening amounts are copied from published salaries'
BEGIN;
CREATE SCHEMA lab16;
SET LOCAL search_path TO lab16;
CREATE TABLE accounts(account_id INTEGER PRIMARY KEY,balance NUMERIC(12,2) NOT NULL CHECK(balance>=0));
INSERT INTO accounts SELECT employee_id,salary FROM lab_data.employee WHERE employee_id IN(1,2);
CREATE TABLE customers(customer_id SERIAL PRIMARY KEY,name TEXT,email TEXT);
CREATE TABLE orders(order_id SERIAL PRIMARY KEY,customer_id INTEGER REFERENCES customers,total NUMERIC(10,2));
CREATE TABLE products(product_id SERIAL PRIMARY KEY,name TEXT,price NUMERIC(10,2) CHECK(price>=0));
CREATE TABLE order_items(order_id INTEGER REFERENCES orders,product_id INTEGER REFERENCES products,quantity INTEGER CHECK(quantity>0));
CREATE TABLE inventory(product_id INTEGER PRIMARY KEY REFERENCES products,stock INTEGER CHECK(stock>=0));
CREATE TABLE logs(message TEXT);
CREATE TABLE checks(check_name TEXT PRIMARY KEY,passed BOOLEAN NOT NULL,details TEXT);
COMMIT;
SET search_path TO lab16;
TABLE accounts;
\echo '16.2 BEGIN / COMMIT: transfer 100, both updates persist'
BEGIN;
UPDATE accounts SET balance=balance-100 WHERE account_id=1;
UPDATE accounts SET balance=balance+100 WHERE account_id=2;
COMMIT;
TABLE accounts;
INSERT INTO checks SELECT 'commit_transfer',
    (SELECT balance=3700 FROM accounts WHERE account_id=1) AND
    (SELECT balance=2330 FROM accounts WHERE account_id=2),'100 transferred; total remains 6030';
\echo '16.3 BEGIN / ROLLBACK: both changes are undone'
BEGIN;
UPDATE accounts SET balance=balance-100 WHERE account_id=1;
UPDATE accounts SET balance=balance+100 WHERE account_id=2;
ROLLBACK;
TABLE accounts;
INSERT INTO checks SELECT 'rollback_transfer',
    (SELECT balance=3700 FROM accounts WHERE account_id=1) AND
    (SELECT balance=2330 FROM accounts WHERE account_id=2),'Balances unchanged after ROLLBACK';
\echo '16.4 Consistency and explicit transaction: source transfer of 500'
BEGIN;
SELECT balance FROM accounts WHERE account_id=1 FOR UPDATE;
UPDATE accounts SET balance=balance-500 WHERE account_id=1;
UPDATE accounts SET balance=balance+500 WHERE account_id=2;
COMMIT;
INSERT INTO checks SELECT 'consistent_total',SUM(balance)=6030,'CHECK(balance >= 0) and total = 6030' FROM accounts;
\echo '16.5 Customers/orders: use RETURNING rather than ambiguous LASTVAL'
BEGIN;
INSERT INTO customers(name,email) VALUES('John Doe','john@email.com') RETURNING customer_id \gset
INSERT INTO orders(customer_id,total) VALUES(:customer_id,100.00);
COMMIT;
\echo '16.6 Savepoint: cancel first order, keep customer and replacement order'
BEGIN;
INSERT INTO customers(name,email) VALUES('Alice','alice@email.com') RETURNING customer_id \gset
SAVEPOINT after_customer_insert;
INSERT INTO orders(customer_id,total) VALUES(:customer_id,500.00);
ROLLBACK TO SAVEPOINT after_customer_insert;
INSERT INTO orders(customer_id,total) VALUES(:customer_id,300.00);
COMMIT;
SELECT c.name,o.total FROM customers c JOIN orders o USING(customer_id) ORDER BY c.customer_id;
INSERT INTO checks SELECT 'savepoint_order',COUNT(*)=1 AND MIN(total)=300,
    'Alice kept; 500 order rolled back; 300 order committed'
FROM orders WHERE customer_id=:customer_id;
\echo '16.7 Multiple savepoints: actual CHECK violation and recovery'
BEGIN;
INSERT INTO products(name,price) VALUES('Laptop',999.99);
SAVEPOINT sp1;
INSERT INTO products(name,price) VALUES('Mouse',25.99);
SAVEPOINT sp2;
\set ON_ERROR_STOP off
INSERT INTO products(name,price) VALUES('Invalid Product',-50.00);
\set invalid_price_state :SQLSTATE
\set ON_ERROR_STOP on
ROLLBACK TO SAVEPOINT sp2;
SELECT :'invalid_price_state'='23514' AS expected_check_failure \gset
\if :expected_check_failure
\echo 'Expected SQLSTATE 23514; transaction recovered through SAVEPOINT'
\else
\quit 1
\endif
INSERT INTO products(name,price) VALUES('Keyboard',79.99);
COMMIT;
TABLE products;
INSERT INTO checks SELECT 'savepoint_constraint',COUNT(*)=3 AND MIN(price)>0,
    'Negative price rejected (23514); Laptop, Mouse and Keyboard committed' FROM products;
\echo '16.8 RELEASE SAVEPOINT'
BEGIN;
INSERT INTO logs VALUES('Starting process');
SAVEPOINT process_start;
INSERT INTO logs VALUES('Process completed');
RELEASE SAVEPOINT process_start;
COMMIT;
\echo '16.9 Atomic order failure: rollback all statements in the failed unit'
DO $$
DECLARE old_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO old_count FROM orders;
    BEGIN
        INSERT INTO orders(customer_id,total) VALUES(1,250.00);
        INSERT INTO order_items(order_id,product_id,quantity)
        VALUES(currval('orders_order_id_seq'),101,2);
        RAISE EXCEPTION 'Expected missing product FK';
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE '23503: order and item rolled back together';
    END;
    INSERT INTO checks SELECT 'atomic_order_failure',COUNT(*)=old_count,
        'FK failure rolls back the preceding order insert' FROM orders;
END $$;
\echo '16.10 Short transaction: inventory decrement and order item'
-- Opening stock uses quantity 10 from the published DataLemur trade 100102.
INSERT INTO inventory SELECT 1,quantity FROM lab_data.trades WHERE order_id=100102;
BEGIN;
UPDATE inventory SET stock=stock-1 WHERE product_id=1;
INSERT INTO order_items(order_id,product_id,quantity) VALUES(1,1,1);
COMMIT;
\echo '16.11 Insufficient funds: PostgreSQL exception handling'
DO $$
BEGIN
    BEGIN
        IF (SELECT balance FROM accounts WHERE account_id=1)<100000 THEN
            RAISE EXCEPTION USING ERRCODE='P0001', MESSAGE='Insufficient funds';
        END IF;
        UPDATE accounts SET balance=balance-100000 WHERE account_id=1;
    EXCEPTION WHEN SQLSTATE 'P0001' THEN
        INSERT INTO checks VALUES('insufficient_funds',true,'Transfer rejected before any account changes');
    END;
END $$;
\echo '16.12 Session isolation and SERIALIZABLE transaction'
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN;
SHOW transaction_isolation;
COMMIT;
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM accounts ORDER BY account_id;
UPDATE accounts SET balance=balance*1.05;
COMMIT;
SELECT * FROM accounts ORDER BY account_id;
SELECT * FROM checks ORDER BY check_name;
