/*

A91407351 
Hyunwoo Choi

 \i /Applications/apache-tomcat/webapps/cse132/report1.sql 
 
 a. Display the classes currently taken by student X:
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
    VALUES ('sp', 3);

INSERT INTO quarter_order
    VALUES ('su', 4);

INSERT INTO quarter_order
    VALUES ('fa', 1);

INSERT INTO quarter_order
    VALUES ('wi', 2);


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

SELECT
    d.*
FROM
    degree d
WHERE
    d.degree_name = 'Computer Science';

SELECT
    st.*,
    u.*
FROM
    student st
    INNER JOIN undergraduate u ON st.student_id = u.pid
WHERE
    st.student_ssn = ?;


/* degree audit */
SELECT
    d.*
FROM
    degree d
WHERE
    d.degree_name = 'Computer Science'
    AND d.degree_type = ?;

CREATE TABLE IF NOT EXISTS degree_audit AS (
    SELECT
        c.class_dept,
        c.class_number,
        en.grade_earned,
        en.unit,
        cc.category
    FROM
        courseEnrollment en
        INNER JOIN classes c ON en.class_id = c.index
        INNER JOIN courseCategory cc ON cc.course_dept = c.class_dept
            AND cc.course_number = c.class_number
    WHERE
        en.pid = '20'
);

SELECT
    sum(unit) AS total_unit
FROM
    degree_audit;

SELECT
    sum(unit) AS lower_unit
FROM
    degree_audit
WHERE
    category = 'lower';

SELECT
    sum(unit) AS upper_unit
FROM
    degree_audit
WHERE
    class_dept = 'CSE'
    AND category = 'upper'
    SELECT
        sum(unit) AS tech_unit
    FROM
        degree_audit d
        INNER JOIN technical_elective t ON t.elec_dept = d.class_dept
            AND t.elec_number = d.class_number;

SELECT
    sum(unit) AS grad_unit
FROM
    degree_audit
WHERE
    class_dept = 'CSE'
    AND category = 'grad';


/* e. ms require_ment */
/* returns completed concentration */
SELECT
    *
FROM
    concentration c
WHERE
    NOT EXISTS (
        SELECT
            *
        FROM
            concentration_course co
        WHERE
            c.c_name = co.cname
            AND NOT EXISTS (
                SELECT
                    *
                FROM
                    degree_audit d
                WHERE
                    co.course_dept = d.class_dept
                    AND co.course_number = d.class_number
                    AND d.grade_earned NOT IN ('IN', 'D', 'F', 'U')));


/* returns completed name of concentration */
SELECT
    *
FROM
    concentration c1
WHERE (
    SELECT
        c2.c_name
    FROM
        concentration c2
    WHERE
        NOT EXISTS (
            SELECT
                *
            FROM
                concentration_course co
            WHERE
                c2.c_name = co.cname
                AND NOT EXISTS (
                    SELECT
                        *
                    FROM
                        degree_audit d2
                    WHERE
                        co.course_dept = d2.class_dept
                        AND co.course_number = d2.class_number
                        AND d2.grade_earned NOT IN ('IN', 'D', 'F', 'U')))) = c1.c_name
        AND c1.min_gpa <= (
            SELECT
                completed_con.gpa
            FROM (
                SELECT
                    sum(unit * number_grade) / sum(unit) AS gpa
                FROM
                    degree_audit d1
                    INNER JOIN grade_conversion g ON g.letter_grade = d1.grade_earned
                    INNER JOIN concentration_course co2 ON co2.course_dept = d1.class_dept
                        AND co2.course_number = d1.class_number
                    INNER JOIN concentration c3 ON co2.cname = c3.c_name) AS completed_con);

