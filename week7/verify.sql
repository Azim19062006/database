\set ON_ERROR_STOP on
\connect university

\dt lab9.*
\d lab9.book_authors
\d lab9.loans

SELECT c.conrelid::regclass AS table_name, c.conname AS constraint_name,
       CASE c.contype
           WHEN 'p' THEN 'PRIMARY KEY'
           WHEN 'f' THEN 'FOREIGN KEY'
           WHEN 'c' THEN 'CHECK'
       END AS constraint_type
FROM pg_constraint c
JOIN pg_namespace n ON n.oid = c.connamespace
WHERE n.nspname = 'lab9' AND c.contype IN ('p', 'f', 'c')
ORDER BY c.conrelid::regclass::text, c.conname;
