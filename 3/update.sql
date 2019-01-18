-- Update Tables after first execute

-- Both INSERT and UPDATE

INSERT INTO Employee VALUES ('10', 'Lecter, Hannibal', '75/11/02', 'Psychiatrist', 8000.00, 'männlich');
INSERT INTO Employee VALUES ('11', 'Watson, John', '88/07/23', 'Doctor', 4300.00, 'männlich');


-- dob and job title
UPDATE Employee e
SET e.name = 'Duck, Dagobert', e.dob = '89/02/14',
    e.job_title = 'Billionair',
    e.salary_month = 30000.00, e.gender = 'männlich'
WHERE e.emp_nr = '2';

-- salery
UPDATE Employee e
SET e.name = 'Holmes, Sherlock', e.dob = '81/07/12',
    e.job_title = 'Consulting Detective',
    e.salary_month = 5400.00, e.gender = 'männlich'
WHERE e.emp_nr = '0';


INSERT INTO Worker VALUES ('Smith', 'Will', '09.68', 125.0);
-- dob
UPDATE Worker w
SET w.birth_month = '05.84', w.salary_hour = 150.0
WHERE w.surname = 'Fischer' AND w.forename = 'Rainer';