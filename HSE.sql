CREATE SCHEMA IF NOT EXISTS hse;
USE hse;

#########
# SETUP #
#########

DROP TABLE IF EXISTS person;

CREATE TABLE IF NOT EXISTS person (
  PPS VARCHAR(9) NOT NULL,
  fName VARCHAR(45) NOT NULL,
  lName VARCHAR(45) NOT NULL,
  gender ENUM('M', 'F') NOT NULL,
  street VARCHAR(45) NOT NULL,
  town VARCHAR(20) NOT NULL,
  county VARCHAR(12) NOT NULL,
  dateOfBirth DATE NOT NULL,
  telNo VARCHAR(14) NOT NULL,
  nextOfKin VARCHAR(9) NULL,
  PRIMARY KEY (PPS),
  CONSTRAINT FK_PERSON_PERSON
    FOREIGN KEY (nextOfKin)
    REFERENCES person (PPS)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS role;

CREATE TABLE IF NOT EXISTS role (
  rCode VARCHAR(2) NOT NULL,
  rName VARCHAR(30) NOT NULL,
  PRIMARY KEY (rCode)
);

DROP TABLE IF EXISTS service_type;

CREATE TABLE IF NOT EXISTS service_type (
  sCode VARCHAR(2) NOT NULL,
  sType VARCHAR(40) NOT NULL,
  PRIMARY KEY (sCode)
);

DROP TABLE IF EXISTS service;

CREATE TABLE IF NOT EXISTS service (
  serviceId INT NOT NULL AUTO_INCREMENT,
  sName VARCHAR(30) NOT NULL,
  sStreet VARCHAR(45) NOT NULL,
  sTown VARCHAR(20) NOT NULL,
  sCounty VARCHAR(12) NOT NULL,
  sTelNo VARCHAR(45) NOT NULL,
  sCode VARCHAR(2) NOT NULL,
  PRIMARY KEY (serviceId),
  CONSTRAINT FK_SERVICE_SERVICE_TYPE
    FOREIGN KEY (sCode)
    REFERENCES service_type (sCode)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS medical_staff;

CREATE TABLE IF NOT EXISTS medical_staff (
  PPS VARCHAR(9) NOT NULL,
  rCode VARCHAR(2) NOT NULL,
  worksAt INT NOT NULL,
  PRIMARY KEY (PPS),
  CONSTRAINT FK_MEDICAL_STAFF_PERSON
    FOREIGN KEY (PPS)
    REFERENCES person (PPS)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT FK_MEDICAL_STAFF_ROLE
    FOREIGN KEY (rCode)
    REFERENCES role (rCode)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT FK_MEDICAL_STAFF_SERVICE
    FOREIGN KEY (worksAt)
    REFERENCES service (serviceId)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS feedback;

CREATE TABLE IF NOT EXISTS feedback (
  feedbackId INT NOT NULL AUTO_INCREMENT,
  givenBy VARCHAR(9) NOT NULL,
  feedback VARCHAR(140) NOT NULL,
  PRIMARY KEY (feedbackId),
  CONSTRAINT FK_FEEDBACK_PERSON
    FOREIGN KEY (givenBy)
    REFERENCES person (PPS)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS blood_type;

CREATE TABLE IF NOT EXISTS blood_type (
  bloodType VARCHAR(3) NOT NULL,
  PRIMARY KEY (bloodType)
);

DROP TABLE IF EXISTS patient;

CREATE TABLE IF NOT EXISTS patient (
  PPS VARCHAR(9) NOT NULL,
  bloodType VARCHAR(3) NOT NULL,
  currentlyAdmitted BOOLEAN NOT NULL,
  PRIMARY KEY (PPS),
  CONSTRAINT FK_PATIENT_PERSON
    FOREIGN KEY (PPS)
    REFERENCES person (PPS)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_PATIENT_BLOOD_TYPE
    FOREIGN KEY (bloodType)
    REFERENCES blood_type (bloodType)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

DROP TABLE IF EXISTS record_type;

CREATE TABLE IF NOT EXISTS record_type (
  recCode VARCHAR(2) NOT NULL,
  recType VARCHAR(20) NOT NULL,
  PRIMARY KEY (recCode)
);

DROP TABLE IF EXISTS medical_record;

CREATE TABLE IF NOT EXISTS medical_record (
  recordId INT NOT NULL,
  PPS VARCHAR(9) NOT NULL,
  serviceId INT NOT NULL,
  recCode VARCHAR(2) NOT NULL,
  location VARCHAR(60) NOT NULL,
  PRIMARY KEY (recordId),
  CONSTRAINT FK_MEDICAL_RECORD_PATIENT
    FOREIGN KEY (PPS)
    REFERENCES patient (PPS)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT FK_MEDICAL_RECORD_SERVICE
    FOREIGN KEY (serviceId)
    REFERENCES service (serviceId)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT FK_MEDICAL_RECORD_RECORD_TYPE
    FOREIGN KEY (recCode)
    REFERENCES record_type (recCode)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS positive_feedback;

CREATE TABLE IF NOT EXISTS positive_feedback (
  feedbackId INT NOT NULL,
  stars INT NOT NULL,
  recommend BOOLEAN NOT NULL,
  PRIMARY KEY (feedbackId),
  CONSTRAINT FK_POSITIVE_FEEDBACK_FEEDBACK
    FOREIGN KEY (feedbackId)
    REFERENCES feedback (feedbackId)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

DROP TABLE IF EXISTS negative_feedback_reason;

CREATE TABLE IF NOT EXISTS negative_feedback_reason (
  reasonId VARCHAR(2) NOT NULL,
  reasonType VARCHAR(40) NOT NULL,
  PRIMARY KEY (reasonId)
);

DROP TABLE IF EXISTS negative_feedback;

CREATE TABLE IF NOT EXISTS negative_feedback (
  feedbackId INT NOT NULL,
  reasonId VARCHAR(2) NOT NULL,
  resolved BOOLEAN NOT NULL,
  PRIMARY KEY (feedbackId),
  CONSTRAINT FK_NEGATIVE_FEEDBACK_FEEDBACK
    FOREIGN KEY (feedbackId)
    REFERENCES feedback (feedbackId)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT FK_NEGATIVE_FEEDBACK_REASON
    FOREIGN KEY (reasonId)
    REFERENCES negative_feedback_reason (reasonId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


INSERT INTO person VALUES ('5391696BR', 'Randee', 'Northage', 'F', 'Sligo Drive', 'Ardee', 'Kildare', '2018-05-03', '143-521-9000', NULL);
INSERT INTO person VALUES ('8719148KR', 'Cesar', 'Fryett', 'M', 'Coolclogher Avenue', 'Cootehill', 'Leitrim', '2001-06-20', '235-442-1515', '5391696BR');
INSERT INTO person VALUES ('3336662QV', 'Connie', 'Cocksedge', 'M', 'Clonbur Street', 'Rathcormac', 'Galway', '2010-07-24', '104-979-7147', '5391696BR');
INSERT INTO person VALUES ('7849202WD', 'Trstram', 'Tampling', 'M', 'Moyne Road', 'Ballyjamesduff', 'Cavan', '1977-10-28', '267-141-0798', NULL);
INSERT INTO person VALUES ('3277285NS', 'Torey', 'Willers', 'M', 'Gortnaloughane Street', 'Clones', 'Longford', '1993-04-01', '603-564-2503', '8719148KR');
INSERT INTO person VALUES ('8546910OA', 'Freedman', 'Eagles', 'M', 'Cork Street', 'Ballyjamesduff', 'Roscommon', '1985-04-07', '633-544-9034', NULL);
INSERT INTO person VALUES ('9476213DL', 'Meggi', 'Emmatt', 'F', 'Gortnaloughane Street', 'Ardee', 'Kildare', '2014-12-11', '335-130-5591', '3277285NS');
INSERT INTO person VALUES ('7081003KT', 'Juliette', 'Gittis', 'F', 'Coolclogher Avenue', 'Tynagh', 'Carlow', '1992-10-15', '338-649-3993', '7849202WD');
INSERT INTO person VALUES ('1409323SK', 'Marylinda', 'Jonke', 'F', 'Gortnaloughane Street', 'Castletownroche', 'Sligo', '1979-12-27', '169-384-7065', '9476213DL');
INSERT INTO person VALUES ('7835628BH', 'Eryn', 'Yaknov', 'F', 'Clare Street', 'Ardee', 'Tipperary', '2014-03-19', '852-204-1815', NULL);
INSERT INTO person VALUES ('0723861AF', 'Giselbert', 'Jahndel', 'M', 'Clare Street', 'Castletownroche', 'Meath', '1975-03-07', '857-810-2197', '3277285NS');
INSERT INTO person VALUES ('1618638PY', 'Husain', 'Gant', 'M', 'Sligo Drive', 'Rathcormac', 'Sligo', '2018-01-25', '259-239-5973', '1409323SK');
INSERT INTO person VALUES ('6434249QJ', 'Val', 'Gammel', 'M', 'Kilcullen Street', 'Cootehill', 'Kildare', '1994-12-11', '472-496-1067', NULL);
INSERT INTO person VALUES ('1389802AZ', 'Selene', 'Rohlfs', 'F', 'Dromore Road', 'Ballyhaunis', 'Louth', '2005-06-10', '117-103-1371', '7849202WD');
INSERT INTO person VALUES ('0586878XT', 'Shandy', 'Kemmet', 'F', 'Clonbur Street', 'Clones', 'Wexford', '1999-02-22', '199-488-9405', '6434249QJ');
INSERT INTO person VALUES ('6894943DJ', 'Carlyle', 'Abrehart', 'M', 'Clonbur Street', 'Rathcormac', 'Donegal', '1970-07-20', '479-593-2967', '1409323SK');
INSERT INTO person VALUES ('8870945GO', 'Emmy', 'Coleiro', 'M', 'Carrigeen Road', 'Kilteely', 'Tipperary', '2003-10-07', '384-443-7435', '1409323SK');
INSERT INTO person VALUES ('6394315VU', 'Dorelia', 'Alonso', 'F', 'Clare Street', 'Kilfinane', 'Cork', '1975-06-16', '208-150-9253', '7081003KT');
INSERT INTO person VALUES ('6996954HC', 'Hildagard', 'McGerr', 'F', 'Garter Lane', 'Lanesboro', 'Cavan', '2011-10-08', '290-373-5636', '6394315VU');
INSERT INTO person VALUES ('1452755PC', 'Mahala', 'Arnault', 'F', 'Shanaway Road', 'Ballyboughal', 'Louth', '1974-11-10', '102-438-4946', NULL);

INSERT INTO role VALUES ('AN', 'Analyst');
INSERT INTO role VALUES ('GP', 'General Practitioner');
INSERT INTO role VALUES ('FD', 'Family Doctor');
INSERT INTO role VALUES ('PW', 'Pharmacist');
INSERT INTO role VALUES ('OD', 'Orthodontist');
INSERT INTO role VALUES ('NU', 'Nurse');
INSERT INTO role VALUES ('TH', 'Therapist');
INSERT INTO role VALUES ('LS', 'Laboratory Specialist');
INSERT INTO role VALUES ('DS', 'Dentist');

INSERT INTO service_type VALUES ('PH', 'Pharmacy');
INSERT INTO service_type VALUES ('MH', 'Mental Health');
INSERT INTO service_type VALUES ('GP', 'General Practitioner or Family Doctor');
INSERT INTO service_type VALUES ('DE', 'Dental');
INSERT INTO service_type VALUES ('HC', 'Health Centre');
INSERT INTO service_type VALUES ('PC', 'Primary Care');
INSERT INTO service_type VALUES ('IU', 'Injury Unit');
INSERT INTO service_type VALUES ('CS', 'Carers Support');
INSERT INTO service_type VALUES ('AH', 'Acute Hospitals');
INSERT INTO service_type VALUES ('MC', 'Maternity Care');

INSERT INTO service VALUES (1, 'Mariska\'s Service', 'Cork Street', 'Kilteely', 'Meath', '178-747-5779', 'PH');
INSERT INTO service VALUES (2, 'Hildy\'s Service', 'Carrigeen Road', 'Cootehill', 'Wicklow', '218-731-9176', 'MH');
INSERT INTO service VALUES (3, 'Winny\'s Service', 'Rathnew Lane', 'Cootehill', 'Donegal', '977-114-5744', 'PC');
INSERT INTO service VALUES (4, 'Neddy\'s Service', 'Garter Lane', 'Mallow', 'Kilkenny', '196-402-3362', 'GP');
INSERT INTO service VALUES (5, 'Gertrude\'s Service', 'Kilmaley Lane', 'Carrigaline', 'Carlow', '708-429-9135', 'HC');
INSERT INTO service VALUES (6, 'Gertrude\'s Service', 'Carrigeen Road', 'Carrigaline', 'Westmeath', '931-566-9638', 'MC');
INSERT INTO service VALUES (7, 'Hildy\'s Service', 'Clare Street', 'Clones', 'Roscommon', '628-194-1514', 'PH');
INSERT INTO service VALUES (8, 'Lyda\'s Service', 'Inniscrone Avenue', 'Ballyhaunis', 'Carlow', '191-507-9464', 'MH');
INSERT INTO service VALUES (9, 'Rudd\'s Service', 'Shanaway Road', 'Ardee', 'Mayo', '268-128-2999', 'MC');
INSERT INTO service VALUES (10, 'Lyda\'s Service', 'Sligo Drive', 'Ballymote', 'Carlow', '618-802-0661', 'PH');

INSERT INTO medical_staff VALUES ('5391696BR', 'TH', 6);
INSERT INTO medical_staff VALUES ('8719148KR', 'GP', 9);
INSERT INTO medical_staff VALUES ('3336662QV', 'OD', 7);
INSERT INTO medical_staff VALUES ('7849202WD', 'FD', 7);
INSERT INTO medical_staff VALUES ('3277285NS', 'LS', 8);

INSERT INTO feedback VALUES (1, '7081003KT', 'Fantastic, would go again.');
INSERT INTO feedback VALUES (2, '9476213DL', 'Always a pleasure.');
INSERT INTO feedback VALUES (3, '1618638PY', 'I like the bread there.');
INSERT INTO feedback VALUES (4, '7835628BH', 'The nurses were nice.');
INSERT INTO feedback VALUES (5, '5391696BR', 'Life changing experience, I love hospitals.');
INSERT INTO feedback VALUES (6, '1452755PC', 'Absolute eejits.');
INSERT INTO feedback VALUES (7, '6434249QJ', 'My doctor was a real dope, the head on \'im...');
INSERT INTO feedback VALUES (8, '8546910OA', 'I don\t like hospitals.');
INSERT INTO feedback VALUES (9, '7081003KT', 'Please do not go here, horrible service.');
INSERT INTO feedback VALUES (10, '7849202WD', 'The sandwiches were dry.');

INSERT INTO blood_type VALUES ('O-');
INSERT INTO blood_type VALUES ('O+');
INSERT INTO blood_type VALUES ('A-');
INSERT INTO blood_type VALUES ('A+');
INSERT INTO blood_type VALUES ('B-');
INSERT INTO blood_type VALUES ('B+');
INSERT INTO blood_type VALUES ('AB-');
INSERT INTO blood_type VALUES ('AB+');

INSERT INTO patient VALUES ('5391696BR', 'O+', true);
INSERT INTO patient VALUES ('8719148KR', 'B-', true);
INSERT INTO patient VALUES ('3336662QV', 'A+', true);
INSERT INTO patient VALUES ('7849202WD', 'O-', true);
INSERT INTO patient VALUES ('3277285NS', 'A-', false);
INSERT INTO patient VALUES ('8546910OA', 'AB+', false);
INSERT INTO patient VALUES ('9476213DL', 'B-', false);
INSERT INTO patient VALUES ('7081003KT', 'AB-', true);
INSERT INTO patient VALUES ('1409323SK', 'A-', true);
INSERT INTO patient VALUES ('7835628BH', 'O+', true);
INSERT INTO patient VALUES ('0723861AF', 'AB-', true);
INSERT INTO patient VALUES ('1618638PY', 'O+', true);
INSERT INTO patient VALUES ('6434249QJ', 'O-', false);
INSERT INTO patient VALUES ('1389802AZ', 'O+', true);
INSERT INTO patient VALUES ('0586878XT', 'O-', true);
INSERT INTO patient VALUES ('6894943DJ', 'AB+', true);
INSERT INTO patient VALUES ('8870945GO', 'A-', true);
INSERT INTO patient VALUES ('6394315VU', 'AB+', true);
INSERT INTO patient VALUES ('6996954HC', 'O+', false);
INSERT INTO patient VALUES ('1452755PC', 'AB-', true);

INSERT INTO record_type VALUES ('PI', 'Personal Information');
INSERT INTO record_type VALUES ('LR', 'Laboratory Result');
INSERT INTO record_type VALUES ('IR', 'Imaging Result');
INSERT INTO record_type VALUES ('TP', 'Treatment Plan');
INSERT INTO record_type VALUES ('PN', 'Progress Notes');
INSERT INTO record_type VALUES ('DS', 'Discharge Sum.');
INSERT INTO record_type VALUES ('II', 'Insurance Info');
INSERT INTO record_type VALUES ('VS', 'Vital Signs');
INSERT INTO record_type VALUES ('SR', 'Surgery Record');

INSERT INTO medical_record VALUES (1, '6894943DJ', 7, 'IR', 'http://dummyimage.com/144x363.png/5fa2dd/ffffff');
INSERT INTO medical_record VALUES (2, '1389802AZ', 5, 'LR', 'http://dummyimage.com/211x406.png/5fa2dd/ffffff');
INSERT INTO medical_record VALUES (3, '7835628BH', 5, 'VS', 'http://dummyimage.com/215x394.png/ff4444/ffffff');
INSERT INTO medical_record VALUES (4, '7835628BH', 7, 'TP', 'http://dummyimage.com/235x380.png/cc0000/ffffff');
INSERT INTO medical_record VALUES (5, '6394315VU', 8, 'II', 'http://dummyimage.com/134x401.png/5fa2dd/ffffff');
INSERT INTO medical_record VALUES (6, '8546910OA', 10, 'II', 'http://dummyimage.com/101x327.png/dddddd/000000');
INSERT INTO medical_record VALUES (7, '9476213DL', 9, 'II', 'http://dummyimage.com/138x338.png/dddddd/000000');
INSERT INTO medical_record VALUES (8, '3277285NS', 6, 'II', 'http://dummyimage.com/250x399.png/dddddd/000000');
INSERT INTO medical_record VALUES (9, '8719148KR', 3, 'LR', 'http://dummyimage.com/215x280.png/ff4444/ffffff');
INSERT INTO medical_record VALUES (10, '8870945GO', 9, 'VS', 'http://dummyimage.com/155x271.png/5fa2dd/ffffff');
INSERT INTO medical_record VALUES (11, '7081003KT', 8, 'DS', 'http://dummyimage.com/165x434.png/dddddd/000000');
INSERT INTO medical_record VALUES (12, '7849202WD', 1, 'IR', 'http://dummyimage.com/249x374.png/5fa2dd/ffffff');
INSERT INTO medical_record VALUES (13, '5391696BR', 1, 'SR', 'http://dummyimage.com/183x419.png/cc0000/ffffff');
INSERT INTO medical_record VALUES (14, '8719148KR', 4, 'DS', 'http://dummyimage.com/117x371.png/dddddd/000000');
INSERT INTO medical_record VALUES (15, '1452755PC', 6, 'LR', 'http://dummyimage.com/227x276.png/ff4444/ffffff');
INSERT INTO medical_record VALUES (16, '0723861AF', 6, 'PN', 'http://dummyimage.com/228x305.png/cc0000/ffffff');
INSERT INTO medical_record VALUES (17, '5391696BR', 4, 'LR', 'http://dummyimage.com/215x298.png/dddddd/000000');
INSERT INTO medical_record VALUES (18, '7081003KT', 2, 'TP', 'http://dummyimage.com/215x263.png/dddddd/000000');
INSERT INTO medical_record VALUES (19, '7081003KT', 10, 'DS', 'http://dummyimage.com/125x438.png/ff4444/ffffff');
INSERT INTO medical_record VALUES (20, '8719148KR', 2, 'II', 'http://dummyimage.com/198x461.png/dddddd/000000');

INSERT INTO positive_feedback VALUES (1, 1, false);
INSERT INTO positive_feedback VALUES (2, 5, true);
INSERT INTO positive_feedback VALUES (3, 1, false);
INSERT INTO positive_feedback VALUES (4, 5, false);
INSERT INTO positive_feedback VALUES (5, 4, false);

INSERT INTO negative_feedback_reason VALUES ('LW', 'Long wait times');
INSERT INTO negative_feedback_reason VALUES ('PC', 'Poor communication');
INSERT INTO negative_feedback_reason VALUES ('UP', 'Uncomfortable conditions');
INSERT INTO negative_feedback_reason VALUES ('LE', 'Lack of empathy from staff');
INSERT INTO negative_feedback_reason VALUES ('IM', 'Issues with medical treatments');
INSERT INTO negative_feedback_reason VALUES ('IB', 'Insurance and billing problems');
INSERT INTO negative_feedback_reason VALUES ('PR', 'Poor record keeping');
INSERT INTO negative_feedback_reason VALUES ('IR', 'Insufficient resources');
INSERT INTO negative_feedback_reason VALUES ('IF', 'Inadequate follow-up care.');

INSERT INTO negative_feedback VALUES (6, 'IR', true);
INSERT INTO negative_feedback VALUES (7, 'PC', true);
INSERT INTO negative_feedback VALUES (8, 'IR', true);
INSERT INTO negative_feedback VALUES (9, 'IR', true);
INSERT INTO negative_feedback VALUES (10, 'LE', true);

#########
# VIEWS #
#########

#	Count how many people are currently admitted.
DROP VIEW IF EXISTS Number_Of_Admitted;
CREATE VIEW Number_Of_Admitted AS SELECT COUNT(PPS) as "Number of people currently admitted" FROM patient WHERE currentlyAdmitted="1";

#	Get the highest and lowest feedback rating given, along with the average.
DROP VIEW IF EXISTS Feedback_Stats;
CREATE OR REPLACE VIEW Feedback_Stats AS SELECT MAX(stars) as "Highest rating given", AVG(stars) as "Average rating", MIN(stars) as "Lowest rating given" FROM positive_feedback;

#	List the first and last names of all the people who are next of kin.
DROP VIEW IF EXISTS Next_Of_Kin ;
CREATE OR REPLACE VIEW Next_Of_Kin AS SELECT concat(fName, " ", lName) as Name FROM person WHERE PPS IN ( SELECT DISTINCT nextOfKin FROM person WHERE nextOfKin IS NOT NULL );

#########
# USERS #
#########

DROP USER IF EXISTS Trainee;
CREATE USER 'Trainee';
GRANT SELECT ON Number_Of_Admitted TO 'Trainee';
GRANT SELECT ON Feedback_Stats TO 'Trainee';

DROP USER IF EXISTS Desk_Staff;
CREATE USER 'Desk_Staff';
GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER ON person TO 'Desk_Staff';
GRANT SELECT, TRIGGER, UPDATE ON medical_staff TO 'Desk_Staff';
GRANT SELECT ON role TO 'Desk_Staff';
GRANT TRIGGER, UPDATE, SELECT, INSERT, DELETE ON patient TO 'Desk_Staff';
GRANT SELECT ON blood_type TO 'Desk_Staff';
GRANT SELECT, UPDATE, INSERT, DELETE, TRIGGER ON Feedback_Stats TO 'Desk_Staff';
GRANT SELECT ON Number_Of_Admitted TO 'Desk_Staff';
GRANT SELECT, UPDATE, TRIGGER, INSERT, DELETE ON Next_Of_Kin TO 'Desk_Staff';

DROP USER IF EXISTS Medical_Staff;
CREATE USER 'Medical_Staff';
GRANT SELECT, UPDATE, INSERT, TRIGGER, DELETE ON medical_record TO 'Medical_Staff';
GRANT SELECT ON record_type TO 'Medical_Staff';
GRANT SELECT, UPDATE, TRIGGER ON patient TO 'Medical_Staff';
GRANT SELECT ON blood_type TO 'Medical_Staff';
GRANT SELECT ON Next_Of_Kin TO 'Medical_Staff';

DROP USER IF EXISTS Service_Manager;
CREATE USER 'Service_Manager';
GRANT GRANT OPTION, TRIGGER, UPDATE, SELECT, INSERT, DELETE ON person TO 'Service_Manager';
GRANT GRANT OPTION, DELETE, INSERT, SELECT, UPDATE, TRIGGER ON medical_staff TO 'Service_Manager';
GRANT GRANT OPTION, DELETE, INSERT, SELECT, TRIGGER, UPDATE ON role TO 'Service_Manager';
GRANT GRANT OPTION, DELETE, INSERT, SELECT, UPDATE, TRIGGER ON feedback TO 'Service_Manager';
GRANT GRANT OPTION, DELETE, INSERT, SELECT, UPDATE, TRIGGER ON medical_record TO 'Service_Manager';
GRANT GRANT OPTION, DELETE, INSERT, SELECT, UPDATE, TRIGGER ON record_type TO 'Service_Manager';
GRANT GRANT OPTION, DELETE, INSERT, SELECT, UPDATE, TRIGGER ON patient TO 'Service_Manager';
GRANT GRANT OPTION, DELETE, INSERT, SELECT, UPDATE, TRIGGER ON blood_type TO 'Service_Manager';
GRANT GRANT OPTION, DELETE, INSERT, SELECT, UPDATE, TRIGGER ON positive_feedback TO 'Service_Manager';
GRANT GRANT OPTION, DELETE, INSERT, SELECT, UPDATE, TRIGGER ON negative_feedback TO 'Service_Manager';
GRANT GRANT OPTION, DELETE, INSERT, SELECT, UPDATE, TRIGGER ON negative_feedback_reason TO 'Service_Manager';

DROP USER IF EXISTS HSE_Admin;
CREATE USER 'HSE_Admin';
GRANT SELECT ON medical_staff TO 'HSE_Admin';
GRANT SELECT ON role TO 'HSE_Admin';
GRANT DELETE, INSERT, SELECT, UPDATE, TRIGGER ON service TO 'HSE_Admin';
GRANT SELECT ON service_type TO 'HSE_Admin';

###########
# QUERIES #
###########

# 1.	List the first and last names of all the people who are next of kin.
SELECT * FROM Next_Of_Kin;

# 2.	List all the medical staff who do not work in pharmacies.
SELECT *
FROM person
WHERE PPS IN ( SELECT PPS
				FROM medical_staff
                WHERE worksAt NOT IN ( SELECT serviceId
										FROM service
                                        WHERE sCode = 'PH' ) );

# 3.	List the stars and feedback that has between 3 and 5 stars.
SELECT *
FROM Feedback_Stats;

# 4.	List the people born in May (to wish them happy birthday)
SELECT *
FROM person
WHERE dateOfBirth LIKE '%-05-%';

# 5.	List patients along with their date of birth in a nice format, sorted alphabetically using their first name
SELECT concat(fName, " ", lName) as Name, DATE_FORMAT(dateOfBirth,'%d %M %Y') as "Year of Birth"
FROM patient NATURAL JOIN person ORDER BY fName ASC;

# 6.	List all the medical records associated with a particular patient, along with their blood type.
SELECT PPS, location as Location, recType as "Record Type", bloodType as "Blood Type"
FROM medical_record NATURAL JOIN record_type NATURAL JOIN patient
WHERE PPS = '7835628BH';

# 7.	Count how many people are currently admitted.
SELECT * FROM Number_Of_Admitted;

# 8.	Get the highest and lowest feedback rating given, along with the average.
SELECT MAX(stars) as "Highest rating given", AVG(stars) as "Average rating", MIN(stars) as "Lowest rating given"
FROM positive_feedback;

# 9.	List how many medical records each person in the system has (excluding people with one or less), from highest to lowest.
SELECT PPS, COUNT(PPS) as "Number of Medical Records"
FROM medical_record GROUP BY PPS HAVING COUNT(PPS) > 1 ORDER BY COUNT(PPS) DESC;

# 10.	Update some patients to be shown as currently admitted.
UPDATE patient
SET currentlyAdmitted=1
WHERE PPS IN ("3277285NS", "6996954HC");

# 11.	Add new medical staff (you need to change sql workbench settings for this to work).
START TRANSACTION;
INSERT INTO medical_staff VALUES ('8870945GO', 'AN', 2);
INSERT INTO medical_staff VALUES ('6996954HC', 'DS', 5);
INSERT INTO medical_staff VALUES ('0586878XT', 'FD', 3);
COMMIT;
# ROLLBACK;