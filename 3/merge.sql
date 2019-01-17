--SELECT REGEXP_SUBSTR('Bauer, Hans',
--    '([a-Z[:space:]]+), ([a-Z[:space:]]+)') AS name
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

CREATE OR REPLACE PROCEDURE dob_age_emp(date_dob IN VARCHAR, age IN OUT INTEGER)
IS  year_dob INTEGER;
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
    
    --  Split Date into day, month and year
    split_date_emp(date_dob, year_dob, month_dob, day_dob);
    split_date_emp(date_cur, year_cur, month_cur, day_cur);
    
    age := 0;
    
    -- diff not positive? Add 100, else it's correct already.
    year_diff := year_cur - year_dob;
    IF (year_diff <= 0) THEN
      age := year_diff + 100;
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
    
    --dbms_output.put_line(date_dob || ' ' || year_dob || ' ' || month_dob || ' ' || day_dob);
    --dbms_output.put_line(date_cur || ' ' || year_cur || ' ' || month_cur || ' ' || day_cur);
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

CREATE OR REPLACE PROCEDURE dob_age_wor(date_dob IN VARCHAR, age IN OUT INTEGER)
IS  year_dob INTEGER;
    month_dob INTEGER;
    
    year_cur INTEGER;
    month_cur INTEGER;
    
    date_cur VARCHAR(8);
    
    year_diff INTEGER;
    month_diff INTEGER;
    
BEGIN
	-- Get Current Time
    SELECT to_char(sysdate, 'mm.yy') INTO date_cur FROM DUAL;
    
    --  Split Date into day, month and year
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
END;
/

CREATE OR REPLACE PROCEDURE gender_mapping(fname IN VARCHAR, gen OUT VARCHAR)
IS	answer INTEGER;
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
		gen := 0;
	END IF;
END;
/
-- this is only for employees
CREATE OR REPLACE PROCEDURE gender_evaluation(fname IN VARCHAR, gen IN OUT VARCHAR)
IS answer INTEGER;
BEGIN
	-- if e then map m, w to 2, 1
	-- check if already in gender table
	-- if false then insert into TABLE Gender
	-- return 2 or 1
	
	IF gen = 'weiblich' THEN
		gen := '1';
	ELSE	
		IF gen = 'männlich' THEN
			gen := '2';
		END IF;
	END IF;
	
	SELECT COUNT(*)
	INTO answer
	FROM Gender g 
	WHERE g.forename = fname AND g.gender = gen;
  
	IF answer = 0 THEN
		INSERT INTO Gender VALUES (fname, gen);
    COMMIT;
	END IF;
END;
/

CREATE OR REPLACE PROCEDURE annual_income(income IN OUT INTEGER, source IN VARCHAR)
IS 
BEGIN
	IF (source = 'e') THEN
		income := income * 12;
	ELSE 
		IF (source = 'w')	THEN
			income := income * 12 * (8 * 5 * 4.3);
		END IF;
	END IF;
END;
/

CREATE OR REPLACE PROCEDURE generate_id(digits IN INTEGER, new_id IN OUT INTEGER)
IS
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
 
END;
/

CREATE OR REPLACE PROCEDURE get_jobcode(job_title IN VARCHAR, job_code IN OUT INTEGER)
IS  results INTEGER;
BEGIN
  SELECT COUNT(*) INTO results FROM Jobcode WHERE description = job_title;
  
  IF results = 0 THEN
    generate_id(5, job_code);
  ELSE
    SELECT code INTO job_code FROM Jobcode WHERE description = job_title;
  END IF;
  
END;
/

CREATE OR REPLACE PROCEDURE get_staffnr(identify IN VARCHAR, staff_nr IN OUT INTEGER)
IS  results INTEGER;
BEGIN
  SELECT COUNT(*) INTO results FROM Identifier WHERE pk = identify;
  
  IF results = 0 THEN
    generate_id(9, staff_nr);
  ELSE
    SELECT src.staff_nr INTO staff_nr FROM Identifier src WHERE pk = identify;
  END IF;
END;
/

CREATE OR REPLACE PROCEDURE concat_name(forename IN VARCHAR, surname IN VARCHAR, fullname IN OUT VARCHAR)
IS
BEGIN
  fullname := CONCAT(CONCAT(forename, ' '), surname);
END;
/

CREATE OR REPLACE PROCEDURE merge_employees IS 
	old_min INT;
	old_max INT;
	new_age INT;
	
BEGIN
	FOR employee IN (SELECT * FROM Employee) LOOP
		dbms_output.put_line(employee.emp_nr || ' ' || employee.name);
	END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE merge_staff
IS  staff_nr INTEGER;
    surname  VARCHAR(31);
    forename VARCHAR(31);
    fullname VARCHAR(63);
    age INTEGER;
    gender VARCHAR(10);
    job_code INTEGER;
    income INTEGER;
BEGIN
    get_staffnr('Hans Bauer', staff_nr);
    dbms_output.put_line(staff_nr);
    split_name('Bauer, Hans', surname, forename);
    dbms_output.put_line(forename || ' ' || surname);
    concat_name('Rainer', 'Wahnsinn', fullname);
    dbms_output.put_line(fullname);
    dob_age_emp('96/5/4', age);
    dbms_output.put_line(age);
    dob_age_wor('1.96', age);
    dbms_output.put_line(age);
    get_jobcode('Some Job', job_code);
    dbms_output.put_line(job_code);
    dob_age_wor('5.96', age);
    dbms_output.put_line(age);  
    gender := 'männlich';
    gender_evaluation('Horst', gender);
    dbms_output.put_line('gender' || ' ' || gender);
    gender := 'weiblich';
    gender_evaluation('Frauke', gender);
    dbms_output.put_line('gender' || ' ' || gender);   
    gender := '';
    gender_mapping('Frauke', gender);
    dbms_output.put_line('gender' || ' ' || gender);
    gender := '';
    gender_mapping('Angie', gender);
    dbms_output.put_line('gender' || ' ' || gender);
    income := 3300;
  	annual_income(income, 'e');
    dbms_output.put_line(income);
    income := 20;
  	annual_income(income, 'w');
    dbms_output.put_line(income);
END;
/

--EXECUTE merge_staff;