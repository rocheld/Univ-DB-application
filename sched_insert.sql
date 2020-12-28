/*

 sp 2020  start date -    March 25 8:00 am wed
 end date -   June 5 8:00pm
 m    t       wed    thu    fri
 30   31       4/1    4/2     4/3
 */ DO $$

DECLARE
    i record;
BEGIN
    FOR i IN 0..9 LOOP

        /* monday lectures */
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('1', 'LE', '2020-03-30 10:00'::timestamp + (i * interval '7 day'), '2020-03-30 11:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('2', 'LE', '2020-03-30 10:00'::timestamp + (i * interval '7 day'), '2020-03-30 11:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('3', 'LE', '2020-03-30 12:00'::timestamp + (i * interval '7 day'), '2020-03-30 13:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('4', 'LE', '2020-03-30 12:00'::timestamp + (i * interval '7 day'), '2020-03-30 13:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('5', 'LE', '2020-03-30 12:00'::timestamp + (i * interval '7 day'), '2020-03-30 13:00'::timestamp + (i * interval '7 day'));

        /* monday di */
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('8', 'DI', '2020-03-30 15:00'::timestamp + (i * interval '7 day'), '2020-03-30 16:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('9', 'DI', '2020-03-30 09:00'::timestamp + (i * interval '7 day'), '2020-03-30 10:00'::timestamp + (i * interval '7 day'));

        /* tuesaday lectures */
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('6', 'LE', '2020-03-31 14:00'::timestamp + (i * interval '7 day'), '2020-03-31 15:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('7', 'LE', '2020-03-31 15:00'::timestamp + (i * interval '7 day'), '2020-03-31 16:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('8', 'LE', '2020-03-31 15:00'::timestamp + (i * interval '7 day'), '2020-03-31 16:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('9', 'LE', '2020-03-31 17:00'::timestamp + (i * interval '7 day'), '2020-03-31 18:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('10', 'LE', '2020-03-31 17:00'::timestamp + (i * interval '7 day'), '2020-03-31 18:00'::timestamp + (i * interval '7 day'));

        /* tuesday di  & lab */
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('1', 'DI', '2020-03-31 10:00'::timestamp + (i * interval '7 day'), '2020-03-31 11:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('2', 'DI', '2020-03-31 11:00'::timestamp + (i * interval '7 day'), '2020-03-31 12:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('5', 'DI', '2020-03-31 12:00'::timestamp + (i * interval '7 day'), '2020-03-31 13:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('10', 'LAB', '2020-03-31 15:00'::timestamp + (i * interval '7 day'), '2020-03-31 16:00'::timestamp + (i * interval '7 day'));

        /* Wed lec */
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('1', 'LE', '2020-04-01 10:00'::timestamp + (i * interval '7 day'), '2020-04-01 11:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('2', 'LE', '2020-04-01 10:00'::timestamp + (i * interval '7 day'), '2020-04-01 11:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('3', 'LE', '2020-04-01 12:00'::timestamp + (i * interval '7 day'), '2020-04-01 13:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('4', 'LE', '2020-04-01 12:00'::timestamp + (i * interval '7 day'), '2020-04-01 13:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('5', 'LE', '2020-04-01 12:00'::timestamp + (i * interval '7 day'), '2020-04-01 13:00'::timestamp + (i * interval '7 day'));

        /* wed di & lab */
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('4', 'DI', '2020-04-01 13:00'::timestamp + (i * interval '7 day'), '2020-04-01 14:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('10', 'DI', '2020-04-01 19:00'::timestamp + (i * interval '7 day'), '2020-04-01 20:00'::timestamp + (i * interval '7 day'));


        /* Thur lec */
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('6', 'LE', '2020-04-02 14:00'::timestamp + (i * interval '7 day'), '2020-04-02 15:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('7', 'LE', '2020-04-02 15:00'::timestamp + (i * interval '7 day'), '2020-04-02 16:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('8', 'LE', '2020-04-02 15:00'::timestamp + (i * interval '7 day'), '2020-04-02 16:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('9', 'LE', '2020-04-02 17:00'::timestamp + (i * interval '7 day'), '2020-04-02 18:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('10', 'LE', '2020-04-02 17:00'::timestamp + (i * interval '7 day'), '2020-04-02 18:00'::timestamp + (i * interval '7 day'));

        /* Thurs di & lab */
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('1', 'DI', '2020-04-02 10:00'::timestamp + (i * interval '7 day'), '2020-04-02 11:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('2', 'DI', '2020-04-02 11:00'::timestamp + (i * interval '7 day'), '2020-04-02 12:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('5', 'DI', '2020-04-02 12:00'::timestamp + (i * interval '7 day'), '2020-04-02 13:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('7', 'DI', '2020-04-02 13:00'::timestamp + (i * interval '7 day'), '2020-04-02 14:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('10', 'LAB', '2020-04-02 15:00'::timestamp + (i * interval '7 day'), '2020-04-02 16:00'::timestamp + (i * interval '7 day'));


        /* F lec */
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('1', 'LE', '2020-04-03 10:00'::timestamp + (i * interval '7 day'), '2020-04-03 11:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('2', 'LE', '2020-04-03 10:00'::timestamp + (i * interval '7 day'), '2020-04-03 11:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('3', 'LE', '2020-04-03 12:00'::timestamp + (i * interval '7 day'), '2020-04-03 13:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('4', 'LE', '2020-04-03 12:00'::timestamp + (i * interval '7 day'), '2020-04-03 13:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('5', 'LE', '2020-04-03 12:00'::timestamp + (i * interval '7 day'), '2020-04-03 13:00'::timestamp + (i * interval '7 day'));

        /* F di & lab */
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('1', 'LAB', '2020-04-03 18:00'::timestamp + (i * interval '7 day'), '2020-04-03 19:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('8', 'LAB', '2020-04-03 17:00'::timestamp + (i * interval '7 day'), '2020-04-03 18:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('4', 'DI', '2020-04-03 13:00'::timestamp + (i * interval '7 day'), '2020-04-03 14:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('6', 'DI', '2020-04-03 18:00'::timestamp + (i * interval '7 day'), '2020-04-03 19:00'::timestamp + (i * interval '7 day'));
        INSERT INTO public.quarter_schedule (sid, sch_type, start_time, end_time)
            VALUES ('9', 'DI', '2020-04-03 09:00'::timestamp + (i * interval '7 day'), '2020-04-03 10:00'::timestamp + (i * interval '7 day'));

END LOOP;
END$$;