--
-- PostgreSQL database cluster dump
--

\restrict z8mdPWUBpRrPOvw0i6k81YFJPDasqZRmFTQXFcYoa757vry2gxzozh1n8Yg31it

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE azim;
ALTER ROLE azim WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;

--
-- User Configurations
--








\unrestrict z8mdPWUBpRrPOvw0i6k81YFJPDasqZRmFTQXFcYoa757vry2gxzozh1n8Yg31it

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict CTeeeUFy7au3jYZ0FhI8bBD17q55OyTsXVmWKZZkMuNpkHfZsRYVmWKqrLUMYmS

-- Dumped from database version 18.6 (Homebrew)
-- Dumped by pg_dump version 18.6 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

\unrestrict CTeeeUFy7au3jYZ0FhI8bBD17q55OyTsXVmWKZZkMuNpkHfZsRYVmWKqrLUMYmS

--
-- Database "coursework" dump
--

--
-- PostgreSQL database dump
--

\restrict nIxqlJSWY3cphu3iOk65YZw6nioygpRvkpKlRUvZulFKn9ltBteSzHpODQwZhTs

-- Dumped from database version 18.6 (Homebrew)
-- Dumped by pg_dump version 18.6 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: coursework; Type: DATABASE; Schema: -; Owner: azim
--

CREATE DATABASE coursework WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C';


ALTER DATABASE coursework OWNER TO azim;

\unrestrict nIxqlJSWY3cphu3iOk65YZw6nioygpRvkpKlRUvZulFKn9ltBteSzHpODQwZhTs
\connect coursework
\restrict nIxqlJSWY3cphu3iOk65YZw6nioygpRvkpKlRUvZulFKn9ltBteSzHpODQwZhTs

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: lab11; Type: SCHEMA; Schema: -; Owner: azim
--

CREATE SCHEMA lab11;


ALTER SCHEMA lab11 OWNER TO azim;

--
-- Name: lab15; Type: SCHEMA; Schema: -; Owner: azim
--

CREATE SCHEMA lab15;


ALTER SCHEMA lab15 OWNER TO azim;

--
-- Name: lab16; Type: SCHEMA; Schema: -; Owner: azim
--

CREATE SCHEMA lab16;


ALTER SCHEMA lab16 OWNER TO azim;

--
-- Name: lab17; Type: SCHEMA; Schema: -; Owner: azim
--

CREATE SCHEMA lab17;


ALTER SCHEMA lab17 OWNER TO azim;

--
-- Name: lab_data; Type: SCHEMA; Schema: -; Owner: azim
--

CREATE SCHEMA lab_data;


ALTER SCHEMA lab_data OWNER TO azim;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: students; Type: TABLE; Schema: lab11; Owner: azim
--

CREATE TABLE lab11.students (
    student_id integer NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    birth_date date
);


ALTER TABLE lab11.students OWNER TO azim;

--
-- Name: students_student_id_seq; Type: SEQUENCE; Schema: lab11; Owner: azim
--

CREATE SEQUENCE lab11.students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE lab11.students_student_id_seq OWNER TO azim;

--
-- Name: students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: lab11; Owner: azim
--

ALTER SEQUENCE lab11.students_student_id_seq OWNED BY lab11.students.student_id;


--
-- Name: pivoted_sales; Type: TABLE; Schema: lab15; Owner: azim
--

CREATE TABLE lab15.pivoted_sales (
    product text,
    year_2021 numeric,
    year_2022 numeric
);


ALTER TABLE lab15.pivoted_sales OWNER TO azim;

--
-- Name: accounts; Type: TABLE; Schema: lab16; Owner: azim
--

CREATE TABLE lab16.accounts (
    account_id integer NOT NULL,
    balance numeric(12,2) NOT NULL,
    CONSTRAINT accounts_balance_check CHECK ((balance >= (0)::numeric))
);


ALTER TABLE lab16.accounts OWNER TO azim;

--
-- Name: checks; Type: TABLE; Schema: lab16; Owner: azim
--

CREATE TABLE lab16.checks (
    check_name text NOT NULL,
    passed boolean NOT NULL,
    details text
);


ALTER TABLE lab16.checks OWNER TO azim;

--
-- Name: customers; Type: TABLE; Schema: lab16; Owner: azim
--

CREATE TABLE lab16.customers (
    customer_id integer NOT NULL,
    name text,
    email text
);


