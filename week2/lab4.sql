\set ON_ERROR_STOP on
\connect university

SELECT COUNT(*) AS total_students FROM students;

SELECT * FROM students;

SELECT first_name AS name, email FROM students;

SELECT student_id, faculty FROM students;

SELECT first_name AS name, email
FROM students
WHERE first_name = 'Timur';

SELECT first_name AS name, email
FROM students
ORDER BY first_name;

SELECT first_name AS name, email
FROM students
ORDER BY first_name, student_id
LIMIT 2;

SELECT first_name AS name, faculty
FROM students
WHERE faculty = 'Engineering';
