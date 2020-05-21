/*
Hyunwoo Choi
April 24 3030
POSGRESQL

PART1 Environment Setting
1. CREATE DATABASE dbname 

reset schema:
drop schema public cascade;
create schema public;

May 7 - Thu: 13.00 - 13.15	
Hyunwoo Choi
 */
CREATE TABLE IF NOT EXISTS Department (
    index SERIAL UNIQUE,
    dept varchar(30) NOT NULL,
    PRIMARY KEY (dept)
);

CREATE TABLE IF NOT EXISTS Courses (
    index SERIAL UNIQUE,
    course_dept varchar(30) NOT NULL,
    course_number varchar(30) NOT NULL,
    consent boolean DEFAULT FALSE,
    lab boolean DEFAULT FALSE,
    min_unit integer DEFAULT 2,
    max_unit integer DEFAULT 4,
    grade_option varchar(30) DEFAULT 'either',
    PRIMARY KEY (course_dept, course_number)
);

CREATE TABLE IF NOT EXISTS Classes (
    index SERIAL UNIQUE,
    class_dept varchar(30) NOT NULL,
    class_number varchar(30) NOT NULL,
    class_title varchar(100) NOT NULL,
    class_quarter varchar(30) NOT NULL,
    class_year varchar(4) NOT NULL,
    PRIMARY KEY (class_dept, class_number, class_quarter, class_year),
    FOREIGN KEY (class_dept, class_number) REFERENCES Courses (course_dept, course_number)
);

CREATE TABLE IF NOT EXISTS Degree (
    index SERIAL UNIQUE,
    degree_name varchar(30) NOT NULL,
    degree_type varchar(30) NOT NULL,
    degree_dept varchar(30),
    total_unit integer NOT NULL,
    lower_unit integer NOT NULL,
    upper_unit integer NOT NULL,
    tech_unit integer NOT NULL,
    grad_unit integer DEFAULT 0,
    PRIMARY KEY (degree_name, degree_type)
);

CREATE TABLE IF NOT EXISTS Student (
    index SERIAL UNIQUE,
    student_id varchar(30) NOT NULL,
    first_name varchar(30) NOT NULL,
    last_name varchar(30) NOT NULL,
    middle_name varchar(30),
    student_ssn varchar(30) NOT NULL UNIQUE,
    student_residency varchar(30) NOT NULL,
    student_type varchar(30) NOT NULL,
    PRIMARY KEY (student_id)
);


/* 
INSERT INTO student( student_id,first_name,last_name,student_ssn,student_residency) VALUES ("a91407351","Hyunwoo", "Choi", "1234", "Internationol");
 */
CREATE TABLE IF NOT EXISTS Undergraduate (
    index SERIAL UNIQUE,
    pid varchar(30) NOT NULL REFERENCES Student (student_id),
    college varchar(30) NOT NULL,
    major varchar(30) NOT NULL,
    minor varchar(30),
    degree_type varchar(30) NOT NULL,
    degree_name varchar(30) NOT NULL,
    PRIMARY KEY (pid),
    FOREIGN KEY (degree_type, degree_name) REFERENCES Degree (degree_type, degree_name)
);

CREATE TABLE IF NOT EXISTS Faculty (
    index SERIAL UNIQUE,
    firstname varchar(30) NOT NULL,
    lastname varchar(30) NOT NULL,
    faculty_type varchar(30) NOT NULL,
    PRIMARY KEY (firstname, lastname, faculty_type)
);

CREATE TABLE IF NOT EXISTS Section (
    index SERIAL UNIQUE,
    section_id varchar(30) NOT NULL,
    class_id integer NOT NULL,
    seats integer NOT NULL,
    PRIMARY KEY (section_id),
    FOREIGN KEY (class_id) REFERENCES Classes (INDEX)
);

CREATE TABLE IF NOT EXISTS Phd (
    index SERIAL UNIQUE,
    pid varchar(30) NOT NULL REFERENCES Student (student_id),
    phd_type varchar(30) NOT NULL,
    PRIMARY KEY (pid)
);

CREATE TABLE IF NOT EXISTS MS (
    index SERIAL UNIQUE,
    pid varchar(30) NOT NULL REFERENCES Student (student_id),
    dept varchar(30) NOT NULL,
    degree_type varchar(30) NOT NULL,
    degree_name varchar(30) NOT NULL,
    PRIMARY KEY (pid),
    FOREIGN KEY (degree_type, degree_name) REFERENCES Degree (degree_type, degree_name)
);

CREATE TABLE IF NOT EXISTS courseEnrollment (
    index SERIAL UNIQUE,
    pid varchar(30) NOT NULL,
    sid varchar(30) NOT NULL,
    unit integer DEFAULT 3,
    grade_option varchar(30) DEFAULT 'either',
    grade_earned varchar(30) DEFAULT 'IN',
    PRIMARY KEY (pid, sid),
    FOREIGN KEY (pid) REFERENCES Student (student_id),
    FOREIGN KEY (sid) REFERENCES Section (section_id)
);

