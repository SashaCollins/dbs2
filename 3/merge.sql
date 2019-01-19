--SELECT REGEXP_SUBSTR('Bauer, Hans',
--	'([a-Z[:space:]]+), ([a-Z[:space:]]+)') AS name
--FROM DUAL;	-- not needed

SET SERVEROUTPUT ON;

-- private function
CREATE OR REPLACE FUNCTION generate_id(digits IN INTEGER)
RETURN INTEGER 
IS
	new_id INTEGER;
	max_nr INTEGER := 9;
	id_str VARCHAR(10);
	cur_nr INTEGER;
	starts_with_zero BOOLEAN;
BEGIN
	FOR i in 1..digits LOOP
		cur_nr := dbms_random.value(0, max_nr);
		id_str := CONCAT(id_str, cur_nr);
	END LOOP;
	
	starts_with_zero := INSTR(id_str, '0') = 1;
	IF starts_with_zero THEN
		id_str := CONCAT(id_str, '9');
	END IF;
	
	new_id := TO_NUMBER(id_str);
	RETURN new_id;
END;
/

CREATE OR REPLACE PROCEDURE get_staffnr(identify IN VARCHAR, source IN VARCHAR, staffnr OUT INTEGER, exist OUT BOOLEAN)
IS	
	results INTEGER;
BEGIN
	SELECT COUNT(*) INTO results FROM Identifier WHERE pk = identify AND source_table = source;
	
	IF results = 0 THEN
		staffnr := -1;
	WHILE staffnr = -1 OR results != 0 LOOP
		staffnr := generate_id(6);
		SELECT COUNT(*) INTO results FROM Identifier WHERE staff_nr = staffnr;
	END LOOP;
	
		exist := FALSE;
		INSERT INTO Identifier VALUES (staffnr, source, identify);
	ELSE
		SELECT src.staff_nr INTO staffnr FROM Identifier src WHERE pk = identify;
		exist := TRUE;
	END IF;
END;
/

CREATE OR REPLACE PROCEDURE split_name(staff_name IN VARCHAR, surname IN OUT VARCHAR, forename IN OUT VARCHAR)
IS
BEGIN
	surname	:= '';
	forename := '';
	SELECT SUBSTR(staff_name, 1, INSTR(staff_name, ',', 1, 1) - 1),
			 SUBSTR(staff_name, INSTR(staff_name, ',', 1, 1) + 2)
	INTO surname, forename
	FROM DUAL;
END;
/

CREATE OR REPLACE FUNCTION concat_name(forename IN VARCHAR, surname IN VARCHAR)
RETURN VARCHAR
IS
	fullname VARCHAR(64);
BEGIN
	fullname := CONCAT(CONCAT(forename, ' '), surname);
	RETURN fullname;
END;
/

CREATE OR REPLACE PROCEDURE split_date_emp(dt IN VARCHAR, yy IN OUT INTEGER, mm IN OUT INTEGER, dd IN OUT INTEGER)
IS
BEGIN
	yy := 0;
	mm := 0;
	dd := 0;
	
	-- SUBSTR takes a String, the position of the Beginning and optional the length
	-- INSTR takes a haystack, a needed, the starting index and the occurrence
	
	-- String from position 1 (first char) going to first occurrence of '/' - 1 = year
	SELECT TO_NUMBER(SUBSTR(dt, 1, INSTR(dt, '/', 1, 1) - 1)),
		-- String from the first occurrence of '/' + 1 going for the amount of chars
		-- between the second and the first occurrence - 1 to remove the slash = month
		TO_NUMBER(SUBSTR(dt, INSTR(dt, '/', 1, 1) + 1, INSTR(dt, '/', 1, 2) - INSTR(dt, '/', 1, 1) - 1)),
		-- String from the second occurrence of '/' going to the end of the String = day
		TO_NUMBER(SUBSTR(dt, INSTR(dt, '/', 1, 2) + 1))
	INTO yy, mm, dd
	FROM DUAL;
END;
/

CREATE OR REPLACE FUNCTION dob_age_emp(date_dob IN VARCHAR)
RETURN INTEGER 
IS
	age INTEGER;
	
	year_dob INTEGER;
	month_dob INTEGER;
	day_dob INTEGER;
	
	year_cur INTEGER;
	month_cur INTEGER;
	day_cur INTEGER;
	
	date_cur VARCHAR(8);
	
	year_diff INTEGER;
	month_diff INTEGER;
	day_diff INTEGER;	
