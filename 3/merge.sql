--SELECT REGEXP_SUBSTR('Bauer, Hans',
--	'([a-Z[:space:]]+), ([a-Z[:space:]]+)') AS name
--FROM DUAL;  -- not needed

CREATE OR REPLACE PROCEDURE merge_staff IS
	staff_name VARCHAR(31);  -- name, vorname
	surname VARCHAR(31);
	forename VARCHAR(31);
	
BEGIN
	
	staff_name := 'Bauer, Hans';
	SELECT SUBSTR(staff_name, 1, Instr(staff_name, ',', -1, 1) -1),
		   SUBSTR(staff_name, Instr(staff_name, ',', -1, 1) +2)
	INTO surname, forename
	FROM DUAL;
END;
/

EXECUTE MERGE_STAFF();