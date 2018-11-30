INSERT INTO Campus VALUES (CampusT('Albury/Wodonga', 'Parkers Road Wodonga VIC 3690', '61260583700', '620260583777', 'John Hill'));
INSERT INTO Campus VALUES (CampusT('City', '215 Franklin St. Melb VIC 3000', '61392855100', '610392855111', 'Michael A. O''leary'));
INSERT INTO Campus VALUES (CampusT('Mildura', 'Benetook Ave. Mildura VIC 3502', '61350223757', '61350223646', 'Ron Broadhead'));

INSERT INTO Faculty VALUES (1, 'Health Science', 'S. Duckett', );
INSERT INTO Faculty VALUES (2, 'Humanity & Social Sc.', 'J. A. Salmond', );
INSERT INTO Faculty VALUES (3, 'Law & Management', 'G. C. O''Brien', );
INSERT INTO Faculty VALUES (4, 'Science, Tech. & Eng.', 'D. Finlay', );
INSERT INTO Faculty VALUES (5, 'Regional Department', 'L. Kilmartin', );

INSERT INTO Building VALUES (BuildingT('BB1', 'Beth Gleeson', 'D5', 4, 'Bundoora', 4));
INSERT INTO Building VALUES (BuildingT('BB2', 'Martin Building', 'F5', 4, 'Bundoora', 3));
INSERT INTO Building VALUES (BuildingT('BB3', 'Thomas Cherry', 'D4', 4, 'Bundoora', 1));
INSERT INTO Building VALUES (BuildingT('BB4', 'Physical Science 1', 'D5', 3, 'Bundoora', 4));

INSERT INTO Office VALUES (OfficeT('BB4', 'BG207', '94791118'));
INSERT INTO Office VALUES (OfficeT('BB4', 'BG208', '94792393'));

INSERT INTO Classroom VALUES (ClassroomT('BB3', 'TCLT', 50));
INSERT INTO Classroom VALUES (ClassroomT('BB3', 'TC01', 30));

INSERT INTO Lab VALUES (LabT('BB1', 'BG113', 25, LabEquipmentT('25 PC', '1 Printer')));
INSERT INTO Lab VALUES (LabT('BB1', 'BG114', 20, LabEquipmentT('21 PC')));

INSERT INTO DegreeTbl VALUES (DegreeT('D100', 'Bachelor of Comp. Sci', 3, 'Year 12 or equivalent', 4));
INSERT INTO DegreeTbl VALUES (DegreeT('D101', 'Master of Comp. Sci', 2, 'Bachelor of Comp. Sci', 4));

INSERT INTO Person VALUES (PersonT(01234234, 'Grant' 'Felix', 'Mr', '2 Boadle Rd Bundoora VIC', '0398548753', '3083', 'Bundoora'));
INSERT INTO Person VALUES (PersonT(10008895, 'Xin' 'Harry', 'Mr', '6 Kelley St Kew VIC', '0398875542', '3088', 'Bundoora'));
INSERT INTO Person VALUES (PersonT(10002935, 'Jones' 'Felicity', 'Ms', '14 Rennie St Thornbury VIC', '0398722001', '3071', 'Bundoora'));

INSERT INTO Staff VALUES (StaffT(10008895, 'BB1', 'BG212', 'Lecturer'));
INSERT INTO Staff VALUES (StaffT(10002935, 'BB4', 'BG210', 'Admin'));

INSERT INTO Student VALUES (StudentT(01234234, 2000));
INSERT INTO Student VALUES (StudentT(01958652, 2000));

INSERT INTO AdminTbl VALUES (AdminT(10002935, 'Office Manager', ComputerskillsT(NULL), OfficeskillsT('Managerial')));
INSERT INTO AdminTbl VALUES (AdminT(10008957, 'Receptionist', ComputerskillsT('MS Office'), OfficeskillsT('Customer Service', 'Phone')));

INSERT INTO Technician VALUES (TechnicianT(10005825, 'Network Officer', TechnicianskillsT('UNIX', 'NT')));
INSERT INTO Technician VALUES (TechnicianT(10015826, 'Photocopy Technician', TechnicianskillsT('Electrician')));

INSERT INTO Lecturer VALUES (LecturerT(10008895, 'Software Engineering', 'Associate'));
INSERT INTO Lecturer VALUES (LecturerT(10000255, 'Business Information', 'Senior'));

INSERT INTO SeniorLecturer VALUES(SeniorLecturerT(10000255, 2, 5, 7));
INSERT INTO SeniorLecturer VALUES(SeniorLecturerT(10000258, NULL, 1, 5));

INSERT INTO AssociateLecturer VALUES (AssociateLecturerT(10008895, 2, 1999));
INSERT INTO AssociateLecturer VALUES (AssociateLecturerT(10006935, NULL, 2001));

INSERT INTO Tutor VALUES (TutorT('01234234', 10, 20.00));
INSERT INTO Tutor VALUES (TutorT('01958652', 30, 35.00));

INSERT INTO Subject VALUES (SubjectT('CSE21NET', 'Networking', 10, 'CSE11IS', 10008895));
INSERT INTO Subject VALUES (SubjectT('CSE42ADB', 'Advanced Database', 15, 'CSE21DB', 10006935));

INSERT INTO Enrolls_in VALUES ('01234234', 'D101');
INSERT INTO Enrolls_in VALUES ('10012568', 'D101');

INSERT INTO Takes VALUES ('01234234', 'CSE42ADB', 70);
INSERT INTO Takes VALUES ('10012568', 'CSE42ADB', 80);



