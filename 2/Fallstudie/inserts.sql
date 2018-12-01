INSERT INTO Campus 
VALUES (CampusT('Albury/Wodonga', 'Parkers Road Wodonga VIC 3690', 
          '61260583700', '620260583777', 'John Hill'));
INSERT INTO Campus 
VALUES (CampusT('City', '215 Franklin St. Melb VIC 3000', 
          '61392855100', '610392855111', 'Michael A. O''Leary'));
INSERT INTO Campus 
VALUES (CampusT('Mildura', 'Benetook Ave. Mildura VIC 3502', 
          '61350223757', '61350223646', 'Ron Broadhead'));
INSERT INTO Campus 
VALUES (CampusT('Bundoora', '221b Baker St. London NW1', 
          '6195135755', '6137196482', 'Sherlock Holmes'));

INSERT INTO Faculty 
VALUES (FacultyT(1, 'Health Science', 'S. Duckett', 
          DepartmentListT(), SchoolListT(), ResearchCentreListT()));
INSERT INTO Faculty 
VALUES (FacultyT(2, 'Humanity '||'&'||' Social Sc.', 'J. A. Salmond', 
          DepartmentListT(), SchoolListT(), ResearchCentreListT()));
INSERT INTO Faculty 
VALUES (FacultyT(3, 'Law '||'&'||' Management', 'G. C. O''Brien', 
          DepartmentListT(), SchoolListT(), ResearchCentreListT()));
INSERT INTO Faculty 
VALUES (FacultyT(4, 'Science, Tech. '||'&'||' Eng.', 'D. Finlay', 
          DepartmentListT(), SchoolListT(), ResearchCentreListT()));
INSERT INTO Faculty 
VALUES (FacultyT(5, 'Regional Department', 'L. Kilmartin', 
          DepartmentListT(), SchoolListT(), ResearchCentreListT()));

INSERT INTO Professor VALUES (ProfessorT(42, 'Nick Hoogenraad', 'hoogenraad@cu.edu', 'Advanced Software Engineering', 2007));
INSERT INTO Professor VALUES (ProfessorT(88, 'Robin Anders', 'robin.anders@cu.edu', 'Computer Architecture', 2017));
INSERT INTO Professor VALUES (ProfessorT(101, 'Claude Bernard', 'cbernard@cu.edu', 'Networking', 2016));
INSERT INTO Professor VALUES (ProfessorT(420, 'Bruce Stone', 'b.stone@cu.edu', 'Software Development', 2015));
INSERT INTO Professor VALUES (ProfessorT(555, 'Chris Handley', 'handley@cu.edu', 'Compiler', 2009));
INSERT INTO Professor VALUES (ProfessorT(782, 'Sheena Reilly', 'sheenareilly@cu.edu', 'Discrete Mathematics', 2005));
INSERT INTO Professor VALUES (ProfessorT(1001, 'Alison Perry', 'Alison.Perry@cu.edu', 'Physics', 2012));
INSERT INTO Professor VALUES (ProfessorT(1337, 'Jan Branson', 'branson@cu.edu', 'Software Architecture', 2018));	  

INSERT INTO TABLE (SELECT dept FROM Faculty WHERE fac_id=4) 
VALUES(DepartmentT('4-1', 'Agricultural Sciences', 'Mark Sandeman', 
          ProfessorListT()));
INSERT INTO TABLE (SELECT dept FROM Faculty WHERE fac_id=4) 
VALUES(DepartmentT('4-2', 'Biochemistry', 'Nick Hoogenraad', 
          ProfessorListT()));

INSERT INTO TABLE (SELECT school FROM Faculty WHERE fac_id=1) 
VALUES(SchoolT('1-1', 'Human Biosciences', 'Chris Handley', 
          ProfessorListT((SELECT REF(p) FROM Professor p WHERE p.prof_id=555))));
INSERT INTO TABLE (SELECT school FROM Faculty WHERE fac_id=1) 
VALUES(SchoolT('1-2', 'Human Comm. Sciences', 'Elizabeth Lavender', 
          ProfessorListT()));

INSERT INTO TABLE (SELECT rc FROM Faculty WHERE fac_id=1) 
VALUES(ResearchCentreT('1-1', 'Australian Research Centre in Sex, Health '||'&'||' Society', 'Martin Pitts', RCUnitT()));
INSERT INTO TABLE (SELECT rc FROM Faculty WHERE fac_id=1) 
VALUES(ResearchCentreT('1-2', 'Australian Institute for Primary Care', 'Hal Swerissen', RCUnitT()));

INSERT INTO TABLE(SELECT dept_prof FROM TABLE(SELECT dept FROM Faculty WHERE fac_id=4) dep WHERE dep.dept_id = '4-2') (SELECT REF(p) FROM Professor p WHERE p.prof_id=42 OR p.prof_id=88 OR p.prof_id=101 OR p.prof_id=420);

INSERT INTO TABLE(SELECT school_prof FROM TABLE(SELECT school FROM Faculty WHERE fac_id=1) scho WHERE scho.school_id = '1-2') (SELECT REF(p) FROM Professor p WHERE p.prof_id=782 OR p.prof_id=1001 OR p.prof_id=1337);

