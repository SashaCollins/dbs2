CREATE TABLE Campus OF CampusT;

CREATE TABLE Professor OF ProfessorT;

CREATE TABLE Faculty OF FacultyT 
NESTED TABLE dept STORE AS department_nm(NESTED TABLE dept_prof STORE AS dept_prof_nm)
NESTED TABLE school STORE AS school_nm(NESTED TABLE school_prof STORE AS school_prof_nm)
NESTED TABLE rc STORE AS rc_nm(NESTED TABLE rc_unit STORE AS rc_unit_nm);

CREATE TABLE Building OF BuildingT;

CREATE TABLE Person OF PersonT;

CREATE TABLE Office OF OfficeT;

CREATE TABLE Classroom OF ClassroomT;

CREATE TABLE Lab OF LabT
NESTED TABLE lab_equipment STORE AS lab_equip_nm;

CREATE TABLE DegreeTbl OF DegreeT;

CREATE TABLE Staff OF StaffT;

CREATE TABLE Student OF StudentT;

CREATE TABLE AdminTbl OF AdminT
NESTED TABLE admin_computerskills STORE AS adm_comskill_nm
NESTED TABLE admin_officeskills STORE AS adm_offskill_nm;

CREATE TABLE Technician OF TechnicianT
NESTED TABLE tech_skills STORE AS tech_skill_nm;

CREATE TABLE Tutor OF TutorT;

CREATE TABLE Lecturer OF LecturerT;

CREATE TABLE SeniorLecturer OF SeniorLecturerT;

CREATE TABLE AssociateLecturer OF AssociateLecturerT;

CREATE TABLE Subject OF SubjectT;

CREATE TABLE Enrolls_in (student REF StudentT, deg REF DegreeT);

CREATE TABLE Takes (student REF StudentT, subject REF SubjectT, mark INTEGER);