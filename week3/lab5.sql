\set ON_ERROR_STOP on
\connect postgres
DROP DATABASE university;
CREATE DATABASE university;
\l university
\connect university
SELECT current_database();
