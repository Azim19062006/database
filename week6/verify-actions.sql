\set ON_ERROR_STOP on
\connect university

\echo 'ON DELETE CASCADE: dependent enrollments and profile disappear in the transaction'
BEGIN;
DELETE FROM lab8.students WHERE student_id = 1;
SELECT count(*) = 0 AS cascade_enrollments_ok
FROM lab8.enrollments WHERE student_id = 1;
SELECT count(*) = 0 AS cascade_profile_ok
FROM lab8.student_profiles WHERE student_id = 1;
ROLLBACK;

\echo 'ON DELETE SET NULL: course keeps its row, professor reference becomes NULL'
BEGIN;
DELETE FROM lab8.professors WHERE professor_id = 1;
SELECT professor_id IS NULL AS set_null_ok
FROM lab8.courses WHERE course_id = 101;
ROLLBACK;

\echo 'ON DELETE SET DEFAULT: course moves from department 2 to default department 1'
BEGIN;
DELETE FROM lab8.departments WHERE dept_id = 2;
SELECT department_id = 1 AS set_default_ok
FROM lab8.courses WHERE course_id = 102;
ROLLBACK;

\echo 'ON DELETE RESTRICT: referenced department cannot be removed'
DO $$
BEGIN
    BEGIN
        DELETE FROM lab8.departments WHERE dept_id = 1;
        RAISE EXCEPTION 'RESTRICT was not enforced';
    EXCEPTION WHEN restrict_violation THEN
        RAISE NOTICE 'RESTRICT rejected deleting department 1';
    END;
END $$;

\echo 'ON UPDATE CASCADE: changing student ID updates enrollment FK'
BEGIN;
DELETE FROM lab8.student_profiles WHERE student_id = 1;
UPDATE lab8.students SET student_id = 10 WHERE student_id = 1;
SELECT count(*) = 3 AS update_cascade_ok
FROM lab8.enrollments WHERE student_id = 10;
ROLLBACK;
