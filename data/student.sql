
SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET default_with_oids = false;

CREATE TABLE course
(
    cid character varying(9) NOT NULL,
    cname character varying(35) NOT NULL,
    hours integer NOT NULL CONSTRAINT HOURS_CHK CHECK ((hours > 0) AND (hours <= 5)),
    prereq character varying(9),
    CONSTRAINT COURSE_PK PRIMARY KEY(cid),
    CONSTRAINT COURSE_FK1 FOREIGN KEY (prereq) REFERENCES COURSE(cid) ON DELETE SET NULL
);

CREATE  TABLE degree 
(
  dcode character(4) NOT NULL,
  dname character varying(45) NOT NULL,
  hours integer NOT NULL,
  CONSTRAINT DEGREE_PK PRIMARY KEY(dcode)
);

CREATE TABLE section
(
    secid integer NOT NULL,
    cid character varying(9) NOT NULL,
    year integer NOT NULL,
    term character varying(7) NOT NULL,
    days character varying(7) NOT NULL,
    stime timestamp NOT NULL,
    etime timestamp NOT NULL,
    CONSTRAINT SECTION_PK PRIMARY KEY(secid),
    CONSTRAINT SECTION_FK1 FOREIGN KEY (cid) REFERENCES COURSE(cid) ON DELETE SET NULL, -- is this what you want?
    CONSTRAINT ETIME_CHK CHECK (stime < etime)
);

CREATE TABLE student
(
    sid integer NOT NULL,
    fname character varying(15) NOT NULL,
    lname character varying(15) NOT NULL,
    CONSTRAINT STUDENT_PK PRIMARY KEY(sid)
);

