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

-- return 0, 1 or 2
CREATE OR REPLACE PROCEDURE gendermapping(forname IN VARCHAR, gender OUT VARCHAR)
IS	answer INTEGER;
    fn VARCHAR(31);
BEGIN  
  -- if w then look for name in gender table
  -- if 1 entry use this (2 or 1)
  -- else use 0
  
  
    -- does not work like this
	SELECT COUNT(*)
	INTO answer
	FROM Gender  g 
	WHERE g.forname = forname;
	 
	IF answer = 1 THEN
    fn := forename;
    --gender := select gender from table
	ELSE
    
    gender := 0;
	END IF;

END;
/

CREATE OR REPLACE PROCEDURE gender_evaluetion(forename IN VARCHAR, gender IN OUT VARCHAR)
IS answer INTEGER;
BEGIN
	-- if e then map m, w to 2, 1
	-- check if already in gender table
	-- if false then insert into gendertable
	-- else 
	-- return 2 or 1
	
	IF gender = 'w' THEN
		gender := 1;
	ELSE	
		IF gender = 'm' THEN
			gender := 2;
		END IF;
	END IF;
	
	SELECT COUNT(*)
	INTO answer
	FROM Gender g 
	WHERE g.forname = forname AND g.gender = gender;
	
	IF answer = 0 THEN
	-- insert
	END IF;
	

END;
/

CREATE OR REPLACE PROCEDURE annual_income(income IN OUT INTEGER, source IN VARCHAR)
IS 
BEGIN
	IF (source == 'e') THEN
		income := income * 12
	ELSE 
		IF (source == 'w')	THEN
			income := income * 12 * (8 * 5 * 4.3)
		END IF;
	END IF;
END;
/

CREATE OR REPLACE PROCEDURE generate_id(digits IN INTEGER, new_id IN OUT INTEGER)
IS
  max_nr INTEGER := 9;
  id_str VARCHAR(9);
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

CREATE OR REPLACE PROCEDURE merge_staff
IS  surname  VARCHAR(31);
    forename VARCHAR(31);
    age INTEGER;
    income INTEGER;
BEGIN
    split_name('Bauer, Hans', surname, forename);
    dbms_output.put_line(forename || ' ' || surname);
    dob_age_emp('96/5/4', age);
    dbms_output.put_line(age);
	dob_age_wor('1.96', age);
    dbms_output.put_line(age)
    get_jobcode('Some Job', job_code);
    dbms_output.put_line(job_code);
	dob_age_wor('5.96', age);
    dbms_output.put_line(age);
    income := 3300;
  	annual_income(income, 'e');
    dbms_output.put_line(income);
    income := 20;
  	annual_income(income, 'w');
    dbms_output.put_line(income);
END;
/

--EXECUTE merge_staff;