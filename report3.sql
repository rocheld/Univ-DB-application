SELECT completed_con.gpa
FROM
    (SELECT sum(unit * number_grade) / sum(unit) AS gpa
     FROM degree_audit d1
     INNER JOIN grade_conversion g ON g.letter_grade = d1.grade_earned
     INNER JOIN concentration_course co2 ON co2.course_dept = d1.class_dept
     AND co2.course_number = d1.class_number
     INNER JOIN concentration c3 ON co2.cname = c3.c_name) AS completed_con;

