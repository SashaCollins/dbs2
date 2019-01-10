--SELECT REGEXP_SUBSTR('Bauer, Hans',
--	'([a-Z[:space:]]+), ([a-Z[:space:]]+)') AS name
--FROM DUAL;  -- not needed

CREATE OR REPLACE PROCEDURE split_name(staff_name IN VARCHAR, surname IN OUT VARCHAR, forename IN OUT VARCHAR)
IS
BEGIN
  surname  := '';
  forename := '';
	SELECT SUBSTR(staff_name, 1, Instr(staff_name, ',', -1, 1) -1),
		   SUBSTR(staff_name, Instr(staff_name, ',', -1, 1) +2)
	INTO surname, forename
	FROM DUAL;
END;
/

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE dob_age_e(dob IN VARCHAR, age IN OUT INTEGER)
IS yy VARCHAR(2) := '';
    mm VARCHAR(2) := '';
    dd VARCHAR(2) := '';
BEGIN
    age := 0;
    SELECT SUBSTR(dob, 1, Instr(dob, '/', 0, 1) +2),
          SUBSTR(dob, 4, Instr(dob, '/', 0, 1) +2),
          SUBSTR(dob, 7, Instr(dob, '/', 0, 1) +2)
    INTO yy, mm, dd
    FROM DUAL;
    
    dbms_output.put_line(yy || ' ' || mm || ' ' || dd);
END;
/

DECLARE
  surname VARCHAR(31) := '';
  forname VARCHAR(31) := '';
  age INTEGER := 0;
BEGIN
  /* split_name('Bauer, Hans', surname, forname);
  dbms_output.put_line(surname || ' ' || forname); */
  dob_age_e('96/04/05', age);
END;


/*
96/4/05
19/1/10

(19-96) = -77 <= 0 // -> 100+(-77)
(19-18) = 1 > 0 // -> 1
(1-4) < 0 // noch nicht geb -> 23 - 1 -> tag egal
(10-4) > 0 //hatte schon geb -> 23 - 0 -> tag egal
(4-4) == 0 //tag berechnen
(10-5) >= 0 // hatte schon geb -> 23 - 0
(3-5) < 0 // noch nicht geb -> 23 - 1 
*/