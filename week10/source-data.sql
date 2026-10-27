\set ON_ERROR_STOP on
-- Only published example rows from DataLemur; URLs and subset limits in DATA.md.
BEGIN;
CREATE SCHEMA lab_data;
SET LOCAL search_path TO lab_data;
CREATE TABLE employee (
    employee_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    salary NUMERIC(12,2) NOT NULL,
    department_id INTEGER,
    manager_id INTEGER
);
-- No manager FK: source example refers to absent managers 9 and 11.
INSERT INTO employee VALUES
(1, 'Emma Thompson', 3800, 1, 6),
(2, 'Daniel Rodriguez', 2230, 1, 7),
(3, 'Olivia Smith', 7000, 1, 8),
(4, 'Noah Johnson', 6800, 2, 9),
(5, 'Sophia Martinez', 1750, 1, 11),
(6, 'Liam Brown', 13000, 3, NULL),
(7, 'Ava Garcia', 12500, 3, NULL),
(8, 'William Davis', 6800, 2, NULL);
CREATE TABLE purchases (
    category TEXT, product TEXT, user_id INTEGER,
    spend NUMERIC(10,2), transaction_date TIMESTAMP
);
INSERT INTO purchases VALUES
('appliance','washing machine',123,219.80,'2022-03-02 11:00:00'),
('electronics','vacuum',178,152.00,'2022-04-05 10:00:00'),
('electronics','wireless headset',156,249.90,'2022-07-08 10:00:00'),
('electronics','vacuum',145,189.00,'2022-07-15 10:00:00'),
('electronics','computer mouse',195,45.00,'2022-07-01 11:00:00'),
('appliance','refrigerator',165,246.00,'2021-12-26 12:00:00'),
('appliance','refrigerator',123,299.99,'2022-03-02 11:00:00');
CREATE TABLE artists (artist_id INTEGER PRIMARY KEY, artist_name TEXT, label_owner TEXT);
CREATE TABLE songs (song_id INTEGER PRIMARY KEY, artist_id INTEGER REFERENCES artists, name TEXT);
INSERT INTO artists VALUES
(101,'Ed Sheeran','Warner Music Group'),
(120,'Drake','Warner Music Group'),
(125,'Bad Bunny','Rimas Entertainment');
INSERT INTO songs VALUES
(55511,101,'Perfect'),(45202,101,'Shape of You'),
(22222,120,'One Dance'),(19960,120,'Hotline Bling');
CREATE TABLE users (
    user_id INTEGER PRIMARY KEY, city TEXT, email TEXT, signup_date TIMESTAMP
);
CREATE TABLE trades (
    order_id INTEGER PRIMARY KEY, user_id INTEGER REFERENCES users,
    price NUMERIC(10,2), quantity INTEGER, status TEXT, traded_at TIMESTAMP
);
INSERT INTO users VALUES
(111,'San Francisco','rrok10@gmail.com','2021-08-03 12:00:00'),
(148,'Boston','sailor9820@gmail.com','2021-08-20 12:00:00'),
(178,'San Francisco','harrypotterfan182@gmail.com','2022-01-05 12:00:00'),
(265,'Denver','shadower_@hotmail.com','2022-02-26 12:00:00'),
(300,'San Francisco','houstoncowboy1122@hotmail.com','2022-06-30 12:00:00');
INSERT INTO trades VALUES
(100101,111,9.80,10,'Cancelled','2022-08-17 12:00:00'),
(100102,111,10.00,10,'Completed','2022-08-17 12:00:00'),
(100259,148,5.10,35,'Completed','2022-08-25 12:00:00'),
(100264,148,4.80,40,'Completed','2022-08-26 12:00:00'),
(100305,300,10.00,15,'Completed','2022-09-05 12:00:00'),
(100400,178,9.90,15,'Completed','2022-09-09 12:00:00'),
(100565,265,25.60,5,'Completed','2022-12-19 12:00:00');
COMMIT;
