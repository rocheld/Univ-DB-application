/* a */
CREATE TABLE IF NOT EXISTS sss AS
SELECT
    w.*
FROM
    weeklyschedule w
    INNER JOIN courseEnrollment e ON e.sid = w.section_id
    INNER JOIN classes c ON c.index = e.class_id
WHERE
    e.pid = ? ;


create TABLE IF NOT EXISTS tt AS (
        SELECT
            w.*,
            c.class_dept,
            c.class_number,
            c.class_title
        FROM
            weeklyschedule w
            INNER JOIN section s ON w.section_id = s.section_id
            INNER JOIN classes c ON c.index = s.class_id));

SELECT
    tt.class_dept,
    tt.class_number,
    tt.section_id,
    tt.start_time,
    tt.end_time
FROM
    tt,
    sss
WHERE
    tt.section_id != sss.section_id
    AND tt.sched_day = sss.sched_day
    AND (
        SELECT
            (tt.start_time,
                tt.end_time)
            overlaps(sss.start_time, sss.end_time))
GROUP BY
    tt.class_dept,
    tt.class_number,
    tt.section_id,
    tt.start_time,
    tt.end_time);


/* b */
SELECT DISTINCT
    qs.start_time,
    qs.end_time
FROM
    student st
    INNER JOIN courseEnrollment en ON st.student_id = en.pid
        AND en.sid IS NOT NULL
    INNER JOIN quarter_schedule qs ON qs.sid = en.sid;

CREATE TABLE IF NOT EXISTS time_list1 AS (
    SELECT
        t1,
        t1 + interval '1 hour' AS t2
    FROM
        generate_series('2020-04-02 08:00'::timestamp, '2020-05-03 16:00'::timestamp, interval '1 hour'
) AS t1
    WHERE
        t1::time >= '08:00'
        AND t1::time <= '19:00'
);


/* compare time */

select r2.t1, r2.t2 from time_list1 r2, quarter_schedule qs where exists
(r2.t1, r2.t2) overlaps (qs.start_time, qs.end_time); 


select * from quarter_schedule qs
where not exists (select * from courseEnrollment en
                  where en.sid = qs.sid and exists)



select distinct r.t1, r.t2 from time_list r
where exists ( select quarter_scehdule)