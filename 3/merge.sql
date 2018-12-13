CREATE TABLE Employee (
  emp_nr INT NOT NULL,
  name VARCHAR(63), -- surname, forname
  dob VARCHAR(8),  -- yy/mm/dd
  job_title VARCHAR(63),
  salery_month DOUBLE PRECISION,
  gender VARCHAR(9),  -- männlich / weiblich
  CONSTRAINT employee_nr PRIMARY KEY (emp_nr)
);

CREATE TABLE Worker (
  surname VARCHAR(31),
  forename VARCHAR(31),
  birth_month VARCHAR(5),  -- mm.yy
  salary_hour DOUBLE PRECISION
);

CREATE TABLE Staff (
  staff_nr INT NOT NULL,
  surname VARCHAR(31),
  forename VARCHAR(31),
  age INT,
  gender INT,  -- 0 = unknown, 1 = female, 2 = male
  job_code VARCHAR(7),
  salary_year DOUBLE PRECISION,
  CONSTRAINT s_nr PRIMARY KEY (staff_nr)
);