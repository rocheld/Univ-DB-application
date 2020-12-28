--PART 4
 --- 1. The lectures ('LE'), discussions('DI') and lab('LAB') meetings of a section should not happen at the same time.

CREATE OR REPLACE FUNCTION weekly_insert_trigger_fnc () RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT
            *
        FROM
            weeklyschedule w
        WHERE
            w.section_id = NEW.section_id
            AND w.index <> NEW.index
            AND w.sched_day = NEW.sched_day
            AND (w.start_time,
                w.end_time)
            OVERLAPS(NEW.start_time, NEW.end_time)) THEN
    RAISE exception 'This Section(%) has a meeting at % %.', NEW.section_id, NEW.sched_day, NEW.start_time;
END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER weeky_insert_trigger
BEFORE
INSERT
OR
UPDATE ON "weeklyschedule"
FOR EACH ROW EXECUTE PROCEDURE weekly_insert_trigger_fnc ();

/* automatically add all timestamp on the quarter */
CREATE OR REPLACE FUNCTION weekly_after_insert_trigger_fnc () RETURNS TRIGGER AS $$
DECLARE
    _ts timestamp;
    _ts2 timestamp;
    i record;
BEGIN
    _ts := '2020-03-30 00:00:00';
    _ts := _ts + new.start_time::time;
    CASE new.sched_day
    WHEN 'M' THEN
        _ts := _ts + '0 day';
    WHEN 'Tue' THEN
        _ts := _ts + '1 day';
    WHEN 'W' THEN
        _ts := _ts + '2 day';
    WHEN 'Thu' THEN
        _ts := _ts + '3 day';
    WHEN 'F' THEN
        _ts := _ts + '4 day';
    ELSE
        _ts := _ts;
    END CASE;
    _ts2 := _ts + '1 hour';
    FOR i IN 0..9 LOOP
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time, id)
            VALUES (new.section_id, new.sched_type, _ts + (i * interval '7 day'), _ts2 + (i * interval '7 day'), new.index);
    END LOOP;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER weekly_after_insert_trigger AFTER
INSERT ON "weeklyschedule"
FOR EACH ROW EXECUTE PROCEDURE weekly_after_insert_trigger_fnc ();


CREATE OR REPLACE FUNCTION weekly_before_delete_trigger_fnc () RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM public.quarter_schedule
    WHERE id = OLD.index;
    RETURN OLD;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER weekly_before_delete_trigger
BEFORE
DELETE ON "weeklyschedule"
FOR EACH ROW EXECUTE PROCEDURE weekly_before_delete_trigger_fnc ();


CREATE OR REPLACE FUNCTION weekly_before_update_trigger_fnc () RETURNS TRIGGER AS $$
DECLARE
    _ts timestamp;
    _ts2 timestamp;
    i record;
BEGIN
    DELETE FROM public.quarter_schedule
    WHERE id = old.index;
    _ts := '2020-03-30 00:00:00';
    _ts := _ts + new.start_time::time;
    CASE new.sched_day
    WHEN 'M' THEN
        _ts := _ts + '0 day';
    WHEN 'Tue' THEN
        _ts := _ts + '1 day';
    WHEN 'W' THEN
        _ts := _ts + '2 day';
    WHEN 'Thu' THEN
        _ts := _ts + '3 day';
    WHEN 'F' THEN
        _ts := _ts + '4 day';
    ELSE
        _ts := _ts;
    END CASE;
    _ts2 := _ts + '1 hour';
    FOR i IN 0..9 LOOP
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time, id)
            VALUES (new.section_id, new.sched_type, _ts + (i * interval '7 day'), _ts2 + (i * interval '7 day'), new.index);
    END LOOP;
    RETURN new;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER weekly_before_update_trigger
BEFORE
UPDATE ON "weeklyschedule"
FOR EACH ROW EXECUTE PROCEDURE weekly_before_update_trigger_fnc ();

/*
 test insertion
INSERT INTO public.weeklyschedule (section_id, sched_type, sched_day, start_time, end_time)
VALUES (1,
 'LAB',
 'M',
 '10:00',
 '11:00');
 */ -- 2. If the enrollment limit of a section has been reached then additional enrollments should be rejected.

