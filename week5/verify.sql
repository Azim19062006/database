\set ON_ERROR_STOP on
\connect university

\dt lab7.*
\d lab7.students
\d lab7.course_enrollments

SELECT student_id, name, faculty FROM lab7.students ORDER BY student_id;
SELECT student_id, course_id, semester, grade
FROM lab7.course_enrollments ORDER BY student_id, course_id, semester;
SELECT dept_id, dept_name FROM lab7.departments ORDER BY dept_id;

SELECT c.relname AS table_name, con.conname AS primary_key,
       pg_get_constraintdef(con.oid) AS definition
FROM pg_constraint con
JOIN pg_class c ON c.oid = con.conrelid
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'lab7' AND con.contype = 'p'
ORDER BY c.relname;