BEGIN
	-- Get Current Time
	SELECT to_char(sysdate, 'yy/mm/dd') INTO date_cur FROM DUAL;
	
	--	Split Date into day, month and year
	split_date_emp(date_dob, year_dob, month_dob, day_dob);
	split_date_emp(date_cur, year_cur, month_cur, day_cur);
	
	age := 0;
	
	-- diff not positive? Add 100, else it's the difference.
	year_diff := year_cur - year_dob;
	IF (year_diff <= 0) THEN
		age := year_diff + 100;
	ELSE
		age := year_diff;
	END IF;
		 
	-- diff negative? Didn't have his birthday this year so remove it.
	month_diff := month_cur - month_dob;
	IF (month_diff < 0) THEN
		age := age - 1;
	ELSE
		-- same month? We need to check the day then.
		IF (month_diff = 0) THEN
			day_diff := day_cur - day_dob;
			-- diff negative? Didn't have his birthday this year so remove it.
			IF (day_diff < 0) THEN
				age := age - 1;
			END IF;
		END IF;
	END IF;
	RETURN age;
END;
/

CREATE OR REPLACE PROCEDURE split_date_wor(dt IN VARCHAR, yy IN OUT INTEGER, mm IN OUT INTEGER)
IS
BEGIN
	mm := 0;
	yy := 0;
	
	-- SUBSTR takes a String, the position of the Beginning and optional the length
	-- INSTR takes a haystack, a needed, the starting index and the occurrence
	
	-- String from position 1 (first char) going to first occurrence of '.' - 1 = month
	SELECT TO_NUMBER(SUBSTR(dt, 1, INSTR(dt, '.', 1, 1) - 1)),
		-- String from the first occurrence of '.' + 1 going until the end = year
		TO_NUMBER(SUBSTR(dt, INSTR(dt, '.', 1, 1) + 1))
	INTO mm, yy
	FROM DUAL;
END;
/

CREATE OR REPLACE FUNCTION dob_age_wor(date_dob IN VARCHAR)
RETURN INTEGER
IS	
	year_dob INTEGER;
	month_dob INTEGER;
	year_cur INTEGER;
	month_cur INTEGER;
	date_cur VARCHAR(8);
	year_diff INTEGER;
	month_diff INTEGER;
	age INTEGER;
BEGIN
	-- Get Current Time
	SELECT to_char(sysdate, 'mm.yy') INTO date_cur FROM DUAL;
	
	--	Split Date into day, month and year
	split_date_wor(date_dob, year_dob, month_dob);
	split_date_wor(date_cur, year_cur, month_cur);
	
	age := 0;
	
	-- diff not positive? Add 100, else it's correct already.
	year_diff := year_cur - year_dob;
	IF (year_diff <= 0) THEN
		age := year_diff + 100;
	END IF;
	
	-- diff negative? Didn't have his birthday yet so remove it.
	month_diff := month_cur - month_dob;
	IF (month_diff < 0) THEN
		age := age - 1;
	END IF;
	RETURN age;
END;
/

-- this is only for worker
CREATE OR REPLACE FUNCTION gender_mapping(fname IN VARCHAR)
RETURN VARCHAR
IS	
	answer INTEGER;
	gen VARCHAR(1);
BEGIN	
	-- if name only once in TABLE Gender then use this gender -> 1, 2
	-- else gender is unknown -> 0
	
	SELECT COUNT(*)
	INTO answer
	FROM Gender g 
	WHERE g.forename = fname;
	 
	IF answer = 1 THEN
		SELECT g.gender INTO gen
		FROM Gender g
		WHERE g.forename = fname;
	ELSE
		gen := '0';
	END IF;
	RETURN gen;
END;
/

-- this is only for employees
CREATE OR REPLACE FUNCTION gender_evaluation(fname IN VARCHAR, gen IN VARCHAR)
RETURN VARCHAR 
IS
	gen_nr VARCHAR(1);
	answer INTEGER;
