\set ON_ERROR_STOP on
\connect university

-- Bring the already-created, empty lab9 tables in line with the source example.
BEGIN;
ALTER TABLE lab9.authors
    ALTER COLUMN first_name TYPE VARCHAR(50),
    ALTER COLUMN last_name TYPE VARCHAR(50),
    ADD COLUMN birth_date DATE;

ALTER TABLE lab9.books
    ALTER COLUMN isbn TYPE VARCHAR(13),
    ADD COLUMN publication_year INTEGER,
    ADD COLUMN available_copies INTEGER DEFAULT 1;

ALTER TABLE lab9.members
    ALTER COLUMN first_name TYPE VARCHAR(50),
    ALTER COLUMN last_name TYPE VARCHAR(50),
    ALTER COLUMN email TYPE VARCHAR(100),
    ADD COLUMN phone VARCHAR(15),
    ADD COLUMN membership_date DATE DEFAULT CURRENT_DATE;

ALTER TABLE lab9.loans RENAME COLUMN borrowed_on TO loan_date;
ALTER TABLE lab9.loans RENAME COLUMN due_on TO due_date;
ALTER TABLE lab9.loans RENAME COLUMN returned_on TO return_date;
ALTER TABLE lab9.loans ADD COLUMN late_fee DECIMAL(10,2) DEFAULT 0.00;
ALTER TABLE lab9.loans ADD CONSTRAINT loans_late_fee_nonnegative CHECK (late_fee >= 0);
ALTER INDEX lab9.loans_due_on_idx RENAME TO loans_due_date_idx;
COMMIT;
