\set ON_ERROR_STOP on
\pset pager off
\echo 'Lab 11. Basic Data Operations'
BEGIN;
CREATE SCHEMA lab11;
SET LOCAL search_path TO lab11;
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE
);
\echo '11.1 INSERT one row and several rows (source values)'
INSERT INTO students (first_name, last_name, birth_date)
VALUES ('Aibek', 'Sharshenov', '2002-05-12');
INSERT INTO students (first_name, last_name, birth_date) VALUES
('Ainura', 'Toktomamatova', '2001-09-23'),
('Bakyt', 'Mamatov', '2003-01-15'),
('Gulzat', 'Sultanova', '2002-07-30');
SELECT * FROM students ORDER BY student_id;
\echo '11.2 UPDATE with WHERE'
UPDATE students SET birth_date = '2002-05-15'
WHERE first_name = 'Aibek' AND last_name = 'Sharshenov'
RETURNING *;
\echo '11.3 DELETE with WHERE and date condition'
DELETE FROM students
WHERE first_name = 'Gulzat' AND last_name = 'Sultanova'
RETURNING *;
DELETE FROM students WHERE birth_date < '2002-01-01' RETURNING *;
\echo '11.4 COPY the three CSV rows from the source document'
COPY students(first_name, last_name, birth_date)
FROM :'students_csv' WITH (FORMAT csv, HEADER true);
SELECT * FROM students ORDER BY student_id;
\echo '11.5 Bulk UPDATE and DELETE'
UPDATE students SET last_name = 'Bekov'
WHERE last_name IN ('Uulu', 'Isakov') RETURNING *;
DELETE FROM students WHERE student_id IN (2, 3, 5) RETURNING *;
COMMIT;
\echo '11.6 Final committed rows'
SELECT * FROM lab11.students ORDER BY student_id;
