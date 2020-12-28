CREATE OR REPLACE FUNCTION cpg_insert_trigger_fnc () RETURNS TRIGGER AS $$
DECLARE
    dept VARCHAR;
    num varchar;
BEGIN
        select c.class_dept, c.class_number into dept,num from classes c
        where new.class_id = c.index;

        if TG_OP = 'UPDATE' THEN
            CASE
            when old.grade_earned = 'D' THEN
                update cpg set "D" = (select "D" from cpg where class_dept = dept and class_number = num)::bigint - 1 where class_dept = dept and class_number = num; ELSE END CASE;

        CASE
        when new.grade_earned = 'D' THEN
            update cpg set "D" = (select "D" from cpg where class_dept = dept and class_number = num)::bigint + 1 where class_dept = dept and class_number = num; ELSE END CASE;

        END IF;

    RETURN NEW;
END
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER cpg_insertion_trigger
BEFORE
INSERT
OR
UPDATE ON "courseenrollment"
FOR EACH ROW EXECUTE PROCEDURE cpg_insert_trigger_fnc ();

