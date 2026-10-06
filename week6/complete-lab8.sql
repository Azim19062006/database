\set ON_ERROR_STOP on
\connect university

-- Complete the existing lab8 schema without dropping earlier results.
BEGIN;
CREATE TABLE lab8.student_profiles_shared_pk (
    student_id INTEGER PRIMARY KEY REFERENCES lab8.students(student_id)
        ON DELETE CASCADE
);
INSERT INTO lab8.departments (dept_id, dept_name)
VALUES (2, 'Mathematics');
INSERT INTO lab8.professors (department_id) VALUES (1);
UPDATE lab8.courses
SET professor_id = (SELECT MIN(professor_id) FROM lab8.professors)
WHERE course_id = 101;
UPDATE lab8.courses SET department_id = 2 WHERE course_id = 102;
INSERT INTO lab8.student_profiles (student_id) VALUES (1);
INSERT INTO lab8.student_profiles_shared_pk (student_id) VALUES (2);
COMMIT;
