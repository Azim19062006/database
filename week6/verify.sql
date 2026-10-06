\set ON_ERROR_STOP on
\connect university

\dt lab8.*
\d lab8.enrollments
\d lab8.student_profiles

SELECT s.name, e.course_id, e.semester, e.grade
FROM lab8.enrollments e
JOIN lab8.students s USING (student_id)
ORDER BY s.name, e.course_id, e.semester;

SELECT c.conrelid::regclass AS child_table,
       c.confrelid::regclass AS parent_table,
       CASE c.confdeltype
           WHEN 'c' THEN 'CASCADE'
           WHEN 'n' THEN 'SET NULL'
           WHEN 'd' THEN 'SET DEFAULT'
           WHEN 'r' THEN 'RESTRICT'
           ELSE 'NO ACTION'
       END AS on_delete,
       CASE c.confupdtype
           WHEN 'c' THEN 'CASCADE'
           ELSE 'NO ACTION'
       END AS on_update
FROM pg_constraint c
JOIN pg_namespace n ON n.oid = c.connamespace
WHERE n.nspname = 'lab8' AND c.contype = 'f'
ORDER BY c.conrelid::regclass::text, c.conname;
