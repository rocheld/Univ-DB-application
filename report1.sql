/*
 
 \i /Applications/apache-tomcat/webapps/cse132/report1.sql 
 
 a. Display the classes currently taken by student X:
 
 1. The form is an HTML SELECT control with all students enrolled in the current quarter.   
 Display the SSN, FIRSTNAME, MIDDLENAME and LASTNAME attributes of STUDENTs given their SSN attribute.
 2. The report should display the classes taken by X in the current quarter.
 3. On the report page display all attributes of the CLASS entity and the UNITS and SECTION attributes of the relationship connecting STUDENTS with the CLASS they take.
 */
SELECT
    st.first_name,
    s.*,
    c.*,
    e.*
FROM
    courseEnrollment e
    INNER JOIN section s ON s.section_id = e.sid
    INNER JOIN classes c ON s.class_id = c.index
    INNER JOIN student st ON e.pid = st.student_id
        AND st.student_id = ?
WHERE
    class_quarter = 'sp'
    AND class_year = '2020';


/* ------------ b. class roster ------------*/
/* class selection*/
SELECT
    *
FROM
    class;


/* result set */
SELECT
    st.*,
    en.unit,
    sid,
    en.grade_option
FROM
    classes c
    INNER JOIN courseEnrollment en ON en.class_id = c.index
    INNER JOIN student st ON en.pid = st.student_id
WHERE
    c.index = ?
    /* -------------- c. Grade report ------------ */
    CREATE TABLE GRADE_CONVERSION (
        LETTER_GRADE char(2) NOT NULL,
        NUMBER_GRADE DECIMAL(2, 1)
);

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

CREATE TABLE QUARTER_ORDER (
    quarter_name varchar(15) NOT NULL,
    quarter_order integer NOT NULL
);

INSERT INTO quarter_order
    VALUES ('spring', 3);

INSERT INTO quarter_order
    VALUES ('summer', 4);

INSERT INTO quarter_order
    VALUES ('fall', 1);

INSERT INTO quarter_order
    VALUES ('winter', 2);

* /
/* All classes taken by student x */
SELECT
    en.*,
    c.*,
    g.number_grade,
    q.quarter_order
FROM
    student st
    RIGHT JOIN courseEnrollment en ON st.student_id = en.pid
    LEFT JOIN classes c ON en.class_id = c.index
    LEFT JOIN grade_conversion g ON en.grade_earned = g.letter_grade
    LEFT JOIN quarter_order q ON c.class_quarter = q.quarter_name
WHERE
    st.student_ssn = ?
ORDER BY
    c.class_year DESC,
    q.quarter_order DESC;


/* student x's GPA by quaters */
SELECT
    c.class_quarter,
    c.class_year,
    q.quarter_order
FROM
    student st
    RIGHT JOIN courseEnrollment en ON st.student_id = en.pid
    LEFT JOIN classes c ON en.class_id = c.index
    LEFT JOIN grade_conversion g ON en.grade_earned = g.letter_grade
    LEFT JOIN quarter_order q ON c.class_quarter = q.quarter_name
WHERE
    st.student_ssn = ?
GROUP BY
    c.class_quarter,
    c.class_year,
    q.quarter_order
ORDER BY
    c.class_year DESC,
    q.quarter_order DESC;


/* d undergraduate requirement */
/* Note that section number is not null for current quarter */
/* undergrad student toward B.S in Computer Science who are enrolled sp 2020 quarter */
SELECT
    st.*
FROM
    student st
    INNER JOIN undergraduate u ON u.pid = st.student_id
        AND u.degree_name = 'Computer Science'
        AND u.degree_type = 'B.S'
WHERE
    EXISTS ( SELECT DISTINCT
            en.pid
        FROM
            courseEnrollment en
        WHERE
            en.pid = st.student_id
            AND en.sid IS NOT NULL);

CREATE VIEW degree_audit AS
SELECT
    c.class_dept AS dept,
    c.class_number AS num,
    en.grade_earned AS grade,
    en.unit AS unit,
    cc.category AS category
FROM
    courseEnrollment en
    INNER JOIN classes c ON en.class_id = c.index
    INNER JOIN courseCategory cc ON cc.course_dept = c.class_dept
        AND cc.course_number = c.class_number
WHERE
    c.class_dept = 'CSE'
    AND en.pid = ?;

DROP VIEW degree_audit;

