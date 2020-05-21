/* Faculty */
INSERT INTO public.faculty (firstname, lastname, faculty_type)
    VALUES ('Justin', 'Bieber', 'Associate Professor');

INSERT INTO public.faculty (firstname, lastname, faculty_type)
    VALUES ('Flo', 'Rida', 'Professor');

INSERT INTO public.faculty (firstname, lastname, faculty_type)
    VALUES ('Selena', 'Gomez', 'Professor');

INSERT INTO public.faculty (firstname, lastname, faculty_type)
    VALUES ('Adele', ' ', 'Professor');

INSERT INTO public.faculty (firstname, lastname, faculty_type)
    VALUES ('Kelly', 'Clarkson', 'Professor');

INSERT INTO public.faculty (firstname, lastname, faculty_type)
    VALUES ('Adam', 'Levine', 'Professor');

INSERT INTO public.faculty (firstname, lastname, faculty_type)
    VALUES ('Bjork', ' ', 'Professor');


/* degree */
INSERT INTO public.degree (degree_name, degree_type, total_unit, lower_unit, upper_unit, tech_unit, grad_unit)
    VALUES ('Computer Science', 'B.S', 40, 10, 15, 15, 0);

INSERT INTO public.degree (degree_name, degree_type, total_unit, lower_unit, upper_unit, tech_unit, grad_unit)
    VALUES ('Philosophy', 'B.A', 35, 15, 20, 0, 0);

INSERT INTO public.degree (degree_name, degree_type, total_unit, lower_unit, upper_unit, tech_unit, grad_unit)
    VALUES ('Mechanical Engineering', 'B.S', 50, 20, 20, 10, 0);

INSERT INTO public.degree (degree_name, degree_type, total_unit, lower_unit, upper_unit, tech_unit, grad_unit)
    VALUES ('Computer Science', 'M.S', 45, 0, 0, 0, 45);


/* Undergrad student */
INSERT INTO public.student (student_id, first_name, last_name, student_ssn)
    VALUES ('1', 'Benjamin', 'B', '1');

INSERT INTO public.undergraduate (pid, major, degree_type, degree_name)
    VALUES ('1', 'Computer Science', 'B.S', 'Computer Science');

INSERT INTO public.student (student_id, first_name, last_name, student_ssn)
    VALUES ('2', 'Kristen', 'W', '2');

INSERT INTO public.undergraduate (pid, major, degree_type, degree_name)
    VALUES ('2', 'Computer Science', 'B.S', 'Computer Science');

INSERT INTO public.student (student_id, first_name, last_name, student_ssn)
    VALUES ('3', 'Daniel', 'F', '3');

INSERT INTO public.undergraduate (pid, major, degree_type, degree_name)
    VALUES ('3', 'Computer Science', 'B.S', 'Computer Science');

INSERT INTO public.student (student_id, first_name, last_name, student_ssn)
    VALUES ('4', 'Claire', 'J', '4');

INSERT INTO public.undergraduate (pid, major, degree_type, degree_name)
    VALUES ('4', 'Computer Science', 'B.S', 'Computer Science');

INSERT INTO public.student (student_id, first_name, last_name, student_ssn)
    VALUES ('5', 'Julie', 'F', '5');

INSERT INTO public.undergraduate (pid, major, degree_type, degree_name)
    VALUES ('5', 'Computer Science', 'B.S', 'Computer Science');

INSERT INTO public.student (student_id, first_name, last_name, student_ssn)
    VALUES ('6', 'Kevin', 'L', '6');

INSERT INTO public.undergraduate (pid, major, degree_type, degree_name)
    VALUES ('6', 'Mechanical Engineering', 'B.S', 'Mechanical Engineering');

INSERT INTO public.student (student_id, first_name, last_name, student_ssn)
    VALUES ('7', 'Micheal', 'J', '7');

INSERT INTO public.undergraduate (pid, major, degree_type, degree_name)
    VALUES ('7', 'Mechanical Engineering', 'B.S', 'Mechanical Engineering');

INSERT INTO public.student (student_id, first_name, last_name, student_ssn)
    VALUES ('8', 'Joseph', 'J', '8');

INSERT INTO public.undergraduate (pid, major, degree_type, degree_name)
    VALUES ('8', 'Mechanical Engineering', 'B.S', 'Mechanical Engineering');

INSERT INTO public.student (student_id, first_name, last_name, student_ssn)
    VALUES ('9', 'Devin', 'P', '9');

INSERT INTO public.undergraduate (pid, major, degree_type, degree_name)
    VALUES ('9', 'Mechanical Engineering', 'B.S', 'Mechanical Engineering');

INSERT INTO public.student (student_id, first_name, last_name, student_ssn)
    VALUES ('10', 'Logan', 'F', '10');

INSERT INTO public.undergraduate (pid, major, degree_type, degree_name)
    VALUES ('10', 'Mechanical Engineering', 'B.S', 'Mechanical Engineering');