ALTER TABLE lab16.customers OWNER TO azim;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: lab16; Owner: azim
--

CREATE SEQUENCE lab16.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE lab16.customers_customer_id_seq OWNER TO azim;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: lab16; Owner: azim
--

ALTER SEQUENCE lab16.customers_customer_id_seq OWNED BY lab16.customers.customer_id;


--
-- Name: inventory; Type: TABLE; Schema: lab16; Owner: azim
--

CREATE TABLE lab16.inventory (
    product_id integer NOT NULL,
    stock integer,
    CONSTRAINT inventory_stock_check CHECK ((stock >= 0))
);


ALTER TABLE lab16.inventory OWNER TO azim;

--
-- Name: logs; Type: TABLE; Schema: lab16; Owner: azim
--

CREATE TABLE lab16.logs (
    message text
);


ALTER TABLE lab16.logs OWNER TO azim;

--
-- Name: order_items; Type: TABLE; Schema: lab16; Owner: azim
--

CREATE TABLE lab16.order_items (
    order_id integer,
    product_id integer,
    quantity integer,
    CONSTRAINT order_items_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE lab16.order_items OWNER TO azim;

--
-- Name: orders; Type: TABLE; Schema: lab16; Owner: azim
--

CREATE TABLE lab16.orders (
    order_id integer NOT NULL,
    customer_id integer,
    total numeric(10,2)
);


ALTER TABLE lab16.orders OWNER TO azim;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: lab16; Owner: azim
--

CREATE SEQUENCE lab16.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE lab16.orders_order_id_seq OWNER TO azim;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: lab16; Owner: azim
--

ALTER SEQUENCE lab16.orders_order_id_seq OWNED BY lab16.orders.order_id;


--
-- Name: products; Type: TABLE; Schema: lab16; Owner: azim
--

CREATE TABLE lab16.products (
    product_id integer NOT NULL,
    name text,
    price numeric(10,2),
    CONSTRAINT products_price_check CHECK ((price >= (0)::numeric))
);


ALTER TABLE lab16.products OWNER TO azim;

--
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: lab16; Owner: azim
--

CREATE SEQUENCE lab16.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE lab16.products_product_id_seq OWNER TO azim;

--
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: lab16; Owner: azim
--

ALTER SEQUENCE lab16.products_product_id_seq OWNED BY lab16.products.product_id;


--
-- Name: checks; Type: TABLE; Schema: lab17; Owner: azim
--

CREATE TABLE lab17.checks (
    check_name text NOT NULL,
    passed boolean NOT NULL,
    details text
);


ALTER TABLE lab17.checks OWNER TO azim;

--
-- Name: customers; Type: TABLE; Schema: lab17; Owner: azim
--

CREATE TABLE lab17.customers (
    user_id integer NOT NULL,
    city text,
    email text,
    signup_date timestamp without time zone
);


ALTER TABLE lab17.customers OWNER TO azim;

--
-- Name: employees; Type: TABLE; Schema: lab17; Owner: azim
--

CREATE TABLE lab17.employees (
    employee_id integer,
    first_name text,
    last_name text,
    salary numeric(12,2),
    department_id integer,
    manager_id integer
);


ALTER TABLE lab17.employees OWNER TO azim;

--
-- Name: employees_roundtrip; Type: TABLE; Schema: lab17; Owner: azim
--

CREATE TABLE lab17.employees_roundtrip (
    employee_id integer,
    first_name text,
    last_name text,
    salary numeric(12,2),
    department_id integer,
    manager_id integer
);


ALTER TABLE lab17.employees_roundtrip OWNER TO azim;

--
-- Name: names_import; Type: TABLE; Schema: lab17; Owner: azim
--

CREATE TABLE lab17.names_import (
    first_name text,
    last_name text
);


ALTER TABLE lab17.names_import OWNER TO azim;

--
-- Name: nullable_import; Type: TABLE; Schema: lab17; Owner: azim
--

CREATE TABLE lab17.nullable_import (
    employee_id integer,
    first_name text,
    last_name text,
    salary numeric(12,2),
    department_id integer,
    manager_id integer
);


ALTER TABLE lab17.nullable_import OWNER TO azim;

--
-- Name: orders; Type: TABLE; Schema: lab17; Owner: azim
--

CREATE TABLE lab17.orders (
    order_id integer,
    user_id integer,
    order_date date,
    total_amount numeric,
    status text
);


ALTER TABLE lab17.orders OWNER TO azim;

--
-- Name: partitioned_purchases; Type: TABLE; Schema: lab17; Owner: azim
--

CREATE TABLE lab17.partitioned_purchases (
    product text,
    spend numeric(10,2),
    sale_date date
)
PARTITION BY RANGE (sale_date);


ALTER TABLE lab17.partitioned_purchases OWNER TO azim;

--
-- Name: products; Type: TABLE; Schema: lab17; Owner: azim
--

CREATE TABLE lab17.products (
    product_name text,
    category text,
    price numeric(10,2),
    transaction_date timestamp without time zone
);


ALTER TABLE lab17.products OWNER TO azim;

--
-- Name: products_import; Type: TABLE; Schema: lab17; Owner: azim
--

CREATE TABLE lab17.products_import (
    product_name text,
    category text,
    price numeric(10,2),
    transaction_date timestamp without time zone
);


ALTER TABLE lab17.products_import OWNER TO azim;

--
-- Name: products_skip; Type: TABLE; Schema: lab17; Owner: azim
--

CREATE TABLE lab17.products_skip (
    product_name text,
    category text,
    price numeric(10,2),
    transaction_date timestamp without time zone
);


ALTER TABLE lab17.products_skip OWNER TO azim;

--
-- Name: purchases_2021; Type: TABLE; Schema: lab17; Owner: azim
--

CREATE TABLE lab17.purchases_2021 (
    product text,
    spend numeric(10,2),
    sale_date date
);


ALTER TABLE lab17.purchases_2021 OWNER TO azim;

--
-- Name: purchases_2022; Type: TABLE; Schema: lab17; Owner: azim
--

CREATE TABLE lab17.purchases_2022 (
    product text,
    spend numeric(10,2),
    sale_date date
);


ALTER TABLE lab17.purchases_2022 OWNER TO azim;

--
-- Name: staging_customers; Type: TABLE; Schema: lab17; Owner: azim
--

CREATE TABLE lab17.staging_customers (
    user_id integer CONSTRAINT customers_user_id_not_null NOT NULL,
    city text,
    email text,
    signup_date timestamp without time zone
);


ALTER TABLE lab17.staging_customers OWNER TO azim;

--
-- Name: summary_import; Type: TABLE; Schema: lab17; Owner: azim
--

CREATE TABLE lab17.summary_import (
    first_name text,
    last_name text,
    summary text
);


ALTER TABLE lab17.summary_import OWNER TO azim;

--
-- Name: target_customers; Type: TABLE; Schema: lab17; Owner: azim
--

CREATE TABLE lab17.target_customers (
    user_id integer CONSTRAINT customers_user_id_not_null NOT NULL,
    city text,
    email text,
    signup_date timestamp without time zone
);


ALTER TABLE lab17.target_customers OWNER TO azim;

--
-- Name: artists; Type: TABLE; Schema: lab_data; Owner: azim
--

CREATE TABLE lab_data.artists (
    artist_id integer NOT NULL,
    artist_name text,
    label_owner text
);


ALTER TABLE lab_data.artists OWNER TO azim;

--
-- Name: employee; Type: TABLE; Schema: lab_data; Owner: azim
--

CREATE TABLE lab_data.employee (
    employee_id integer NOT NULL,
    name text NOT NULL,
    salary numeric(12,2) NOT NULL,
    department_id integer,
    manager_id integer
);


ALTER TABLE lab_data.employee OWNER TO azim;

--
-- Name: purchases; Type: TABLE; Schema: lab_data; Owner: azim
--

CREATE TABLE lab_data.purchases (
    category text,
    product text,
    user_id integer,
    spend numeric(10,2),
    transaction_date timestamp without time zone
);


ALTER TABLE lab_data.purchases OWNER TO azim;

--
-- Name: songs; Type: TABLE; Schema: lab_data; Owner: azim
--

CREATE TABLE lab_data.songs (
    song_id integer NOT NULL,
    artist_id integer,
    name text
);


ALTER TABLE lab_data.songs OWNER TO azim;

--
-- Name: trades; Type: TABLE; Schema: lab_data; Owner: azim
--

CREATE TABLE lab_data.trades (
    order_id integer NOT NULL,
    user_id integer,
    price numeric(10,2),
    quantity integer,
    status text,
    traded_at timestamp without time zone
);


ALTER TABLE lab_data.trades OWNER TO azim;

--
-- Name: users; Type: TABLE; Schema: lab_data; Owner: azim
--

CREATE TABLE lab_data.users (
    user_id integer NOT NULL,
    city text,
    email text,
    signup_date timestamp without time zone
);


ALTER TABLE lab_data.users OWNER TO azim;

--
-- Name: purchases_2021; Type: TABLE ATTACH; Schema: lab17; Owner: azim
--

ALTER TABLE ONLY lab17.partitioned_purchases ATTACH PARTITION lab17.purchases_2021 FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');


--
-- Name: purchases_2022; Type: TABLE ATTACH; Schema: lab17; Owner: azim
--

ALTER TABLE ONLY lab17.partitioned_purchases ATTACH PARTITION lab17.purchases_2022 FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');


--
-- Name: students student_id; Type: DEFAULT; Schema: lab11; Owner: azim
--

ALTER TABLE ONLY lab11.students ALTER COLUMN student_id SET DEFAULT nextval('lab11.students_student_id_seq'::regclass);


--
-- Name: customers customer_id; Type: DEFAULT; Schema: lab16; Owner: azim
--

ALTER TABLE ONLY lab16.customers ALTER COLUMN customer_id SET DEFAULT nextval('lab16.customers_customer_id_seq'::regclass);


--
-- Name: orders order_id; Type: DEFAULT; Schema: lab16; Owner: azim
--

ALTER TABLE ONLY lab16.orders ALTER COLUMN order_id SET DEFAULT nextval('lab16.orders_order_id_seq'::regclass);


--
-- Name: products product_id; Type: DEFAULT; Schema: lab16; Owner: azim
--

ALTER TABLE ONLY lab16.products ALTER COLUMN product_id SET DEFAULT nextval('lab16.products_product_id_seq'::regclass);


--
-- Data for Name: students; Type: TABLE DATA; Schema: lab11; Owner: azim
--

COPY lab11.students (student_id, first_name, last_name, birth_date) FROM stdin;
1	Aibek	Sharshenov	2002-05-15
6	Meerim	Bekova	2003-06-12
7	Tilek	Usubaliev	2001-11-05
\.


--
-- Data for Name: pivoted_sales; Type: TABLE DATA; Schema: lab15; Owner: azim
--

COPY lab15.pivoted_sales (product, year_2021, year_2022) FROM stdin;
refrigerator	246.00	299.99
vacuum	0	341.00
computer mouse	0	45.00
washing machine	0	219.80
wireless headset	0	249.90
\.


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: lab16; Owner: azim
--

COPY lab16.accounts (account_id, balance) FROM stdin;
2	2971.50
1	3360.00
\.


--
-- Data for Name: checks; Type: TABLE DATA; Schema: lab16; Owner: azim
--

COPY lab16.checks (check_name, passed, details) FROM stdin;
commit_transfer	t	100 transferred; total remains 6030
rollback_transfer	t	Balances unchanged after ROLLBACK
consistent_total	t	CHECK(balance >= 0) and total = 6030
savepoint_order	t	Alice kept; 500 order rolled back; 300 order committed
savepoint_constraint	t	Negative price rejected (23514); Laptop, Mouse and Keyboard committed
atomic_order_failure	t	FK failure rolls back the preceding order insert
insufficient_funds	t	Transfer rejected before any account changes
no_dirty_read	t	READ UNCOMMITTED sees only committed data in PostgreSQL
read_committed	t	A before=3360.00; A after B commit=3370.00
repeatable_read	t	A before=3360.00; A after B commit=3360.00
serializable_conflict	t	One conflicting transaction rejected with SQLSTATE 40001
lock_observed	t	pg_blocking_pids detected B waiting for A; both rolled back
durability_reconnect	t	Committed balances visible from independent psql connections
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: lab16; Owner: azim
--

COPY lab16.customers (customer_id, name, email) FROM stdin;
1	John Doe	john@email.com
2	Alice	alice@email.com
\.


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: lab16; Owner: azim
--

COPY lab16.inventory (product_id, stock) FROM stdin;
1	9
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: lab16; Owner: azim
--

COPY lab16.logs (message) FROM stdin;
Starting process
Process completed
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: lab16; Owner: azim
--

COPY lab16.order_items (order_id, product_id, quantity) FROM stdin;
1	1	1
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: lab16; Owner: azim
--

COPY lab16.orders (order_id, customer_id, total) FROM stdin;
1	1	100.00
3	2	300.00
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: lab16; Owner: azim
--

COPY lab16.products (product_id, name, price) FROM stdin;
1	Laptop	999.99
2	Mouse	25.99
4	Keyboard	79.99
\.


--
-- Data for Name: checks; Type: TABLE DATA; Schema: lab17; Owner: azim
--

COPY lab17.checks (check_name, passed, details) FROM stdin;
copy_roundtrip	t	8 employee rows, pipe delimiter, NULL=N/A
csv_options	t	UTF8; subset columns; semicolon; FORCE_QUOTE(date); commas/quotes; NULL restored
etl_upsert	t	5 published users extracted, transformed and merged twice without duplicates
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: lab17; Owner: azim
--

COPY lab17.customers (user_id, city, email, signup_date) FROM stdin;
111	San Francisco	rrok10@gmail.com	2021-08-03 12:00:00
148	Boston	sailor9820@gmail.com	2021-08-20 12:00:00
178	San Francisco	harrypotterfan182@gmail.com	2022-01-05 12:00:00
265	Denver	shadower_@hotmail.com	2022-02-26 12:00:00
300	San Francisco	houstoncowboy1122@hotmail.com	2022-06-30 12:00:00
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: lab17; Owner: azim
--

COPY lab17.employees (employee_id, first_name, last_name, salary, department_id, manager_id) FROM stdin;
1	Emma	Thompson	3800.00	1	6
2	Daniel	Rodriguez	2230.00	1	7
3	Olivia	Smith	7000.00	1	8
4	Noah	Johnson	6800.00	2	9
5	Sophia	Martinez	1750.00	1	11
6	Liam	Brown	13000.00	3	\N
7	Ava	Garcia	12500.00	3	\N
8	William	Davis	6800.00	2	\N
\.


--
-- Data for Name: employees_roundtrip; Type: TABLE DATA; Schema: lab17; Owner: azim
--

COPY lab17.employees_roundtrip (employee_id, first_name, last_name, salary, department_id, manager_id) FROM stdin;
1	Emma	Thompson	3800.00	1	6
2	Daniel	Rodriguez	2230.00	1	7
3	Olivia	Smith	7000.00	1	8
4	Noah	Johnson	6800.00	2	9
5	Sophia	Martinez	1750.00	1	11
6	Liam	Brown	13000.00	3	\N
7	Ava	Garcia	12500.00	3	\N
8	William	Davis	6800.00	2	\N
\.


--
-- Data for Name: names_import; Type: TABLE DATA; Schema: lab17; Owner: azim
--

COPY lab17.names_import (first_name, last_name) FROM stdin;
Emma	Thompson
Daniel	Rodriguez
Olivia	Smith
Noah	Johnson
Sophia	Martinez
Liam	Brown
Ava	Garcia
William	Davis
\.


--
-- Data for Name: nullable_import; Type: TABLE DATA; Schema: lab17; Owner: azim
--

COPY lab17.nullable_import (employee_id, first_name, last_name, salary, department_id, manager_id) FROM stdin;
1	Emma	Thompson	3800.00	1	6
2	Daniel	Rodriguez	2230.00	1	7
3	Olivia	Smith	7000.00	1	8
4	Noah	Johnson	6800.00	2	9
5	Sophia	Martinez	1750.00	1	11
6	Liam	Brown	13000.00	3	\N
7	Ava	Garcia	12500.00	3	\N
8	William	Davis	6800.00	2	\N
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: lab17; Owner: azim
--

COPY lab17.orders (order_id, user_id, order_date, total_amount, status) FROM stdin;
100101	111	2022-08-17	98.00	Cancelled
100102	111	2022-08-17	100.00	Completed
100259	148	2022-08-25	178.50	Completed
100264	148	2022-08-26	192.00	Completed
100305	300	2022-09-05	150.00	Completed
100400	178	2022-09-09	148.50	Completed
100565	265	2022-12-19	128.00	Completed
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: lab17; Owner: azim
--

COPY lab17.products (product_name, category, price, transaction_date) FROM stdin;
washing machine	appliance	219.80	2022-03-02 11:00:00
vacuum	electronics	152.00	2022-04-05 10:00:00
wireless headset	electronics	249.90	2022-07-08 10:00:00
vacuum	electronics	189.00	2022-07-15 10:00:00
computer mouse	electronics	45.00	2022-07-01 11:00:00
refrigerator	appliance	246.00	2021-12-26 12:00:00
refrigerator	appliance	299.99	2022-03-02 11:00:00
\.


--
-- Data for Name: products_import; Type: TABLE DATA; Schema: lab17; Owner: azim
--

COPY lab17.products_import (product_name, category, price, transaction_date) FROM stdin;
washing machine	appliance	219.80	2022-03-02 11:00:00
vacuum	electronics	152.00	2022-04-05 10:00:00
wireless headset	electronics	249.90	2022-07-08 10:00:00
vacuum	electronics	189.00	2022-07-15 10:00:00
computer mouse	electronics	45.00	2022-07-01 11:00:00
refrigerator	appliance	246.00	2021-12-26 12:00:00
refrigerator	appliance	299.99	2022-03-02 11:00:00
\.


--
-- Data for Name: products_skip; Type: TABLE DATA; Schema: lab17; Owner: azim
--

COPY lab17.products_skip (product_name, category, price, transaction_date) FROM stdin;
washing machine	appliance	219.80	2022-03-02 11:00:00
vacuum	electronics	152.00	2022-04-05 10:00:00
wireless headset	electronics	249.90	2022-07-08 10:00:00
vacuum	electronics	189.00	2022-07-15 10:00:00
computer mouse	electronics	45.00	2022-07-01 11:00:00
refrigerator	appliance	246.00	2021-12-26 12:00:00
refrigerator	appliance	299.99	2022-03-02 11:00:00
\.


--
-- Data for Name: purchases_2021; Type: TABLE DATA; Schema: lab17; Owner: azim
--

COPY lab17.purchases_2021 (product, spend, sale_date) FROM stdin;
refrigerator	246.00	2021-12-26
\.


--
-- Data for Name: purchases_2022; Type: TABLE DATA; Schema: lab17; Owner: azim
--

COPY lab17.purchases_2022 (product, spend, sale_date) FROM stdin;
washing machine	219.80	2022-03-02
vacuum	152.00	2022-04-05
wireless headset	249.90	2022-07-08
vacuum	189.00	2022-07-15
computer mouse	45.00	2022-07-01
refrigerator	299.99	2022-03-02
\.


--
-- Data for Name: staging_customers; Type: TABLE DATA; Schema: lab17; Owner: azim
--

COPY lab17.staging_customers (user_id, city, email, signup_date) FROM stdin;
111	San Francisco	rrok10@gmail.com	2021-08-03 12:00:00
148	Boston	sailor9820@gmail.com	2021-08-20 12:00:00
178	San Francisco	harrypotterfan182@gmail.com	2022-01-05 12:00:00
265	Denver	shadower_@hotmail.com	2022-02-26 12:00:00
300	San Francisco	houstoncowboy1122@hotmail.com	2022-06-30 12:00:00
\.


--
-- Data for Name: summary_import; Type: TABLE DATA; Schema: lab17; Owner: azim
--

COPY lab17.summary_import (first_name, last_name, summary) FROM stdin;
Emma	Thompson	Emma Thompson, salary="3800.00"
Daniel	Rodriguez	Daniel Rodriguez, salary="2230.00"
Olivia	Smith	Olivia Smith, salary="7000.00"
Noah	Johnson	Noah Johnson, salary="6800.00"
Sophia	Martinez	Sophia Martinez, salary="1750.00"
Liam	Brown	Liam Brown, salary="13000.00"
Ava	Garcia	Ava Garcia, salary="12500.00"
William	Davis	William Davis, salary="6800.00"
\.


--
-- Data for Name: target_customers; Type: TABLE DATA; Schema: lab17; Owner: azim
--

COPY lab17.target_customers (user_id, city, email, signup_date) FROM stdin;
111	San Francisco	rrok10@gmail.com	2021-08-03 12:00:00
148	Boston	sailor9820@gmail.com	2021-08-20 12:00:00
178	San Francisco	harrypotterfan182@gmail.com	2022-01-05 12:00:00
265	Denver	shadower_@hotmail.com	2022-02-26 12:00:00
300	San Francisco	houstoncowboy1122@hotmail.com	2022-06-30 12:00:00
\.


--
-- Data for Name: artists; Type: TABLE DATA; Schema: lab_data; Owner: azim
--

COPY lab_data.artists (artist_id, artist_name, label_owner) FROM stdin;
101	Ed Sheeran	Warner Music Group
120	Drake	Warner Music Group
125	Bad Bunny	Rimas Entertainment
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: lab_data; Owner: azim
--

COPY lab_data.employee (employee_id, name, salary, department_id, manager_id) FROM stdin;
1	Emma Thompson	3800.00	1	6
2	Daniel Rodriguez	2230.00	1	7
3	Olivia Smith	7000.00	1	8
4	Noah Johnson	6800.00	2	9
5	Sophia Martinez	1750.00	1	11
6	Liam Brown	13000.00	3	\N
7	Ava Garcia	12500.00	3	\N
8	William Davis	6800.00	2	\N
\.


--
-- Data for Name: purchases; Type: TABLE DATA; Schema: lab_data; Owner: azim
--

COPY lab_data.purchases (category, product, user_id, spend, transaction_date) FROM stdin;
appliance	washing machine	123	219.80	2022-03-02 11:00:00
electronics	vacuum	178	152.00	2022-04-05 10:00:00
electronics	wireless headset	156	249.90	2022-07-08 10:00:00
electronics	vacuum	145	189.00	2022-07-15 10:00:00
electronics	computer mouse	195	45.00	2022-07-01 11:00:00
appliance	refrigerator	165	246.00	2021-12-26 12:00:00
appliance	refrigerator	123	299.99	2022-03-02 11:00:00
\.


--
-- Data for Name: songs; Type: TABLE DATA; Schema: lab_data; Owner: azim
--

COPY lab_data.songs (song_id, artist_id, name) FROM stdin;
55511	101	Perfect
45202	101	Shape of You
22222	120	One Dance
19960	120	Hotline Bling
\.


--
-- Data for Name: trades; Type: TABLE DATA; Schema: lab_data; Owner: azim
--

COPY lab_data.trades (order_id, user_id, price, quantity, status, traded_at) FROM stdin;
100101	111	9.80	10	Cancelled	2022-08-17 12:00:00
100102	111	10.00	10	Completed	2022-08-17 12:00:00
100259	148	5.10	35	Completed	2022-08-25 12:00:00
100264	148	4.80	40	Completed	2022-08-26 12:00:00
100305	300	10.00	15	Completed	2022-09-05 12:00:00
100400	178	9.90	15	Completed	2022-09-09 12:00:00
100565	265	25.60	5	Completed	2022-12-19 12:00:00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: lab_data; Owner: azim
--

COPY lab_data.users (user_id, city, email, signup_date) FROM stdin;
111	San Francisco	rrok10@gmail.com	2021-08-03 12:00:00
148	Boston	sailor9820@gmail.com	2021-08-20 12:00:00
178	San Francisco	harrypotterfan182@gmail.com	2022-01-05 12:00:00
265	Denver	shadower_@hotmail.com	2022-02-26 12:00:00
300	San Francisco	houstoncowboy1122@hotmail.com	2022-06-30 12:00:00
\.


--
-- Name: students_student_id_seq; Type: SEQUENCE SET; Schema: lab11; Owner: azim
--

SELECT pg_catalog.setval('lab11.students_student_id_seq', 7, true);


--
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: lab16; Owner: azim
--

SELECT pg_catalog.setval('lab16.customers_customer_id_seq', 2, true);


--
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: lab16; Owner: azim
--

SELECT pg_catalog.setval('lab16.orders_order_id_seq', 4, true);


--
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: lab16; Owner: azim
--

SELECT pg_catalog.setval('lab16.products_product_id_seq', 4, true);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: lab11; Owner: azim
--

ALTER TABLE ONLY lab11.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: lab16; Owner: azim
--

ALTER TABLE ONLY lab16.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (account_id);


--
-- Name: checks checks_pkey; Type: CONSTRAINT; Schema: lab16; Owner: azim
--

ALTER TABLE ONLY lab16.checks
    ADD CONSTRAINT checks_pkey PRIMARY KEY (check_name);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: lab16; Owner: azim
--

ALTER TABLE ONLY lab16.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: lab16; Owner: azim
--

ALTER TABLE ONLY lab16.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (product_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: lab16; Owner: azim
--

ALTER TABLE ONLY lab16.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: lab16; Owner: azim
--

ALTER TABLE ONLY lab16.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- Name: checks checks_pkey; Type: CONSTRAINT; Schema: lab17; Owner: azim
--

ALTER TABLE ONLY lab17.checks
    ADD CONSTRAINT checks_pkey PRIMARY KEY (check_name);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: lab17; Owner: azim
--

ALTER TABLE ONLY lab17.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (user_id);


--
-- Name: staging_customers staging_customers_pkey; Type: CONSTRAINT; Schema: lab17; Owner: azim
--

ALTER TABLE ONLY lab17.staging_customers
    ADD CONSTRAINT staging_customers_pkey PRIMARY KEY (user_id);


--
-- Name: target_customers target_customers_pkey; Type: CONSTRAINT; Schema: lab17; Owner: azim
--

ALTER TABLE ONLY lab17.target_customers
    ADD CONSTRAINT target_customers_pkey PRIMARY KEY (user_id);


--
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: lab_data; Owner: azim
--

ALTER TABLE ONLY lab_data.artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (artist_id);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: lab_data; Owner: azim
--

ALTER TABLE ONLY lab_data.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employee_id);


--
-- Name: songs songs_pkey; Type: CONSTRAINT; Schema: lab_data; Owner: azim
--

ALTER TABLE ONLY lab_data.songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (song_id);


--
-- Name: trades trades_pkey; Type: CONSTRAINT; Schema: lab_data; Owner: azim
--

ALTER TABLE ONLY lab_data.trades
    ADD CONSTRAINT trades_pkey PRIMARY KEY (order_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: lab_data; Owner: azim
--

ALTER TABLE ONLY lab_data.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: idx_employee_manager_id; Type: INDEX; Schema: lab_data; Owner: azim
--

CREATE INDEX idx_employee_manager_id ON lab_data.employee USING btree (manager_id);


--
-- Name: idx_purchases_category; Type: INDEX; Schema: lab_data; Owner: azim
--

CREATE INDEX idx_purchases_category ON lab_data.purchases USING btree (category);


--
-- Name: idx_songs_artist_id; Type: INDEX; Schema: lab_data; Owner: azim
--

CREATE INDEX idx_songs_artist_id ON lab_data.songs USING btree (artist_id);


--
-- Name: idx_trades_user_id; Type: INDEX; Schema: lab_data; Owner: azim
--

CREATE INDEX idx_trades_user_id ON lab_data.trades USING btree (user_id);


--
-- Name: inventory inventory_product_id_fkey; Type: FK CONSTRAINT; Schema: lab16; Owner: azim
--

ALTER TABLE ONLY lab16.inventory
    ADD CONSTRAINT inventory_product_id_fkey FOREIGN KEY (product_id) REFERENCES lab16.products(product_id);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: lab16; Owner: azim
--

ALTER TABLE ONLY lab16.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES lab16.orders(order_id);


--
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: lab16; Owner: azim
--

ALTER TABLE ONLY lab16.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES lab16.products(product_id);


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: lab16; Owner: azim
--

ALTER TABLE ONLY lab16.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES lab16.customers(customer_id);


--
-- Name: songs songs_artist_id_fkey; Type: FK CONSTRAINT; Schema: lab_data; Owner: azim
--

ALTER TABLE ONLY lab_data.songs
    ADD CONSTRAINT songs_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES lab_data.artists(artist_id);


--
-- Name: trades trades_user_id_fkey; Type: FK CONSTRAINT; Schema: lab_data; Owner: azim
--

ALTER TABLE ONLY lab_data.trades
    ADD CONSTRAINT trades_user_id_fkey FOREIGN KEY (user_id) REFERENCES lab_data.users(user_id);


--
-- PostgreSQL database dump complete
--

\unrestrict nIxqlJSWY3cphu3iOk65YZw6nioygpRvkpKlRUvZulFKn9ltBteSzHpODQwZhTs

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict N9OYoIsX82dtXObJnNtunrAkgjOVbN6jhcpjSgaPG4SHj6JvjFKZMpvhIlvJEnP

-- Dumped from database version 18.6 (Homebrew)
-- Dumped by pg_dump version 18.6 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

\unrestrict N9OYoIsX82dtXObJnNtunrAkgjOVbN6jhcpjSgaPG4SHj6JvjFKZMpvhIlvJEnP

--
-- PostgreSQL database cluster dump complete
--

