CREATE TABLE People (
  person_id INT NOT NULL,
  person_name VARCHAR(63),
  person_age INT,
  person_place VARCHAR(63),
  CONSTRAINT pers_id PRIMARY KEY (person_id)
);

INSERT INTO People VALUES(0, 'Hans', 34, 'Bonn');
INSERT INTO People VALUES(1, 'Werner', 18, 'Berlin');
INSERT INTO People VALUES(2, 'Jürgen', 74, 'München');
INSERT INTO People VALUES(3, 'Luis', 25, 'Augsburg');
INSERT INTO People VALUES(4, 'Nicklas', 22, 'Regensburg');
INSERT INTO People VALUES(5, 'Jens', 49, 'Prag');
INSERT INTO People VALUES(6, 'Marvin', 17, 'Cottbus');
INSERT INTO People VALUES(7, 'Sophia', 22, 'München');
INSERT INTO People VALUES(8, 'Günther', 63, 'Ulm');
INSERT INTO People VALUES(9, 'Sebastian', 19, 'Ingolstadt');

CREATE OR REPLACE FUNCTION min_max_scale(v IN INT, new_min IN INT, new_max IN INT, old_min IN INT, old_max IN INT) 
   RETURN INT
   IS new_v INT;

BEGIN 

new_v := ((v - old_min) / (old_max - old_min)) * (new_max - new_min) + new_min;  -- min max impl
RETURN(new_v); 

END min_max_scale;
/

CREATE OR REPLACE PROCEDURE MinMax_Scaling (new_min INT, new_max INT) IS 
old_min INT;
old_max INT;
new_age INT;
BEGIN
SELECT MIN(person_age) as min_age, MAX(person_age) as max_age INTO old_min, old_max FROM People; -- get min and max

FOR person IN (SELECT * FROM People)
LOOP
  SELECT min_max_scale(person.person_age, new_min, new_max, old_min, old_max) INTO new_age FROM DUAL;
  UPDATE People SET person_age = new_age WHERE person_id = person.person_id;
END LOOP;
END;
/

EXECUTE MinMax_Scaling(10, 50);