INSERT INTO public.student (student_id, first_name, last_name, student_ssn)
    VALUES ('11', 'Vikram', 'N', '11');

INSERT INTO public.undergraduate (pid, major, degree_type, degree_name)
    VALUES ('11', 'Philosophy', 'B.A', 'Philosophy');

INSERT INTO public.student (student_id, first_name, last_name, student_ssn)
    VALUES ('12', 'Rachel', 'Z', '12');

INSERT INTO public.undergraduate (pid, major, degree_type, degree_name)
    VALUES ('12', 'Philosophy', 'B.A', 'Philosophy');

INSERT INTO public.student (student_id, first_name, last_name, student_ssn)
    VALUES ('13', 'Zach', 'M', '13');

INSERT INTO public.undergraduate (pid, major, degree_type, degree_name)
    VALUES ('13', 'Zach', 'B.A', 'Philosophy');

INSERT INTO public.student (student_id, first_name, last_name, student_ssn)
    VALUES ('14', 'Justin', 'H', '14');

INSERT INTO public.undergraduate (pid, major, degree_type, degree_name)
    VALUES ('14', 'Justin', 'B.A', 'Philosophy');

INSERT INTO public.student (student_id, first_name, last_name, student_ssn)
    VALUES ('15', 'Rahul', 'R', '15');

INSERT INTO public.undergraduate (pid, major, degree_type, degree_name)
    VALUES ('15', 'Philosophy', 'B.A', 'Philosophy');


/*
Students (MS)				
SSN	First	Last	Degree	
16	Dave	C	M.S. in Computer Science	
17	Nelson	H	M.S. in Computer Science	
18	Andrew	P	M.S. in Computer Science	
19	Nathan	S	M.S. in Computer Science	
20	John	H	M.S. in Computer Science	
21	Anwell	W	M.S. in Computer Science	
22	Tim	K	M.S. in Computer Science	
 */
/* MS student */
INSERT INTO public.student (student_id, student_ssn, first_name, last_name, student_type)
    VALUES ('16', '16', 'Dave', 'C', 'MS');

INSERT INTO public.MS (pid, dept, degree_type, degree_name)
    VALUES ('16', 'Computer Science', 'M.S', 'Computer Science');

INSERT INTO public.student (student_id, student_ssn, first_name, last_name, student_type)
    VALUES ('17', '17', 'Nelson', 'H', 'MS');

INSERT INTO public.MS (pid, dept, degree_type, degree_name)
    VALUES ('17', 'Computer Science', 'M.S', 'Computer Science');

INSERT INTO public.student (student_id, student_ssn, first_name, last_name, student_type)
    VALUES ('18', '18', 'Andrew', 'P', 'MS');

INSERT INTO public.MS (pid, dept, degree_type, degree_name)
    VALUES ('18', 'Computer Science', 'M.S', 'Computer Science');

INSERT INTO public.student (student_id, student_ssn, first_name, last_name, student_type)
    VALUES ('19', '19', 'Nathan', 'S', 'MS');

INSERT INTO public.MS (pid, dept, degree_type, degree_name)
    VALUES ('19', 'Computer Science', 'M.S', 'Computer Science');

INSERT INTO public.student (student_id, student_ssn, first_name, last_name, student_type)
    VALUES ('20', '20', 'John', 'H', 'MS');

INSERT INTO public.MS (pid, dept, degree_type, degree_name)
    VALUES ('20', 'Computer Science', 'M.S', 'Computer Science');

INSERT INTO public.student (student_id, student_ssn, first_name, last_name, student_type)
    VALUES ('21', '21', 'Anwell', 'W', 'MS');

INSERT INTO public.MS (pid, dept, degree_type, degree_name)
    VALUES ('21', 'Computer Science', 'M.S', 'Computer Science');

INSERT INTO public.student (student_id, student_ssn, first_name, last_name, student_type)
    VALUES ('22', '22', 'Tim', 'K', 'MS');

INSERT INTO public.MS (pid, dept, degree_type, degree_name)
    VALUES ('22', 'Computer Science', 'M.S', 'Computer Science');


/* course */
INSERT INTO public.courses (course_dept, course_number)
    VALUES ('CSE', '8A');

INSERT INTO public.courses (course_dept, course_number)
    VALUES ('CSE', '105');

INSERT INTO public.courses (course_dept, course_number)
    VALUES ('CSE', '123');

INSERT INTO public.courses (course_dept, course_number)
    VALUES ('CSE', '250A');

INSERT INTO public.courses (course_dept, course_number)
    VALUES ('CSE', '250B');

INSERT INTO public.courses (course_dept, course_number)
    VALUES ('CSE', '255');

INSERT INTO public.courses (course_dept, course_number)
    VALUES ('CSE', '232A');

INSERT INTO public.courses (course_dept, course_number)
    VALUES ('CSE', '221');

