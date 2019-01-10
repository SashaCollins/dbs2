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
    
           -- String from position 1 (first char) going to first occurrence of '/' - 1 = day
    SELECT TO_NUMBER(SUBSTR(dt, 1, INSTR(dt, '/', 1, 1) - 1)),
           -- String from the first occurrence of '/' + 1 going for the amount of chars
           -- between the second and the first occurrence - 1 to remove the comma
           TO_NUMBER(SUBSTR(dt, INSTR(dt, '/', 1, 1) + 1, INSTR(dt, '/', 1, 2) - INSTR(dt, '/', 1, 1) - 1)),
           -- String from the second occurrence of '/' going to the end of the String
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
    
    -- diff negative? Didn't had his birthday this year so remove it.
    month_diff := month_cur - month_dob;
    IF (month_diff < 0) THEN
      age := age - 1;
    ELSE
      -- same month? We need to check the day then.
      IF (month_diff = 0) THEN
        day_diff := day_cur - day_dob;
        -- diff negative? Didn't had his birthday this year so remove it.
        IF (day_diff < 0) THEN
          age := age - 1;
        END IF;
      END IF;
    END IF;
    
    --dbms_output.put_line(date_dob || ' ' || year_dob || ' ' || month_dob || ' ' || day_dob);
    --dbms_output.put_line(date_cur || ' ' || year_cur || ' ' || month_cur || ' ' || day_cur);
END;
/

CREATE OR REPLACE PROCEDURE merge_staff
IS  surname  VARCHAR(31);
    forename VARCHAR(31);
    age INTEGER;
BEGIN
    split_name('Bauer, Hans', surname, forename);
    dbms_output.put_line(forename || ' ' || surname);
    dob_age_emp('96/5/4', age);
    dbms_output.put_line(age);
END;
/

EXECUTE merge_staff;