CREATE TABLE IF NOT EXISTS technical_elective (
    index SERIAL UNIQUE,
    elec_dept varchar(30) NOT NULL,
    elec_number varchar(30) NOT NULL,
    PRIMARY KEY (elec_dept, elec_number),
    FOREIGN KEY (elec_dept, elec_number) REFERENCES Courses (course_dept, course_number)
);

CREATE TABLE IF NOT EXISTS Concentration (
    index SERIAL UNIQUE,
    con_dept varchar(30) NOT NULL,
    con_number varchar(30) NOT NULL,
    min_gpa numeric(3, 2) DEFAULT 2.00,
    PRIMARY KEY (con_dept, con_number),
    FOREIGN KEY (con_dept, con_number) REFERENCES Courses (course_dept, course_number)
);

CREATE TABLE IF NOT EXISTS SectionWaitlist (
    index SERIAL UNIQUE,
    section_id varchar(30) NOT NULL,
    student_id varchar(30) NOT NULL,
    position int NOT NULL,
    PRIMARY KEY (section_id, student_id),
    FOREIGN KEY (section_id) REFERENCES Section (section_id),
    FOREIGN KEY (student_id) REFERENCES Student (student_id)
);

CREATE TABLE IF NOT EXISTS SectionEnrolled (
    index SERIAL UNIQUE,
    section_id varchar(30) NOT NULL,
    student_id varchar(30) NOT NULL,
    PRIMARY KEY (section_id, student_id),
    FOREIGN KEY (section_id) REFERENCES Section (section_id),
    FOREIGN KEY (student_id) REFERENCES Student (student_id)
);

CREATE TABLE IF NOT EXISTS WeeklySchedule (
    index SERIAL UNIQUE,
    section_id varchar(30) NOT NULL,
    sched_type varchar(30) NOT NULL,
    sched_day varchar(30) NOT NULL,
    start_time time NOT NULL,
    end_time time NOT NULL,
    PRIMARY KEY (section_id, sched_type, sched_day),
    FOREIGN KEY (section_id) REFERENCES Section (section_id)
);

CREATE TABLE IF NOT EXISTS ReviewSchedule (
    index SERIAL UNIQUE,
    section_id varchar(30) NOT NULL,
    review_type varchar(30) NOT NULL,
    review_day varchar(30) NOT NULL,
    start_time time NOT NULL,
    end_time time NOT NULL,
    PRIMARY KEY (section_id, review_type, review_day),
    FOREIGN KEY (section_id) REFERENCES Section (section_id)
);

CREATE TABLE IF NOT EXISTS Probation (
    index SERIAL UNIQUE,
    pid varchar(30) NOT NULL,
    type varchar(30) NOT NULL,
    start_date date NOT NULL,
    end_date date,
    PRIMARY KEY (INDEX),
    FOREIGN KEY (pid) REFERENCES Student (student_id)
);

CREATE TABLE IF NOT EXISTS Committee (
    index SERIAL UNIQUE,
    pid varchar(30) NOT NULL,
    fid integer NOT NULL,
    PRIMARY KEY (pid, fid),
    FOREIGN KEY (pid) REFERENCES Student (student_id),
    FOREIGN KEY (fid) REFERENCES Faculty (INDEX)
);

CREATE TABLE IF NOT EXISTS GRADE_CONVERSION (
    LETTER_GRADE char(2) NOT NULL,
    NUMBER_GRADE DECIMAL(2, 1),
    PRIMARY KEY (LETTER_GRADE, NUMBER_GRADE)
);

CREATE TABLE IF NOT EXISTS courseCategory (
    course_dept varchar(30) NOT NULL,
    course_number varchar(30) NOT NULL,
    category varchar(30) NOT NULL,
    PRIMARY KEY (course_dept, course_number),
    FOREIGN KEY (course_dept, course_number) REFERENCES Courses (course_dept, course_number)
);


/*
INSERT INTO grade_conversion
 VALUES ('A+', 4.3);

INSERT INTO grade_conversion
 VALUES ('A', 4);

INSERT INTO grade_conversion
 VALUES ('A-', 3.7);

INSERT INTO grade_conversion
 VALUES ('B+', 3.4);

INSERT INTO grade_conversion
 VALUES ('B', 3.1);

INSERT INTO grade_conversion
 VALUES ('B-', 2.8);

INSERT INTO grade_conversion
 VALUES ('C+', 2.5);

INSERT INTO grade_conversion
 VALUES ('C', 2.2);

INSERT INTO grade_conversion
 VALUES ('C-', 1.9);

INSERT INTO grade_conversion
 VALUES ('D', 1.6);

CREATE TABLE IF NOT EXISTS QUARTER_ORDER (
 quarter_name varchar(15) NOT NULL,
 quarter_order integer NOT NULL,
 PRIMARY KEY (quarter_name, quarter_order)
);

INSERT INTO quarter_order
 VALUES ('sp', 3);

INSERT INTO quarter_order
 VALUES ('su', 4);

INSERT INTO quarter_order
 VALUES ('fa', 1);

INSERT INTO quarter_order
 VALUES ('wi', 2);
 */
