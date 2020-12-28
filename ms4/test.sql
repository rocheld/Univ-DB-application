CREATE OR REPLACE FUNCTION faculty_teaching_insert_trigger_fnc ()
    RETURNS TRIGGER
    AS $$
DECLARE
    con_sid varchar;
    con_day varchar;
    con_type varchar;
    con_time time;
    con_timestamp timestamp;
BEGIN
    CREATE TEMP TABLE teaching_section ON COMMIT DROP AS (
        SELECT
            c.sid
        FROM
            class_taught c
        WHERE
            c.fid = NEW.fid
        );
    CREATE TEMP TABLE regular_meeting ON COMMIT DROP AS (
        SELECT
            w.section_id AS sid, w.sched_day AS day, w.sched_type AS sched_type, w.start_time AS t1, w.end_time AS t2
        FROM
            weeklyschedule w
        WHERE
            w.section_id IN (
            SELECT
                *
            FROM
                teaching_section )
        );
    CREATE TEMP TABLE irregular_meeting ON COMMIT DROP AS (
        SELECT
            nw.section_id AS sid, nw.sched_type, nw.start_time AS t1, nw.end_time AS t2
        FROM
            nonweeklyschedule nw
        WHERE
            nw.section_id IN (
            SELECT
                *
            FROM
                teaching_section )
        );
    SELECT
        rs.sid,
        rs.sched_type,
        rs.day,
        rs.t1 INTO con_sid,
        con_type,
        con_day,
        con_time
    FROM
        regular_meeting rs
    WHERE
        EXISTS (
            SELECT
                *
            FROM
                weeklyschedule ws
            WHERE
                ws.section_id = NEW.sid
                AND ws.sched_day = rs.day
                AND (rs.t1,
                    rs.t2)
                overlaps(ws.start_time, ws.end_time));
    IF FOUND THEN
        RAISE EXCEPTION 'Faild to add Section #%. Regular meeting schedule conflicts with Section #%. % at % %', new.sid, con_sid, con_type, con_day, con_time;
    END IF;
    -- extra credit
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
                *
            FROM
                irregular_meeting )
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
        am.t1 INTO con_sid,
        con_type,
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
        RAISE EXCEPTION 'Faild to add Section #%. Irregular meeting schedule conflicts with Section #%. % at % ', new.sid, con_sid, con_type, con_timestamp;
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER faculty_teaching_insertion_trigger
    BEFORE INSERT ON "class_taught"
    FOR EACH ROW
    EXECUTE PROCEDURE faculty_teaching_insert_trigger_fnc ();

