CREATE TABLE Employee (
	emp_nr VARCHAR(9) NOT NULL,
	name VARCHAR(31), -- surname, forname
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
	staff_nr INTEGER NOT NULL,
	surname VARCHAR(31),
	forename VARCHAR(31),
	age INT,
	gender INT,  -- 0 = unknown, 1 = female, 2 = male
	job_code VARCHAR(7),
	salary_year DOUBLE PRECISION,
	CONSTRAINT s_nr PRIMARY KEY (staff_nr)
);

CREATE TABLE Jobcode (
	code INTEGER PRIMARY KEY,
	description VARCHAR(63)
);

CREATE TABLE Gender (
	forename VARCHAR(31),
	gender VARCHAR(1),  -- 1 = female, 2 = male
	CONSTRAINT gender_entry PRIMARY KEY (forename, gender)
);

CREATE TABLE Identifier (
	staff_nr INTEGER PRIMARY KEY,
	source_table VARCHAR(1), -- e = Employee, w = Worker
	pk VARCHAR(63) -- Employee: emp_nr, Worker: Forename + Surname
);