CREATE OR REPLACE FUNCTION section_enrollment_trigger_fnc () RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.sid IS NOT NULL AND ((
        SELECT
            s.seats
        FROM
            section s
        WHERE
            s.section_id = NEW.sid) = (
        SELECT
            COUNT(*)
        FROM
            courseEnrollment e
        WHERE
            e.sid = NEW.sid))) THEN
        RAISE exception 'Failed to enroll. This Section(%) is FULL. ', NEW.sid;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER section_enrollment_trigger
BEFORE
INSERT
OR
UPDATE ON "courseenrollment"
FOR EACH ROW EXECUTE PROCEDURE section_enrollment_trigger_fnc ();

-- 3. Faculty cannot teach section, if the section schedule conflicts with his/her other teaching section.

CREATE OR REPLACE FUNCTION faculty_teaching_insert_trigger_fnc () RETURNS TRIGGER AS $$
DECLARE
    con_sid varchar;
    con_day text;
    con_type varchar;
    con_time time;
    con_timestamp timestamp;
BEGIN
    if TG_OP = 'INSERT' then
        CREATE TEMP TABLE teaching_section ON COMMIT DROP AS (
            SELECT
                c.sid
            FROM
                class_taught c
            WHERE
                c.fid = NEW.fid
                AND c.sid IS NOT NULL
            );
    ELSE
        CREATE TEMP TABLE teaching_section ON COMMIT DROP AS (
        SELECT
            c.sid
        FROM
            class_taught c
        WHERE
            c.fid = NEW.fid
            AND c.sid <> OLD.sid
            AND c.sid IS NOT NULL
        );
    END IF;
    -- did extra credit
    CREATE TEMP TABLE all_meeting ON COMMIT DROP AS (
        SELECT
            qs.sid, qs.sch_type AS sched_type, qs.start_time AS t1, qs.end_time AS t2
        FROM
            quarter_schedule qs
        WHERE
            qs.sid IN (
            SELECT
                *
            FROM
                teaching_section )
            UNION (
            SELECT
                nw.section_id AS sid, nw.sched_type, nw.start_time AS t1, nw.end_time AS t2
            FROM
                nonweeklyschedule nw
            WHERE
                nw.section_id IN (
                SELECT
                    *
                FROM
                    teaching_section ) )
            );
    CREATE TEMP TABLE new_section_sched ON COMMIT DROP AS (
        SELECT
            qs.sid, qs.sch_type AS sched_type, qs.start_time AS t1, qs.end_time AS t2
        FROM
            quarter_schedule qs
        WHERE
            qs.sid = new.Sid
        UNION
        SELECT
            nw.section_id AS sid, nw.sched_type, nw.start_time AS t1, nw.end_time AS t2
        FROM
            nonweeklyschedule nw
        WHERE
            nw.section_id = new.sid
        );
    SELECT
        am.sid,
        am.sched_type,
        to_char(am.t1, 'Day'),
        am.t1::time,
        am.t1 INTO con_sid,
        con_type,
        con_day,
        con_time,
        con_timestamp
    FROM
        all_meeting am
    WHERE
        EXISTS (
            SELECT
                *
            FROM
                new_section_sched ns
            WHERE (am.t1, am.t2)
            overlaps(ns.t1, ns.t2));
    IF FOUND THEN
        IF con_type IN ('LE', 'LAB', 'DI') THEN
            RAISE EXCEPTION 'Faild to add Section #%. Schedule conflicts. Section #% has % at % %', new.sid, con_sid, con_type, con_day, con_time;
        ELSE
            RAISE EXCEPTION 'Faild to add Section #%. Schedule conflicts. Section #% has % at % ', new.sid, con_sid, con_type, con_timestamp;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER faculty_teaching_insertion_trigger
BEFORE
INSERT
OR
UPDATE ON "class_taught"
FOR EACH ROW EXECUTE PROCEDURE faculty_teaching_insert_trigger_fnc ();

/*
part 5
*/ -- 1. CPQG

