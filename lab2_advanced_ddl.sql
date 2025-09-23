--Task1.1
CREATE DATABASE university_main
OWNER postgres
ENCODING 'UTF8';

CREATE DATABASE university_archive
OWNER postgres
CONNECTION LIMIT 10;

CREATE DATABASE university_test
OWNER postgres
ENCODING 'UTF8';
--Task1.2
CREATE TABLESPACE student_data
LOCATION 'C:\\data\\students';

CREATE TABLESPACE course_data
LOCATION 'C:\\data\\students';

CREATE DATABASE university_distributed
OWNER postgres
TABLESPACE student_data
ENCODING 'LATIN9';
--Task2.1
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone INTEGER,
    date_of_birth DATE,
    enrollment_day DATE,
    gpa DECIMAL(10, 2),
    is_active BOOLEAN,
    graduation_year INTEGER
);

CREATE TABLE professors (
    professor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    office_number VARCHAR(20),
    hire_date DATE,
    salary DECIMAL(10, 2),
    is_turned BOOLEAN,
    years_experience INTEGER
);

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_code CHAR(8),
    course_title VARCHAR(100),
    description TEXT,
    credits INTEGER,
    max_enrollment INTEGER,
    course_fee DECIMAL(10, 2),
    is_online BOOLEAN,
    created_at TIMESTAMP WITHOUT TIME ZONE
);
--Task2.2
CREATE TABLE class_schedule (
    schedule_id SERIAL PRIMARY KEY,
    course_id INTEGER REFERENCES courses(course_id),
    professor_id INTEGER REFERENCES professors(professor_id),
    classroom VARCHAR(20),
    class_date DATE,
    start_time TIMESTAMP WITHOUT TIME ZONE,
    end_time TIMESTAMP WITHOUT TIME ZONE,
    duration INTERVAL

);

CREATE TABLE student_records (
    record_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    semester VARCHAR(20),
    year INTEGER,
    grade CHAR(2),
    attendance_percentage NUMERIC(5, 1),
    submission_timestamp TIMESTAMP WITHOUT TIME ZONE,
    last_update TIMESTAMP WITHOUT TIME ZONE
);
--Task3.1
ALTER TABLE students
    ADD COLUMN middle_name VARCHAR(30),
    ADD COLUMN student_status VARCHAR(20),
    ALTER COLUMN phone TYPE VARCHAR(20),
    ALTER COLUMN student_status SET DEFAULT 'ACTIVE',
    ALTER COLUMN gpa SET DEFAULT 0.00;

ALTER TABLE professors
    ADD COLUMN department_id CHAR(5),
    ADD COLUMN research_area TEXT,
    ALTER COLUMN years_experience TYPE SMALLINT,
    ALTER COLUMN is_turned SET DEFAULT 'FALSE',
    ADD COLUMN last_promotion_date DATE;

ALTER TABLE courses
    ADD COLUMN prerequisite_course_id INTEGER,
    ADD COLUMN difficulty_level SMALLINT,
    ALTER COLUMN course_code TYPE VARCHAR(10),
    ALTER COLUMN credits SET DEFAULT 3,
    ADD COLUMN lab_required BOOLEAN DEFAULT FALSE;
--Task3.2
ALTER TABLE class_schedule
    ADD COLUMN room_capacity INTEGER,
    DROP COLUMN duration,
    ADD COLUMN session_type VARCHAR(15),
    ALTER COLUMN classroom TYPE VARCHAR(30),
    ADD COLUMN equipment_needed TEXT;

ALTER TABLE student_records
    ADD COLUMN extra_credit_points NUMERIC(5, 1),
    ALTER COLUMN grade TYPE VARCHAR(5),
    ALTER COLUMN extra_credit_points SET DEFAULT 0.00,
    ADD COLUMN final_exam_date DATE,
    DROP COLUMN last_update;
--Task4.1
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100),
    department_code CHAR(5),
    building VARCHAR(50),
    phone VARCHAR(15),
    budget DECIMAL(10, 2),
    established_year INTEGER
);


CREATE TABLE library_books (
    book_id SERIAL PRIMARY KEY,
    isbn CHAR(13),
    title VARCHAR(200),
    author VARCHAR(100),
    publisher VARCHAR(100),
    publication_date DATE,
    price DECIMAL(10, 2),
    is_available BOOLEAN,
    acquisition_timestamp TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE student_book_loans (
    loan_id SERIAL PRIMARY KEY,
    student_id INTEGER,
    book_id INTEGER,
    loan_date DATE,
    due_date DATE,
    return_date DATE,
    fine_amount DECIMAL(10, 2),
    loan_status VARCHAR(20)
);
--Task4.2
ALTER TABLE professors
ADD COLUMN department_id INTEGER;


ALTER TABLE students
ADD COLUMN advisor_id INTEGER;


ALTER TABLE courses
ADD COLUMN department_id INTEGER;

CREATE TABLE grade_scale(
    garde_id SERIAL PRIMARY KEY,
    letter_grade CHAR(2),
    min_percentage DECIMAL(5, 1),
    max_percentage DECIMAL(5, 1),
    gpa_points DECIMAL(3, 2)
);

CREATE TABLE semester_calendar(
    semester_id SERIAL PRIMARY KEY ,
    semester_name VARCHAR(20),
    academic_year INTEGER,
    start_date DATE,
    end_date DATE,
    registration_deadline TIMESTAMP WITH TIME ZONE,
    is_current BOOLEAN
);

ALTER TABLE student_records
    ALTER COLUMN submission_timestamp TYPE TIMESTAMP WITH TIME ZONE;
--Tas5.1
DROP TABLE IF EXISTS student_book_loans;
DROP TABLE IF EXISTS library_books;
DROP TABLE IF EXISTS grade_scale;

CREATE TABLE grade_scale(
    garde_id SERIAL PRIMARY KEY,
    letter_grade CHAR(2),
    min_percentage DECIMAL(5, 1),
    max_percentage DECIMAL(5, 1),
    gpa_points DECIMAL(3, 2),
    description TEXT
);

DROP TABLE IF EXISTS semester_calendar CASCADE;
--Task5.2
DROP DATABASE IF EXISTS university_test;
DROP DATABASE IF EXISTS university_distributed;

CREATE DATABASE university_backup TEMPLATE university_main;