INSERT INTO public.courses (course_dept, course_number)
    VALUES ('MAE', '3');

INSERT INTO public.courses (course_dept, course_number)
    VALUES ('MAE', '107');

INSERT INTO public.courses (course_dept, course_number)
    VALUES ('MAE', '108');

INSERT INTO public.courses (course_dept, course_number)
    VALUES ('PHIL', '10');

INSERT INTO public.courses (course_dept, course_number)
    VALUES ('PHIL', '12');

INSERT INTO public.courses (course_dept, course_number)
    VALUES ('PHIL', '165');

INSERT INTO public.courses (course_dept, course_number)
    VALUES ('PHIL', '167');


/* classes */
INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '8A', 'Introduction to Computer Science: Java', 'wi', '2017');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '8A', 'Introduction to Computer Science: Java', 'fa', '2017');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '8A', 'Introduction to Computer Science: Java', 'wi', '2018');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '8A', 'Introduction to Computer Science: Java', 'sp', '2020');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '8A', 'Introduction to Computer Science: Java', 'sp', '2021');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '105', 'Intro to Theory', 'sp', '2017');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '105', 'Intro to Theory', 'fa', '2020');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '105', 'Intro to Theory', 'sp', '2020');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '250A', 'Probabilistic Reasoning', 'wi', '2017');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '250A', 'Probabilistic Reasoning', 'wi', '2018');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '250A', 'Probabilistic Reasoning', 'wi', '2021');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '250B', 'Machine Learning', 'sp', '2017');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '250B', 'Machine Learning', 'wi', '2021');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '255', 'Data Mining and Predictive Analytics', 'wi', '2018');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '255', 'Data Mining and Predictive Analytics', 'sp', '2020');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '255', 'Data Mining and Predictive Analytics', 'wi', '2021');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '232A', 'Databases', 'wi', '2018');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '232A', 'Databases', 'wi', '2021');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '221', 'Operating Systems', 'fa', '2017');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '221', 'Operating Systems', 'sp', '2020');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('CSE', '221', 'Operating Systems', 'fa', '2020');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('MAE', '107', 'Computational Methods', 'fa', '2017');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('MAE', '107', 'Computational Methods', 'sp', '2021');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('MAE', '108', 'Probability and Statistics', 'wi', '2017');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('MAE', '108', 'Probability and Statistics', 'sp', '2017');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('MAE', '108', 'Probability and Statistics', 'fa', '2020');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('MAE', '108', 'Probability and Statistics', 'sp', '2020');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('PHIL', '10', 'Intro to Logic', 'wi', '2018');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('PHIL', '10', 'Intro to Logic', 'wi', '2021');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('PHIL', '12', 'Scientific Reasoning', 'sp', '2021');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('PHIL', '12', 'Scientific Reasoning', 'sp', '2020');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('PHIL', '165', 'Freedom, Equality, and the Law', 'fa', '2017');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('PHIL', '165', 'Freedom, Equality, and the Law', 'wi', '2018');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('PHIL', '165', 'Freedom, Equality, and the Law', 'sp', '2020');

INSERT INTO public.classes (class_dept, class_number, class_title, class_quarter, class_year)
    VALUES ('PHIL', '165', 'Freedom, Equality, and the Law', 'sp', '2021');

INSERT INTO courseCategory
    VALUES ('CSE', '8A', 'lower');

INSERT INTO courseCategory
    VALUES ('CSE', '105', 'upper');

INSERT INTO courseCategory
    VALUES ('CSE', '123', 'upper');

INSERT INTO courseCategory
    VALUES ('CSE', '250A', 'upper');

INSERT INTO courseCategory
    VALUES ('CSE', '250B', 'upper');

INSERT INTO courseCategory
    VALUES ('CSE', '255', 'upper');

INSERT INTO courseCategory
    VALUES ('CSE', '232A', 'upper');

INSERT INTO courseCategory
    VALUES ('CSE', '221', 'upper');

INSERT INTO courseCategory
    VALUES ('MAE', '3', 'lower');

INSERT INTO courseCategory
    VALUES ('MAE', '107', 'upper');

INSERT INTO courseCategory
    VALUES ('MAE', '108', 'upper');

INSERT INTO courseCategory
    VALUES ('PHIL', '10', 'lower');

INSERT INTO courseCategory
    VALUES ('PHIL', '12', 'lower');

INSERT INTO courseCategory
    VALUES ('PHIL', '165', 'upper');

INSERT INTO courseCategory
    VALUES ('PHIL', '167', 'upper');

INSERT INTO technical_elective
    VALUES ('CSE', '250A');

INSERT INTO technical_elective
    VALUES ('CSE', '221');

INSERT INTO technical_elective
    VALUES ('CSE', '105');

INSERT INTO technical_elective
    VALUES ('MAE', '107');

INSERT INTO technical_elective
    VALUES ('MAE', '3');