INSERT INTO TABLE (SELECT rc_unit FROM TABLE (SELECT rc FROM Faculty WHERE fac_id=1) r WHERE r.rc_id='1-1')
VALUES('SSAY Projects');
INSERT INTO TABLE (SELECT rc_unit FROM TABLE (SELECT rc FROM Faculty WHERE fac_id=1) r WHERE r.rc_id='1-1')
VALUES('HIV Futures');
INSERT INTO TABLE (SELECT rc_unit FROM TABLE (SELECT rc FROM Faculty WHERE fac_id=1) r WHERE r.rc_id='1-1')
VALUES('Australian Study of Health and Relationships');

INSERT INTO TABLE (SELECT rc_unit FROM TABLE (SELECT rc FROM Faculty WHERE fac_id=1) r WHERE r.rc_id='1-2')
VALUES('Centre for Dev. and Innovation in Health');
INSERT INTO TABLE (SELECT rc_unit FROM TABLE (SELECT rc FROM Faculty WHERE fac_id=1) r WHERE r.rc_id='1-2')
VALUES('Centre for Quality in Health '||'&'||' Community Svc.');
INSERT INTO TABLE (SELECT rc_unit FROM TABLE (SELECT rc FROM Faculty WHERE fac_id=1) r WHERE r.rc_id='1-2')
VALUES('Lincoln Gerontology Centre');

INSERT INTO Building 
VALUES (BuildingT('BB1', 'Beth Gleeson', 'D5', 4, 
          (SELECT REF(c) FROM Campus c WHERE c.campus_location='Bundoora'), 
          (SELECT REF(f) FROM Faculty f WHERE f.fac_id=4)));
INSERT INTO Building 
VALUES (BuildingT('BB2', 'Martin Building', 'F5', 4, 
          (SELECT REF(c) FROM Campus c WHERE c.campus_location='Bundoora'), 
          (SELECT REF(f) FROM Faculty f WHERE f.fac_id=3)));
INSERT INTO Building 
VALUES (BuildingT('BB3', 'Thomas Cherry', 'D4', 4, 
          (SELECT REF(c) FROM Campus c WHERE c.campus_location='Bundoora'), 
          (SELECT REF(f) FROM Faculty f WHERE f.fac_id=1)));
INSERT INTO Building 
VALUES (BuildingT('BB4', 'Physical Science 1', 'D5', 3, 
          (SELECT REF(c) FROM Campus c WHERE c.campus_location='Bundoora'), 
          (SELECT REF(f) FROM Faculty f WHERE f.fac_id=4)));

INSERT INTO Office 
VALUES (OfficeT('BG207',
          (SELECT REF(b) FROM Building b WHERE b.bld_id='BB4'),
          '94791118'));
INSERT INTO Office 
VALUES (OfficeT('BG208', 
          (SELECT REF(b) FROM Building b WHERE b.bld_id='BB4'),
          '94792393'));

INSERT INTO Classroom 
VALUES (ClassroomT('TCLT',
          (SELECT REF(b) FROM Building b WHERE b.bld_id='BB3'),
          50));
INSERT INTO Classroom 
VALUES (ClassroomT('TC01',
          (SELECT REF(b) FROM Building b WHERE b.bld_id='BB3'),
          30));

INSERT INTO Lab 
VALUES (LabT('BG113',
          (SELECT REF(b) FROM Building b WHERE b.bld_id='BB1'), 
          25, LabEquipmentT('25 PC', '1 Printer')));
INSERT INTO Lab 
VALUES (LabT('BG114',
          (SELECT REF(b) FROM Building b WHERE b.bld_id='BB1'), 
          20, LabEquipmentT('21 PC')));

INSERT INTO DegreeTbl 
VALUES (DegreeT('D100', 'Bachelor of Comp. Sci', 3, 'Year 12 or equivalent',
          (SELECT REF(f) FROM Faculty f WHERE f.fac_id=4)));
INSERT INTO DegreeTbl 
VALUES (DegreeT('D101', 'Master of Comp. Sci', 2, 'Bachelor of Comp. Sci', 
          (SELECT REF(f) FROM Faculty f WHERE f.fac_id=4)));

INSERT INTO Person 
VALUES (PersonT('01234234', 'Grant', 'Felix', 'Mr', '2 Boadle Rd Bundoora VIC', '0398548753', '3083', 
          (SELECT REF(c) FROM Campus c WHERE c.campus_location='Bundoora')));
INSERT INTO Person 
VALUES (PersonT('10008895', 'Xin', 'Harry', 'Mr', '6 Kelley St Kew VIC', 
          '0398875542', '3088', 
          (SELECT REF(c) FROM Campus c WHERE c.campus_location='Bundoora')));
INSERT INTO Person 
VALUES (PersonT('10002935', 'Jones', 'Felicity', 'Ms', '14 Rennie St Thornbury VIC', '0398722001', '3071', 
          (SELECT REF(c) FROM Campus c WHERE c.campus_location='Bundoora')));
