--
-- PostgreSQL database dump
--

\restrict gf33Gc7Lq25noySSSRRuFeIcJQzyJb8fH1BxYTETt64bTy17PkYanyIjTUL6f7C

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
-- Data for Name: products; Type: TABLE DATA; Schema: lab16; Owner: azim
--

COPY lab16.products (product_id, name, price) FROM stdin;
1	Laptop	999.99
2	Mouse	25.99
4	Keyboard	79.99
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
-- Data for Name: orders; Type: TABLE DATA; Schema: lab16; Owner: azim
--

COPY lab16.orders (order_id, customer_id, total) FROM stdin;
1	1	100.00
3	2	300.00
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: lab16; Owner: azim
--

COPY lab16.order_items (order_id, product_id, quantity) FROM stdin;
1	1	1
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
-- PostgreSQL database dump complete
--

\unrestrict gf33Gc7Lq25noySSSRRuFeIcJQzyJb8fH1BxYTETt64bTy17PkYanyIjTUL6f7C

