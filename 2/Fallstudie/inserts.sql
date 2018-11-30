INSERT INTO Campus 
VALUES (CampusT('Albury/Wodonga', 'Parkers Road Wodonga VIC 3690', 
          '61260583700', '620260583777', 'John Hill'));
INSERT INTO Campus 
VALUES (CampusT('City', '215 Franklin St. Melb VIC 3000', 
          '61392855100', '610392855111', 'Michael A. O''leary'));
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
VALUES (FacultyT(2, 'Humanity & Social Sc.', 'J. A. Salmond', 
          DepartmentListT(), SchoolListT(), ResearchCentreListT()));
INSERT INTO Faculty 
VALUES (FacultyT(3, 'Law & Management', 'G. C. O''Brien', 
          DepartmentListT(), SchoolListT(), ResearchCentreListT()));
INSERT INTO Faculty 
VALUES (FacultyT(4, 'Science, Tech. & Eng.', 'D. Finlay', 
          DepartmentListT(), SchoolListT(), ResearchCentreListT()));
INSERT INTO Faculty 
VALUES (FacultyT(5, 'Regional Department', 'L. Kilmartin', 
          DepartmentListT(), SchoolListT(), ResearchCentreListT()));

INSERT INTO TABLE (SELECT dept FROM Faculty WHERE fac_id=4) 
VALUES(DepartmentT('4-1', 'Agricultural Sciences', 'Mark Sandeman', 
          ProfessorListT()));
INSERT INTO TABLE (SELECT dept FROM Faculty WHERE fac_id=4) 
VALUES(DepartmentT('4-2', 'Biochemistry', 'Nick Hoogenraad', 
          ProfessorListT()));

INSERT INTO TABLE (SELECT school FROM Faculty WHERE fac_id=1) 
VALUES(SchoolT('1-1', 'Human Biosciences', 'Chris Handley', 
          ProfessorListT()));
INSERT INTO TABLE (SELECT school FROM Faculty WHERE fac_id=1) 
VALUES(SchoolListT('1-2', 'Human Comm. Sciences', 'Elizabeth Lavender', 
          ProfessorListT()));

INSERT INTO TABLE (SELECT rc FROM Faculty WHERE fac_id=1) 
VALUES(ResearchCentreT('1-1', 'Australian Research Centre in Sex, Health & Society', 'Martin Pitts', 
          RCUnitT()));
INSERT INTO TABLE (SELECT rc FROM Faculty WHERE fac_id=1) 
VALUES(ResearchCentreT('1-2', 'Australian Institute for Primary Care', 'Hal Swerissen', 
          RCUnitT()));

INSERT INTO TABLE (SELECT dept_prof FROM (SELECT dept FROM Faculty WHERE fac_id=4) d WHERE d.dept_id='4-2')
VALUES ('Nick Hoogenraad');
INSERT INTO TABLE (SELECT dept_prof FROM (SELECT dept FROM Faculty WHERE fac_id=4) d WHERE d.dept_id='4-2')
VALUES ('Robin Anders');
INSERT INTO TABLE (SELECT dept_prof FROM (SELECT dept FROM Faculty WHERE fac_id=4) d WHERE d.dept_id='4-2')
VALUES ('Claude Bernard');
INSERT INTO TABLE (SELECT dept_prof FROM (SELECT dept FROM Faculty WHERE fac_id=4) d WHERE d.dept_id='4-2')
VALUES ('Bruce Stone');

INSERT INTO TABLE (SELECT dept_prof FROM (SELECT school FROM Faculty WHERE fac_id=1) s WHERE s.school_id='1-1')
VALUES ('Chris Handley');
INSERT INTO TABLE (SELECT dept_prof FROM (SELECT school FROM Faculty WHERE fac_id=1) s WHERE s.school_id='1-2')
VALUES ('Sheena Reilly');
INSERT INTO TABLE (SELECT dept_prof FROM (SELECT school FROM Faculty WHERE fac_id=1) s WHERE s.school_id='1-2')
VALUES ('Alison Perry');
INSERT INTO TABLE (SELECT dept_prof FROM (SELECT school FROM Faculty WHERE fac_id=1) s WHERE s.school_id='1-2')
VALUES ('Jan Branson');

INSERT INTO TABLE (SELECT rc_unit FROM (SELECT rc FROM Faculty WHERE fac_id=1) r WHERE r.rc_id='1-1')
VALUES('SSAY Projects');
INSERT INTO TABLE (SELECT rc_unit FROM (SELECT rc FROM Faculty WHERE fac_id=1) r WHERE r.rc_id='1-1')
VALUES('HIV Futures');
INSERT INTO TABLE (SELECT rc_unit FROM (SELECT rc FROM Faculty WHERE fac_id=1) r WHERE r.rc_id='1-1')
VALUES('Australian Study of Health and Relationships');