-- additional People needed for Staff
INSERT INTO Person 
VALUES (PersonT('01958652', 'John', 'Doe', 'Mr', '14 Rennie St Thornbury VIC', '0321343123', '1337', 
          (SELECT REF(c) FROM Campus c WHERE c.campus_location='City')));
-- additional staff over

INSERT INTO Staff (SELECT * FROM (SELECT pers.*, 'BG212', 'Lecturer' FROM Person pers WHERE pers.person_id = 10008895));
INSERT INTO Staff (SELECT * FROM (SELECT pers.*, 'BG210', 'Admin' FROM Person pers WHERE pers.person_id = 10002935));

INSERT INTO Student (SELECT * FROM (SELECT pers.*, 2000 FROM Person pers WHERE pers.person_id = 01234234));
INSERT INTO Student (SELECT * FROM (SELECT pers.*, 2000 FROM Person pers WHERE pers.person_id = 01958652));

INSERT INTO AdminTbl (SELECT * FROM (SELECT staff.*, 'Office Manager', ComputerskillsT(), OfficeskillsT() FROM Staff staff WHERE staff.person_id = 10002935));
-- done
-- TODO Fix statements underneath (missing entries in Person / Staff / etc. Tables)
INSERT INTO AdminTbl (SELECT * FROM (SELECT staff.*, 'Receptionist', ComputerskillsT(), OfficeskillsT() FROM Staff staff WHERE staff.person_id = 10008957));
 
INSERT INTO TABLE (SELECT admin_officeskills FROM AdminTbl WHERE person_id = '10002935')
VALUES('Managerial');
/* -- TODO Create Person and Staff with that ID
INSERT INTO TABLE (SELECT admin_computerskills FROM AdminTbl WHERE person_id = '10008957')
VALUES('MS Office');
INSERT INTO TABLE (SELECT admin_officeskills FROM AdminTbl WHERE person_id = '10008957')
VALUES('Customer Service');
INSERT INTO TABLE (SELECT admin_officeskills FROM AdminTbl WHERE person_id = '10008957')
VALUES('Phone');
*/

INSERT INTO Technician (SELECT * FROM (SELECT staff.*, 'Network Officer', TechnicianskillsT() FROM Staff staff WHERE staff.person_id = 10005825));
INSERT INTO Technician (SELECT * FROM (SELECT staff.*, 'Photocopy Technician', TechnicianskillsT() FROM Staff staff WHERE staff.person_id = 10015826));

/* -- TODO Create Person and Staff with that IDs
INSERT INTO TABLE (SELECT tech_skills FROM Technician WHERE person_id = '10005825')
VALUES('UNIX');
INSERT INTO TABLE (SELECT tech_skills FROM Technician WHERE person_id = '10005825')
VALUES('NT');
INSERT INTO TABLE (SELECT tech_skills FROM Technician WHERE person_id = '10015826')
VALUES('Electrician');
*/

INSERT INTO Lecturer (SELECT * FROM (SELECT staff.*, 'Software Engineering', 'Associate' FROM Staff staff WHERE staff.person_id = 10008895));
INSERT INTO Lecturer (SELECT * FROM (SELECT staff.*, 'Business Information', 'Senior' FROM Staff staff WHERE staff.person_id = 10000255));

INSERT INTO SeniorLecturer (SELECT * FROM (SELECT lec.*, 2, 5, 7 FROM Lecturer lec WHERE lec.person_id = 10000255));
INSERT INTO SeniorLecturer (SELECT * FROM (SELECT lec.*, NULL, 1, 5 FROM Lecturer lec WHERE lec.person_id = 10000258));

INSERT INTO AssociateLecturer (SELECT * FROM (SELECT lec.*, 2, 1999 FROM Lecturer lec WHERE lec.person_id = 10008895));
INSERT INTO AssociateLecturer (SELECT * FROM (SELECT lec.*, NULL, 2001 FROM Lecturer lec WHERE lec.person_id = 10006935));

INSERT INTO Tutor (SELECT * FROM (SELECT staff.*, 10, 20.00 FROM Staff staff WHERE staff.person_id = 01234234));
INSERT INTO Tutor (SELECT * FROM (SELECT staff.*, 30, 35.00 FROM Staff staff WHERE staff.person_id = 01958652));

INSERT INTO Subject 
VALUES (SubjectT('CSE21NET', 'Networking', 10, 'CSE11IS', 
          (SELECT REF(p) FROM Person p WHERE p.person_id='10008895')));
INSERT INTO Subject 
VALUES (SubjectT('CSE42ADB', 'Advanced Database', 15, 'CSE21DB',
          (SELECT REF(p) FROM Person p WHERE p.person_id='10006935')));

INSERT INTO Enrolls_in VALUES ('01234234', 'D101');
INSERT INTO Enrolls_in VALUES ('10012568', 'D101');

INSERT INTO Takes VALUES ('01234234', 'CSE42ADB', 70);
INSERT INTO Takes VALUES ('10012568', 'CSE42ADB', 80);