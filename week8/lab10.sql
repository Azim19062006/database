\set ON_ERROR_STOP on
\connect university

\dt public.*
\dt lab7.*
\dt lab8.*
\dt lab9.*

\d public.students
\d lab7.course_enrollments
\d lab8.enrollments
\d lab9.book_authors
\d lab9.loans

SELECT c.conrelid::regclass AS child_table,
       c.confrelid::regclass AS parent_table,
       c.conname AS foreign_key
FROM pg_constraint c
JOIN pg_namespace n ON n.oid = c.connamespace
WHERE n.nspname IN ('lab8', 'lab9') AND c.contype = 'f'
ORDER BY c.conrelid::regclass::text, c.confrelid::regclass::text;