CREATE TABLE major 
(
  sid integer NOT NULL,
  dcode character(4) NOT NULL,
  grad_date date NULL,
  CONSTRAINT MAJOR_PK PRIMARY KEY(sid, dcode),
  CONSTRAINT MAJOR_FK1 FOREIGN KEY (sid) REFERENCES STUDENT(sid) ON DELETE RESTRICT,
  CONSTRAINT MAJOR_FK2 FOREIGN KEY (dcode) REFERENCES DEGREE(dcode) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE enrollment
(
    sid integer NOT NULL,
    secid integer NOT NULL DEFAULT 111,
    grade character(1) NOT NULL CONSTRAINT GRADE_CHK CHECK (grade IN ('A', 'B', 'C', 'D', 'I', 'F', 'W')),
    CONSTRAINT ENROLLMENT_PK PRIMARY KEY(sid, secid),
    CONSTRAINT ENROLLMENT_FK1 FOREIGN KEY (secid) REFERENCES SECTION(secid) ON DELETE SET DEFAULT,
    CONSTRAINT ENROLLMENT_FK2 FOREIGN KEY (sid) REFERENCES STUDENT(sid) ON DELETE CASCADE
);

CREATE TABLE org
(
    oid integer NOT NULL,
    oname character varying(30) NOT NULL,
    fee numeric(5,2),
    CONSTRAINT ORG_PK PRIMARY KEY(oid)
);

CREATE TABLE membership
(
    sid integer NOT NULL,
    oid integer  NOT NULL,
    sdate date NOT NULL,
    edate date,
    CONSTRAINT MEMBERSHIP_PK PRIMARY KEY(sid, oid, sdate),
    CONSTRAINT MEMBERSHIP_FK1 FOREIGN KEY (sid) REFERENCES STUDENT(sid) ON DELETE CASCADE,
    CONSTRAINT MEMBERSHIP_FK2 FOREIGN KEY (oid) REFERENCES ORG(oid) ON DELETE CASCADE,
    CONSTRAINT EDATE_CHK CHECK (sdate < edate)
);


-- Load data into student table (sid, fname, lname)

INSERT INTO STUDENT VALUES (1, 'William', 'Campbell');
INSERT INTO STUDENT VALUES (2, 'Robert', 'Hill');   
INSERT INTO STUDENT VALUES (3, 'Joseph', 'Green'); 
INSERT INTO STUDENT VALUES (4, 'Jeff', 'Wilson');
INSERT INTO STUDENT VALUES (5, 'Patricia', 'Davis');
INSERT INTO STUDENT VALUES (6, 'Susan', 'Brown');
INSERT INTO STUDENT VALUES (7, 'Thomas', 'Smith');
INSERT INTO STUDENT VALUES (8, 'Mark', 'Williams');
INSERT INTO STUDENT VALUES (9, 'Paul', 'Jones');
INSERT INTO STUDENT VALUES (10, 'Barbara', 'Robinson');
INSERT INTO STUDENT VALUES (11, 'Jennifer', 'King');
INSERT INTO STUDENT VALUES (12, 'Sarah', 'Parker');
INSERT INTO STUDENT VALUES (13, 'Lisa', 'Lopez');
INSERT INTO STUDENT VALUES (14, 'Sharon', 'Jackson');
INSERT INTO STUDENT VALUES (15, 'Kevin', 'Miller');

-- Load data into degree table (dcode, dname, hours)

INSERT INTO DEGREE VALUES ('BSCS', 'Bachelor of Science in Computer Science', 128);
INSERT INTO DEGREE VALUES ('BSCE', 'Bachelor of Science in Civil Engineering', 134);
INSERT INTO DEGREE VALUES ('BSEE', 'Bachelor of Science in Electrical Engineering', 130);
INSERT INTO DEGREE VALUES ('BSMA', 'Bachelor of Science in Mathematics', 129);
INSERT INTO DEGREE VALUES ('BSPY', 'Bachelor of Science in Physics', 136);
INSERT INTO DEGREE VALUES ('MSCS', 'Master of Science in Computer Science', 36);
INSERT INTO DEGREE VALUES ('MSSE', 'Master of Science in Software Engineering', 33);
INSERT INTO DEGREE VALUES ('MSDS', 'Master of Science in Data Science', 30);
INSERT INTO DEGREE VALUES ('MD', 'Doctor of Medicine', 96);


-- Load data into major table (sid, dcode, grad_date)

INSERT INTO MAJOR VALUES (1, 'BSCS', '2009-12-31');  
INSERT INTO MAJOR VALUES (3, 'BSPY', '2008-12-15');  
INSERT INTO MAJOR VALUES (5, 'BSMA', '2009-07-15');  
INSERT INTO MAJOR VALUES (8, 'BSCS', '2011-05-15'); 
INSERT INTO MAJOR VALUES (11, 'MSDS', '2012-12-15'); 
INSERT INTO MAJOR VALUES (12, 'MSCS', '2011-08-20');
INSERT INTO MAJOR VALUES (13, 'MSSE', '2013-05-15');
INSERT INTO MAJOR VALUES (14, 'BSCE', '2015-07-15');
INSERT INTO MAJOR VALUES (5, 'BSCS',  '2010-08-15'); 
INSERT INTO MAJOR VALUES (1, 'BSEE',  '2010-05-15'); 


-- Load data into course table (cid, cname, hours, prereq)

INSERT INTO COURSE VALUES ('Math-130',  'College Algebra', 3.0, null);
INSERT INTO COURSE VALUES ('Math-229',  'Calculus I',   5.0, 'Math-130');
INSERT INTO COURSE VALUES ('Math-220',  'Discrete Structures', 3.0, 'Math-229'); 
INSERT INTO COURSE VALUES ('Math-329',  'Linear Algebra', 3.0, 'Math-229');
INSERT INTO COURSE VALUES ('CS-110',   'Computer Science I', 3.0, 'Math-130');   
INSERT INTO COURSE VALUES ('CS-120',   'Computer Science II', 3.0, 'CS-110');
INSERT INTO COURSE VALUES ('CS-210',   'Data Structures',  3.0, 'Math-220');
INSERT INTO COURSE VALUES ('CS-300',   'Programming Languages', 3.0,  'CS-210');  
INSERT INTO COURSE VALUES ('CS-305',  'Software Engineering I', 3.0, 'Math-220');
INSERT INTO COURSE VALUES ('CS-350',   'Database Engineering', 3.0, 'Math-229'); 
INSERT INTO COURSE VALUES ('CS-440',  'Image Processing', 3.0, 'Math-329');
INSERT INTO COURSE VALUES ('GenEd-110',  'Basket Weaving', 3.0, null);



-- Load data into section table (secid, cid, year, term, days, stime, etime)

INSERT INTO SECTION VALUES (1, 'CS-300', 2009, 'Spring', 'TuTh', '2011-08-22 11:00:00', '2011-08-22 12:15:00');
INSERT INTO SECTION VALUES (2, 'CS-300', 2010, 'Spring', 'TuTh', '2011-08-22 11:00:00', '2011-08-22 12:15:00');
INSERT INTO SECTION VALUES (3, 'CS-305', 2008, 'Fall', 'MWF', '2011-08-22 11:00:00', '2011-08-22 11:50:00');
INSERT INTO SECTION VALUES (4, 'CS-305', 2009, 'Fall', 'MW', '2011-08-22 11:00:00','2011-08-22 12:15:00');
INSERT INTO SECTION VALUES (5, 'Math-130', 2008, 'Fall', 'MW', '2011-08-22 13:00:00', '2011-08-22 13:50:00'); 
INSERT INTO SECTION VALUES (6, 'CS-350', 2009, 'Spring', 'TuTh', '2011-08-22 15:30:00', '2011-08-22 16:45:00'); 
INSERT INTO SECTION VALUES (7, 'Math-229', 2009, 'Spring', 'MTuWThF', '2011-08-22 09:00:00', '2011-08-22 09:50:00'); 
INSERT INTO SECTION VALUES (8, 'CS-440', 2008, 'Fall', 'TuTh', '2011-08-22 14:00:00', '2011-08-22 15:15:00');
INSERT INTO SECTION VALUES (9, 'Math-329', 2010, 'Spring', 'MWF', '2011-08-22 09:00:00', '2011-08-22 10:15:00'); 
INSERT INTO SECTION VALUES (10, 'CS-110', 2010, 'Spring', 'MWF', '2011-08-22 09:00:00', '2011-08-22 10:15:00');
INSERT INTO SECTION VALUES (111, 'GenEd-110', 2010, 'Spring', 'MWF', '2011-08-22 09:00:00', '2011-08-22 10:15:00');


-- Load data into enrollment table (sid, secid, grade)

INSERT INTO ENROLLMENT VALUES (1, 1, 'C');
INSERT INTO ENROLLMENT VALUES (5, 6, 'B');
INSERT INTO ENROLLMENT VALUES (2, 1, 'B');
INSERT INTO ENROLLMENT VALUES (5, 5, 'A');
INSERT INTO ENROLLMENT VALUES (6, 10, 'F');
INSERT INTO ENROLLMENT VALUES (8, 6, 'A');
INSERT INTO ENROLLMENT VALUES (7, 4, 'B');
INSERT INTO ENROLLMENT VALUES (8, 5, 'A');
INSERT INTO ENROLLMENT VALUES (9, 9, 'D');
INSERT INTO ENROLLMENT VALUES (15, 10, 'C');


-- Load data into org table (oid, oname, fee)

INSERT INTO ORG VALUES (1, 'IEEE Computer Society', 45.0);
INSERT INTO ORG VALUES (2, 'Computer Society of India', 25.0);
INSERT INTO ORG VALUES (3, 'ACM', 55.0);


-- Load data into membership table (sid, oid, sdate, edate)

INSERT INTO MEMBERSHIP VALUES (1, 1, '2006-01-01', null);
INSERT INTO MEMBERSHIP VALUES (2, 1, '2007-05-01', null);
INSERT INTO MEMBERSHIP VALUES (1, 2, '2009-02-08', null);
INSERT INTO MEMBERSHIP VALUES (5, 1, '2008-09-08', null);
INSERT INTO MEMBERSHIP VALUES (1, 3, '2009-05-06', null);
INSERT INTO MEMBERSHIP VALUES (5, 2, '2009-06-02', null);
INSERT INTO MEMBERSHIP VALUES (6, 1, '2006-12-05', '2009-09-10');
INSERT INTO MEMBERSHIP VALUES (8, 2, '2008-08-15', '2009-08-14');
INSERT INTO MEMBERSHIP VALUES (15, 3, '2005-06-03', '2010-01-05');
INSERT INTO MEMBERSHIP VALUES (5, 3, '2007-11-30', null);


