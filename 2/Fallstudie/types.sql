CREATE TYPE CampusT AS OBJECT (campus_location VARCHAR(15), campus_addr VARCHAR(127), campus_phone VARCHAR(15), campus_fax VARCHAR(15), campus_head VARCHAR(31));
/
CREATE TYPE ProfessorT AS OBJECT (prof_id INTEGER, prof_name VARCHAR(31), prof_contact VARCHAR(15), prof_research VARCHAR(63), prof_year INTEGER);
/
CREATE TYPE ProfessorListT AS TABLE OF REF ProfessorT;
/
CREATE TYPE RCUnitT AS TABLE OF VARCHAR(127);
/
CREATE TYPE DepartmentT AS OBJECT (dept_id VARCHAR(3), dept_name VARCHAR(31), dept_head VARCHAR(31), dept_prof ProfessorListT);
/
CREATE TYPE DepartmentListT AS TABLE OF DepartmentT;
/
CREATE TYPE SchoolT AS OBJECT (school_id VARCHAR(3), school_name VARCHAR(31), school_head VARCHAR(31), school_prof ProfessorListT);
/
CREATE TYPE SchoolListT AS TABLE OF SchoolT;
/
CREATE TYPE ResearchCentreT AS OBJECT (rc_id VARCHAR(3), rc_name VARCHAR(127), rc_unit RCunitT);
/
CREATE TYPE ResearchCentreListT AS TABLE OF ResearchCentreT;
/
-- TODO aggregation clustering technique
CREATE TYPE FacultyT AS OBJECT (fac_id INTEGER, fac_name VARCHAR(31), fac_dean VARCHAR(15), dept DepartmentListT, school SchoolListT, rc ResearchCentreListT);
/
CREATE TYPE BuildingT AS OBJECT (bld_id VARCHAR(4), bld_name VARCHAR(31), bld_location VARCHAR(2), bld_level INTEGER, campus REF CampusT, fac REF FacultyT);
/
CREATE TYPE PersonT AS OBJECT (person_id VARCHAR(8), person_surname VARCHAR(15), person_forename VARCHAR(15), person_title VARCHAR(7), person_addr VARCHAR(127), person_phone VARCHAR(15), person_postcode VARCHAR(5), campus REF CampusT) NOT FINAL;
/
CREATE TYPE OfficeT AS OBJECT (office_No VARCHAR(7), bld REF BuildingT, office_phone VARCHAR(15));
/
CREATE TYPE ClassroomT AS OBJECT (class_no VARCHAR(4), bld REF BuildingT, class_capacity INTEGER);
/
CREATE TYPE LabEquipmentT AS TABLE OF VARCHAR(15);
/
CREATE TYPE LabT AS OBJECT (lab_no VARCHAR(5), bld REF BuildingT, lab_capacity INTEGER, lab_equipment LabEquipmentT);
/ 
CREATE TYPE DegreeT AS OBJECT (deg_id VARCHAR(4), deg_name VARCHAR(31), deg_length INTEGER, deg_prereq VARCHAR(31), fac REF FacultyT);
/
CREATE TYPE ComputerskillsT AS TABLE OF VARCHAR(15);
/
CREATE TYPE OfficeskillsT AS TABLE OF VARCHAR(31);
/
CREATE TYPE TechnicianskillsT AS TABLE OF VARCHAR(15);
/
CREATE TYPE StaffT UNDER PersonT (person_id VARCHAR(8), office_No VARCHAR(7), staff_type VARCHAR(15)) NOT FINAL;
/
CREATE TYPE StudentT UNDER PersonT (person_id VARCHAR(8), student_year INTEGER);
/
CREATE TYPE AdminT UNDER StaffT (person_id VARCHAR(8), admin_title VARCHAR(31), admin_computerskills ComputerskillsT, admin_officeskills OfficeskillsT);
/
CREATE TYPE TechnicianT UNDER StaffT (person_id VARCHAR(8), tech_title VARCHAR(15), tech_skills TechnicianskillsT);
/ 
CREATE TYPE TutorT UNDER StaffT (person_id VARCHAR(8), tutor_hours INTEGER, tutor_rate DOUBLE PRECISION);
/
CREATE TYPE LecturerT UNDER StaffT (person_id VARCHAR(8), lect_area VARCHAR(31), lect_type VARCHAR(15)) NOT FINAL;
/
CREATE TYPE SeniorLecturerT UNDER LecturerT (person_id VARCHAR(8), senlect_phd INTEGER, senlect_master INTEGER, senlect_honours INTEGER);
/
CREATE TYPE AssociateLecturerT UNDER LecturerT (person_id VARCHAR(8), asslect_honours INTEGER, asslect_year INTEGER);
/
CREATE TYPE SubjectT AS OBJECT (subject_id VARCHAR(8), subject_name VARCHAR(31), subject_credit INTEGER, subject_prereq VARCHAR(8), person REF PersonT);
/



 