CREATE TABLE IF NOT EXISTS time_list1 AS
    (SELECT t1,
            t1 + interval '1 hour' AS t2
     FROM generate_series('2020-03-25 08:00:00'::timestamp, '2020-04-01 08:00:00'::timestamp, interval '1 hour') AS t1
     WHERE t1::time >= '08:00:00'
         AND t1::time <= '19:00:00' );


CREATE TABLE IF NOT EXISTS temp AS
    (SELECT e.pid
     FROM courseEnrollment e
     INNER JOIN section s ON s.section_id = e.sid
     AND s.section_id = '1'
     INNER JOIN classes c ON s.class_id = c.index
     WHERE class_quarter = 'sp'
         AND class_year = '2020' );

/*
select * from quarter_schedule qs
where exists ( select * from courseEnrollment ce where qs.sid = cs)*/ /*
SELECT
 e.pid,
 e.sid,
 qs.sid,
 qs.start_time,
 qs.end_time
FROM
 courseEnrollment e
 INNER JOIN quarter_schedule qs ON e.sid = qs.sid
WHERE
 EXISTS (
 SELECT
 *
 FROM
 temp t
 WHERE
 e.pid = t.pid);
 */ /*
select r2.t1, r2.t2 from time_list1 r2, quarter_schedule qs where exists
(r2.t1, r2.t2) overlaps (qs.start_time, qs.end_time);
 */
CREATE TABLE IF NOT EXISTS rs AS
    (SELECT *
     FROM time_list1 t
     EXCEPT SELECT tt.t1,
                   tt.t2
     FROM time_list1 tt,

         (SELECT qs.start_time,
                 qs.end_time
          FROM courseEnrollment e
          INNER JOIN quarter_schedule qs ON e.sid = qs.sid
          WHERE EXISTS
                  (SELECT *
                   FROM temp t
                   WHERE e.pid = t.pid) ) AS qs2
     WHERE (tt.t1,
            tt.t2) overlaps(qs2.start_time, qs2.end_time) );


DROP TABLE time_list1;


DROP TABLE temp;


DROP TABLE result;