BEGIN
	-- if e then map m, w to 2, 1
	-- check if already in gender table
	-- if false then insert into TABLE Gender
	-- return 2 or 1
	
	IF gen = 'weiblich' THEN
		gen_nr := '1';
	ELSE	
		IF gen = 'männlich' THEN
			gen_nr := '2';
		END IF;
	END IF;
	
	SELECT COUNT(*)
	INTO answer
	FROM Gender g 
	WHERE g.forename = fname AND g.gender = gen_nr;
	
	IF answer = 0 THEN
		INSERT INTO Gender VALUES (fname, gen_nr);
		COMMIT;
	END IF;
	
	RETURN gen_nr;
END;
/

CREATE OR REPLACE FUNCTION get_jobcode(job_title IN VARCHAR)
RETURN INTEGER 
IS
	job_code INTEGER;
	results INTEGER;
BEGIN
	SELECT COUNT(*) INTO results FROM Jobcode WHERE description = job_title;
	
	IF results = 0 THEN
		job_code := -1;
	WHILE job_code = -1 OR results != 0 LOOP
		job_code := generate_id(5);
		SELECT COUNT(*) INTO results FROM Jobcode WHERE code = job_code;
	END LOOP;
	INSERT INTO Jobcode VALUES (job_code, job_title);
	ELSE
	SELECT code INTO job_code FROM Jobcode WHERE description = job_title;
	END IF;
	RETURN job_code; 
END;
/

CREATE OR REPLACE FUNCTION annual_income(income IN DOUBLE PRECISION, source IN VARCHAR)
RETURN DOUBLE PRECISION
IS 
	year_income DOUBLE PRECISION;
BEGIN
	IF (source = 'e') THEN
		year_income := income * 12;
	ELSE 
		IF (source = 'w')	THEN
			year_income := income * 12 * (8 * 5 * 4.3);
		END IF;
	END IF;
	RETURN year_income;
END;
/

CREATE OR REPLACE PROCEDURE merge_employees
IS
	-- var
	entry_exist BOOLEAN;

	-- to save
	staffnr INTEGER;
	sname	VARCHAR(31);
	fname VARCHAR(31);
	a INTEGER;
	jobcode INTEGER;
	income INTEGER;
	gen VARCHAR(1);
BEGIN
	FOR employee IN (SELECT * FROM Employee) LOOP
		-- procedures (multiple output values)
		get_staffnr(employee.emp_nr, 'e', staffnr, entry_exist);	-- get or gen staff nr
		split_name(employee.name, sname, fname);	-- split name
		
		-- functions
		a := dob_age_emp(employee.dob);	-- calc age
		gen := gender_evaluation(fname, employee.gender);	-- get 1/2 and update Gender Tbl 
		jobcode := get_jobcode(employee.job_title);	-- get or gen job code
		income := annual_income(employee.salary_month, 'e');	-- calc income	 
		
		IF entry_exist THEN
			UPDATE Staff s
			SET s.surname = sname, s.forename = fname, s.age = a, s.gender = gen, s.job_code = jobcode, s.income_year = income
			WHERE s.staff_nr = staffnr;
		ELSE
			INSERT INTO Staff
			VALUES(staffnr, sname, fname, a, gen, jobcode, income);
		END IF;
	END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE merge_worker 
IS
	identify VARCHAR(64);
	exist BOOLEAN;
	
	staffnr INTEGER;
	a INTEGER;
	gen VARCHAR(1);
	jobcode INTEGER;
	income DOUBLE PRECISION;
BEGIN
	FOR worker IN (SELECT * FROM Worker) LOOP
		identify := concat_name(worker.forename, worker.surname);
		get_staffnr(identify, 'w', staffnr, exist);
		a := dob_age_wor(worker.birth_month);
		gen := gender_mapping(worker.forename);
		jobcode := get_jobcode('worker');
		income := annual_income(worker.salary_hour, 'w');
		
		IF exist THEN
			UPDATE Staff s
			SET s.age = a, s.gender = gen, s.job_code = jobcode, s.income_year = income
			WHERE s.staff_nr = staffnr;
		ELSE	
			INSERT INTO Staff
			VALUES (staffnr, worker.surname, worker.forename, a, gen, jobcode, income);
		END IF;
	END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE merge_staff
IS	
BEGIN
	merge_employees();
	merge_worker();
END;
/

--EXECUTE merge_staff;