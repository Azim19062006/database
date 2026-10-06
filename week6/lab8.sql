\set ON_ERROR_STOP on
\connect university

BEGIN;
CREATE SCHEMA lab8;
SET search_path TO lab8;

CREATE TABLE students (
    student_id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);
INSERT INTO students (student_id, name)
SELECT student_id, name FROM lab7.students;

CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);
INSERT INTO departments (dept_id, dept_name)
SELECT dept_id, dept_name FROM lab7.departments;

CREATE TABLE professors (
    professor_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_id INTEGER NOT NULL REFERENCES departments(dept_id) ON DELETE RESTRICT
);

CREATE TABLE courses (
    course_id INTEGER PRIMARY KEY,
    department_id INTEGER NOT NULL DEFAULT 1,
    professor_id INTEGER,
    CONSTRAINT courses_department_fk FOREIGN KEY (department_id)
        REFERENCES departments(dept_id) ON DELETE SET DEFAULT,
    CONSTRAINT courses_professor_fk FOREIGN KEY (professor_id)
        REFERENCES professors(professor_id) ON DELETE SET NULL
);
INSERT INTO courses (course_id)
SELECT DISTINCT course_id FROM lab7.course_enrollments;

CREATE TABLE student_profiles (
    profile_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INTEGER NOT NULL UNIQUE REFERENCES students(student_id)
        ON DELETE CASCADE
);

CREATE TABLE student_profiles_shared_pk (
    student_id INTEGER PRIMARY KEY REFERENCES students(student_id)
        ON DELETE CASCADE
);

CREATE TABLE enrollments (
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    semester VARCHAR(20) NOT NULL,
    grade CHAR(2),
    CONSTRAINT enrollments_pkey PRIMARY KEY (student_id, course_id, semester),
    CONSTRAINT enrollments_student_fk FOREIGN KEY (student_id)
        REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE enrollments
    ADD CONSTRAINT enrollments_course_fk FOREIGN KEY (course_id)
    REFERENCES courses(course_id) ON DELETE CASCADE;

INSERT INTO enrollments (student_id, course_id, semester, grade)
SELECT student_id, course_id, semester, grade
FROM lab7.course_enrollments;

INSERT INTO departments (dept_id, dept_name) VALUES (2, 'Mathematics');
INSERT INTO professors (department_id) VALUES (1);
UPDATE courses
SET professor_id = (SELECT MIN(professor_id) FROM professors)
WHERE course_id = 101;
UPDATE courses SET department_id = 2 WHERE course_id = 102;
INSERT INTO student_profiles (student_id) VALUES (1);
INSERT INTO student_profiles_shared_pk (student_id) VALUES (2);

DO $$
BEGIN
    BEGIN
        INSERT INTO enrollments (student_id, course_id, semester)
        VALUES ((SELECT MAX(student_id) + 1 FROM students), 101, '2024-Spring');
        RAISE EXCEPTION 'Invalid foreign key was accepted';
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'Invalid foreign key was rejected';
    END;
END $$;

COMMIT;
