\set ON_ERROR_STOP on
\connect university

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    faculty VARCHAR(100)
);

\dt
\d students

CREATE TABLE test_table (id INTEGER);
ALTER TABLE test_table ADD COLUMN name VARCHAR(50);
ALTER TABLE test_table ALTER COLUMN name TYPE TEXT;
ALTER TABLE test_table ADD CONSTRAINT test_table_id_positive CHECK (id > 0);
ALTER TABLE test_table RENAME COLUMN name TO label;
ALTER TABLE test_table DROP COLUMN label;
ALTER TABLE test_table RENAME TO test_table_renamed;
ALTER TABLE test_table_renamed RENAME TO test_table;
DROP TABLE test_table;
DROP TABLE IF EXISTS test_table;

CREATE TEMP TABLE temp_table_name (column1 INTEGER);
\dt
