CREATE TYPE BuildingT AS OBJECT (bld_id VARCHAR(4), bld_name VARCHAR(31), bld_location VARCHAR(2), bld_level INTEGER, campus_location VARCHAR(15), fac_id INTEGER);
/
CREATE TYPE CampusT AS OBJECT (campus_location VARCHAR(15), campus_addr VARCHAR(127), campus_phone VARCHAR(15), campus_fax VARCHAR(15), campus_head VARCHAR(31));
/
CREATE TYPE PersonT AS OBJECT (person_id VARCHAR(8), person_surname VARCHAR(15), person_forename VARCHAR(15), person_title VARCHAR(7), person_addr VARCHAR(127), person_phone VARCHAR(15), person_postcode VARCHAR(5), campus_location VARCHAR(15));
/
CREATE TYPE ProfessorT AS OBJECT (prof_id INTEGER, prof_name VARCHAR(31), prof_contact VARCHAR(15), prof_research VARCHAR(63), prof_year INTEGER);
/
CREATE TYPE RCUnitT AS TABLE OF VARCHAR(63);
/
CREATE TYPE DepartmentT AS OBJECT (dept_id VARCHAR(3), dept_name VARCHAR(31), dept_head VARCHAR(31), dept_prof ProfessorT);
/
CREATE TYPE SchoolT AS OBJECT (school_id VARCHAR(3), school_name VARCHAR(31), school_head VARCHAR(31), school_prof ProfessorT);
/
CREATE TYPE ResearchCentreT AS OBJECT (rc_id VARCHAR(3), rc_name VARCHAR(63), rc_unit RCunitT);
/
CREATE TYPE FacultyT AS OBJECT (fac_id INTEGER, fac_name VARCHAR(31), fac_dean VARCHAR(15), dept DepartmentT, school SchoolT, rc ResearchCentreT);
/ -- TODO aggregation clustering technique
CREATE TYPE OfficeT AS OBJECT (bld_id VARCHAR(4), office_No  VARCHAR(7), office_phone VARCHAR(15));
/
CREATE TYPE ClassroomT AS OBJECT (bld_id VARCHAR(4), class_no VARCHAR(4), class_capacity INTEGER);
/
CREATE TYPE LabEquipmentT AS TABLE OF VARCHAR(15);
/
CREATE TYPE LabT AS OBJECT (bld_id VARCHAR(4), lab_no VARCHAR(5), lab_capacity INTEGER, lab_equipment LabEquipmentT);
/ 
CREATE TYPE DegreeT AS OBJECT (deg_id VARCHAR(4), deg_name VARCHAR(31), deg_length INTEGER, deg_prereq VARCHAR(31), fac_id INTEGER);
/
CREATE TYPE ComputerskillsT AS TABLE OF VARCHAR(15);
/
CREATE TYPE OfficeskillsT AS TABLE OF VARCHAR(31);
/
CREATE TYPE TechnicanskillsT AS TABLE OF VARCHAR(15);
/
CREATE TYPE StaffT UNDER PersonT (office_No VARCHAR(7), staff_type VARCHAR(15));
/
CREATE TYPE StudentT UNDER PersonT (student_year INTEGER);
/
CREATE TYPE AdminT UNDER StaffT (admin_title VARCHAR(31), admin_computerskills ComputerskillsT, admin_officeskills OfficeskillsT);
/
CREATE TYPE TechnicanT UNDER StaffT (tech_title VARCHAR(15), tech_skills TechnicanskillsT);
/ -- TODO
CREATE TYPE TutorT UNDER StaffT (office_No VARCHAR(7), staff_type VARCHAR(15));
/
CREATE TYPE LecturerT UNDER StaffT (office_No VARCHAR(7), staff_type VARCHAR(15));
/
CREATE TYPE SeniorLecturerT UNDER LecturerT (office_No VARCHAR(7), staff_type VARCHAR(15));
/
CREATE TYPE AssociateLecturerT UNDER LecturerT (office_No VARCHAR(7), staff_type VARCHAR(15));
/