CREATE TABLE CPQG AS
    (SELECT co.index AS cid,
            f.firstname,
            f.lastname,
            c.class_dept,
            c.class_number,
            c.class_quarter,
            c.class_year,
            c.index,
            SUM(CASE
                    WHEN en.grade_earned IN ('A+', 'A-', 'A') THEN 1
                    ELSE 0
                END) AS "A",
            SUM(CASE
                    WHEN en.grade_earned IN ('B+', 'B-', 'B') THEN 1
                    ELSE 0
                END) AS "B",
            SUM(CASE
                    WHEN en.grade_earned IN ('C+', 'C-', 'C') THEN 1
                    ELSE 0
                END) AS "C",
            SUM(CASE
                    WHEN en.grade_earned = 'D' THEN 1
                    ELSE 0
                END) AS "D",
            SUM(CASE
                    WHEN en.grade_earned IN ('F','S','U') THEN 1
                    ELSE 0
                END) AS "Other"
     FROM courseEnrollment en
     INNER JOIN classes c ON c.index = en.class_id
     INNER JOIN class_taught ct ON c.class_dept = ct.course_dept
     AND c.class_number = ct.course_number
     AND c.class_quarter = ct.class_quarter
     AND c.class_year = ct.class_year
     INNER JOIN courses co on c.class_dept = co.course_dept
     AND c.class_number = co.course_number
     INNER JOIN faculty f ON ct.fid = f.index
     GROUP BY co.index,
              f.firstname,
              f.lastname,
              c.class_dept,
              c.class_number,
              c.class_quarter,
              c.class_year);

--CREATE TABLE IF NOT EXISTS CPQG AS ()
 --2. CPG

CREATE TABLE CPG AS
    (SELECT co.index as cid,
            f.firstname,
            f.lastname,
            c.class_dept,
            c.class_number,
            SUM(CASE
                    WHEN en.grade_earned IN ('A+', 'A-', 'A') THEN 1
                    ELSE 0
                END) AS "A",
            SUM(CASE
                    WHEN en.grade_earned IN ('B+', 'B-', 'B') THEN 1
                    ELSE 0
                END) AS "B",
            SUM(CASE
                    WHEN en.grade_earned IN ('C+', 'C-', 'C') THEN 1
                    ELSE 0
                END) AS "C",
            SUM(CASE
                    WHEN en.grade_earned = 'D' THEN 1
                    ELSE 0
                END) AS "D",
            SUM(CASE
                    WHEN en.grade_earned IN ('F','S','U') THEN 1
                    ELSE 0
                END) AS "Other"
     FROM courseEnrollment en
     INNER JOIN classes c ON en.class_id = c.index
     INNER JOIN class_taught ct ON c.class_dept = ct.course_dept
     AND c.class_number = ct.course_number
     AND c.class_quarter = ct.class_quarter
     AND c.class_year = ct.class_year
     INNER JOIN courses co on c.class_dept = co.course_dept
     AND c.class_number = co.course_number
     INNER JOIN faculty f on f.index = ct.fid
     GROUP BY co.index,
              f.firstname,
              f.lastname,
              c.class_dept,
              c.class_number);

-- trigger for cpg and cpqg

CREATE OR REPLACE FUNCTION grade_insert_trigger_fnc () RETURNS TRIGGER AS $$
DECLARE
    dept VARCHAR;
    num VARCHAR;