INSERT INTO TABLE (SELECT rc_unit FROM (SELECT rc FROM Faculty WHERE fac_id=1) r WHERE r.rc_id='1-2')
VALUES('Centre for Dev. and Innovation in Health');
INSERT INTO TABLE (SELECT rc_unit FROM (SELECT rc FROM Faculty WHERE fac_id=1) r WHERE r.rc_id='1-2')
VALUES('Centre for Quality in Health & Community Svc.');
INSERT INTO TABLE (SELECT rc_unit FROM (SELECT rc FROM Faculty WHERE fac_id=1) r WHERE r.rc_id='1-2')
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
VALUES (PersonT('01234234', 'Grant', 'Felix', 'Mr', '2 Boadle Rd Bundoora VIC',
          '0398548753', '3083', 
          (SELECT REF(c) FROM Campus c WHERE c.campus_location='Bundoora')));
INSERT INTO Person 
VALUES (PersonT('10008895', 'Xin', 'Harry', 'Mr', '6 Kelley St Kew VIC', 
          '0398875542', '3088', 
          (SELECT REF(c) FROM Campus c WHERE c.campus_location='Bundoora')));
INSERT INTO Person 
VALUES (PersonT('10002935', 'Jones', 'Felicity', 'Ms', '14 Rennie St Thornbury VIC',
          '0398722001', '3071', 
          (SELECT REF(c) FROM Campus c WHERE c.campus_location='Bundoora')));

INSERT INTO Staff VALUES (StaffT('10008895', 'BB1', 'BG212', 'Lecturer'));
INSERT INTO Staff VALUES (StaffT('10002935', 'BB4', 'BG210', 'Admin'));

INSERT INTO Student VALUES (StudentT('01234234', 2000));
INSERT INTO Student VALUES (StudentT('01958652', 2000));

INSERT INTO AdminTbl 
VALUES (AdminT('10002935', 'Office Manager', 
          ComputerskillsT(NULL), 
          OfficeskillsT()));
INSERT INTO AdminTbl 
VALUES (AdminT('10008957', 'Receptionist', 
          ComputerskillsT('MS Office'), 
          OfficeskillsT()));
 
INSERT INTO TABLE (SELECT admin_officeskills FROM AdminTbl WHERE person_id = '10002935')
VALUES('Managerial');
INSERT INTO TABLE (SELECT admin_computerskills FROM AdminTbl WHERE person_id = '10008957')
VALUES('MS Office');
INSERT INTO TABLE (SELECT admin_officeskills FROM AdminTbl WHERE person_id = '10008957')
VALUES('Customer Service');
INSERT INTO TABLE (SELECT admin_officeskills FROM AdminTbl WHERE person_id = '10008957')
VALUES('Phone');

INSERT INTO Technician 
VALUES (TechnicianT('10005825', 'Network Officer', 
          TechnicianskillsT()));
INSERT INTO Technician 
VALUES (TechnicianT('10015826', 'Photocopy Technician', 
          TechnicianskillsT()));

INSERT INTO TABLE (SELECT tech_skills FROM Technician WHERE person_id = '10005825')
VALUES('UNIX');
INSERT INTO TABLE (SELECT tech_skills FROM Technician WHERE person_id = '10005825')
VALUES('NT');
INSERT INTO TABLE (SELECT tech_skills FROM Technician WHERE person_id = '10015826')
VALUES('Electrician');

INSERT INTO Lecturer 
VALUES (LecturerT('10008895', 'Software Engineering', 'Associate'));
INSERT INTO Lecturer 
VALUES (LecturerT('10000255', 'Business Information', 'Senior'));

INSERT INTO SeniorLecturer VALUES(SeniorLecturerT('10000255', 2, 5, 7));
INSERT INTO SeniorLecturer VALUES(SeniorLecturerT('10000258', NULL, 1, 5));

INSERT INTO AssociateLecturer VALUES (AssociateLecturerT('10008895', 2, 1999));
INSERT INTO AssociateLecturer VALUES (AssociateLecturerT('10006935', NULL, 2001));

INSERT INTO Tutor VALUES (TutorT('01234234', 10, 20.00));
INSERT INTO Tutor VALUES (TutorT('01958652', 30, 35.00));

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



