CREATE OR REPLACE FUNCTION show_bld_details(in_bld_id IN VARCHAR2) 
   RETURN VARCHAR2
   IS building_details VARCHAR2(255);

BEGIN 

SELECT 'ID: '|| building.bld_id ||', Name: '|| building.bld_name ||', Location: '|| building.bld_location ||', Level: '|| building.bld_level ||', Campus: '|| DEREF(building.campus).campus_location ||', Faculty: '||DEREF(building.fac).fac_name
  INTO building_details
  FROM Building building
  WHERE building.bld_id = in_bld_id;

  RETURN(building_details); 

END show_bld_details;
-- Example:
-- SELECT show_bld_details('BB1') AS "Building Info" FROM DUAL;


CREATE OR REPLACE FUNCTION insert_student(in_person_id IN VARCHAR, in_year IN NUMBER) 
   RETURN VARCHAR2
   IS success_state VARCHAR2(5);  -- boolean type not supported

BEGIN 

INSERT INTO Student (
  SELECT pers.*, in_year FROM Person pers
  WHERE pers.person_id = in_person_id
);
success_state := 'TRUE';
RETURN(success_state); 

END insert_student;


CREATE OR REPLACE FUNCTION delete_student(in_person_id IN VARCHAR) 
   RETURN VARCHAR2
   IS success_state VARCHAR2(5);  -- boolean type not supported

BEGIN 

DELETE FROM Student student WHERE student.person_id = in_person_id;
success_state := 'TRUE';
RETURN(success_state); 

END delete_student; 