BEGIN


        if TG_OP = 'UPDATE' THEN
            select distinct c.class_dept, c.class_number into dept,num from classes c
            where OLD.class_id = c.index;
            CASE
            when old.grade_earned in ('A+', 'A-', 'A') THEN
                update cpqg set "A" = (select "A" from cpqg where index = old.class_id)::bigint - 1 where index = old.class_id;
                update cpg set "A" = (select "A" from cpg where class_dept = dept and class_number = num)::bigint - 1 where class_dept = dept and class_number = num;
            when old.grade_earned in ('B+', 'B-', 'B') THEN
                update cpqg set "B" = (select "B" from cpqg where index = old.class_id)::bigint - 1 where index = old.class_id;
                update cpg set "B" = (select "B" from cpg where class_dept = dept and class_number = num)::bigint - 1 where class_dept = dept and class_number = num;
            when old.grade_earned in ('C+', 'C-', 'C') THEN
                update cpqg set "C" = (select "C" from cpqg where index = old.class_id)::bigint - 1 where index = old.class_id;
                update cpg set "C" = (select "C" from cpg where class_dept = dept and class_number = num)::bigint - 1 where class_dept = dept and class_number = num;
            when old.grade_earned in ('S','U') THEN
                update cpqg set "Other" = (select "Other" from cpqg where index = old.class_id)::bigint - 1 where index = old.class_id;
                update cpg set "Other" = (select "Other" from cpg where class_dept = dept and class_number = num)::bigint - 1 where class_dept = dept and class_number = num;
            when old.grade_earned = 'D' THEN
                update cpqg set "D" = (select "D" from cpqg where index = old.class_id)::bigint - 1 where index = old.class_id;
                update cpg set "D" = (select "D" from cpg where class_dept = dept and class_number = num)::bigint - 1 where class_dept = dept and class_number = num;ELSE END CASE;
        END IF;

        select distinct c.class_dept, c.class_number into dept,num from classes c
        where NEW.class_id = c.index;
        CASE
        when new.grade_earned in ('A+', 'A-', 'A') THEN
            update cpqg set "A" = (select "A" from cpqg where index = new.class_id)::bigint + 1 where index = new.class_id;
            update cpg set "A" = (select "A" from cpg where class_dept = dept and class_number = num)::bigint + 1 where class_dept = dept and class_number = num;
        when new.grade_earned in ('B+', 'B-', 'B') THEN
            update cpqg set "B" = (select "B" from cpqg where index = new.class_id)::bigint + 1 where index = new.class_id;
            update cpg set "B" = (select "B" from cpg where class_dept = dept and class_number = num)::bigint + 1 where class_dept = dept and class_number = num;
        when new.grade_earned in ('C+', 'C-', 'C') THEN
            update cpqg set "C" = (select "C" from cpqg where index = new.class_id)::bigint + 1 where index = new.class_id;
            update cpg set "C" = (select "C" from cpg where class_dept = dept and class_number = num)::bigint + 1 where class_dept = dept and class_number = num;
        when new.grade_earned in ('S','U') THEN
            update cpqg set "Other" = (select "Other" from cpqg where index = new.class_id)::bigint + 1 where index = new.class_id;
            update cpg set "Other" = (select "Other" from cpg where class_dept = dept and class_number = num)::bigint + 1 where class_dept = dept and class_number = num;
        when new.grade_earned = 'D' THEN
            update cpqg set "D" = (select "D" from cpqg where index = new.class_id)::bigint + 1 where index = new.class_id;
            update cpg set "D" = (select "D" from cpg where class_dept = dept and class_number = num)::bigint + 1 where class_dept = dept and class_number = num;ELSE END CASE;

    RETURN NEW;
END
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER grade_insertion_trigger
BEFORE
INSERT
OR
UPDATE ON "courseenrollment"
FOR EACH ROW EXECUTE PROCEDURE grade_insert_trigger_fnc ();


CREATE OR REPLACE FUNCTION grade_delete_trigger_fnc () RETURNS TRIGGER AS $$
DECLARE
    dept VARCHAR;
    num VARCHAR;
BEGIN
        select c.class_dept, c.class_number into dept,num from classes c
        where old.class_id = c.index;

        CASE
        when old.grade_earned in ('A+', 'A-', 'A') THEN
            update cpqg set "A" = (select "A" from cpqg where index = old.class_id)::bigint - 1 where index = old.class_id;
        when old.grade_earned in ('B+', 'B-', 'B') THEN
            update cpqg set "B" = (select "B" from cpqg where index = old.class_id)::bigint - 1 where index = old.class_id;
        when old.grade_earned in ('C+', 'C-', 'C') THEN
            update cpqg set "C" = (select "C" from cpqg where index = old.class_id)::bigint - 1 where index = old.class_id;
        when old.grade_earned in ('S','U') THEN
            update cpqg set "Other" = (select "Other" from cpqg where index = old.class_id)::bigint - 1 where index = old.class_id;
        when old.grade_earned = 'D' THEN
            update cpqg set "D" = (select "D" from cpqg where index = old.class_id)::bigint - 1 where index = old.class_id; ELSE END CASE;

    RETURN OLD;
END
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER grade_delete_trigger AFTER
DELETE ON "courseenrollment"
FOR EACH ROW EXECUTE PROCEDURE grade_delete_trigger_fnc ();

