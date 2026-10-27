--
-- PostgreSQL database dump
--

\restrict 3ndsneM0erdTE3eM4G0tQzJwV5Jtw4BqOIuiaGImMIwYhRMuLZ5cQ6e88kWx42S

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

\unrestrict 3ndsneM0erdTE3eM4G0tQzJwV5Jtw4BqOIuiaGImMIwYhRMuLZ5cQ6e88kWx42S

