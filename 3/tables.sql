CREATE TABLE Employee (
	emp_nr INT NOT NULL,
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
	staff_nr INT NOT NULL,
	surname VARCHAR(31),
	forename VARCHAR(31),
	age INT,
	gender INT,  -- 0 = unknown, 1 = female, 2 = male
	job_code VARCHAR(7),
	salary_year DOUBLE PRECISION,
	CONSTRAINT s_nr PRIMARY KEY (staff_nr)
);

CREATE TABLE Gender (
	forename VARCHAR(31),
	gender VARCHAR(1),  -- 1 = female, 2 = male
	CONSTRAINT gender_entry PRIMARY KEY (forename, gender)
);

CREATE TABLE Jobcode (
	job_code VARCHAR(7),
	job_title VARCHAR(63),
	CONSTRAINT jobcode_entry PRIMARY KEY (job_code, job_title)
);

CREATE TABLE Source (
	staff_nr INT,
	source_table VARCHAR(1), -- e = Employee, w = Worker
	original_primary_key VARCHAR(10) -- Problem: Worker has no Primary Key, how to identify?
);