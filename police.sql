-- DROP DATABASE IF EXISTS police;
-- CREATE DATABASE police;
-- USE police;

-- ========================================================
-- 1. Department Table
-- ========================================================
CREATE TABLE Department (  
    Dept_ID INT PRIMARY KEY AUTO_INCREMENT,  
    DepartmentType VARCHAR(100) UNIQUE NOT NULL,  
    DepartmentHead VARCHAR(100) UNIQUE NOT NULL,  
    PhoneNumber CHAR(10) UNIQUE NOT NULL,  
    Email VARCHAR(100) NOT NULL UNIQUE CHECK (Email LIKE '%@%'),  
    EstablishedDate DATE  
);

-- ========================================================
-- 2. Police Table (Before Station)
-- ========================================================
CREATE TABLE Police(  
    PoliceID INT PRIMARY KEY AUTO_INCREMENT,  
    PoliceName VARCHAR(100) NOT NULL,  
    Ranking VARCHAR(100),  
    Email VARCHAR(100) NOT NULL UNIQUE CHECK (Email LIKE '%@%'),  
    PhoneNumber CHAR(10),  
    Date_of_Birth DATE,  
    Age INT NOT NULL CHECK(Age >= 18 AND Age <= 55),  
    Dept_ID INT,
    Salary DECIMAL(10,2),
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ========================================================
-- 3. Station Table
-- ========================================================
CREATE TABLE Station (
    Station_ID INT PRIMARY KEY AUTO_INCREMENT,
    StationName VARCHAR(100) UNIQUE NOT NULL,
    Location VARCHAR(150),
    ContactNumber CHAR(10) UNIQUE,
    InChargeOfficer_ID INT,
    Dept_ID INT,
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (InChargeOfficer_ID) REFERENCES Police(PoliceID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ========================================================
-- 4. CaseTable
-- ========================================================
CREATE TABLE CaseTable (
    CaseID INT PRIMARY KEY AUTO_INCREMENT,
    CaseType VARCHAR(100),
    DateReported DATE,
    Description_Of_Case TEXT,
    ProgressPercentage DECIMAL(5,2) DEFAULT 0.00 CHECK (ProgressPercentage BETWEEN 0 AND 100),
    Verdict VARCHAR(100),
    Stage VARCHAR(50),
    AssignedOfficer_ID INT,
    FOREIGN KEY (AssignedOfficer_ID) REFERENCES Police(PoliceID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ========================================================
-- 5. Criminal Table
-- ========================================================
CREATE TABLE Criminal(  
    Criminal_ID INT PRIMARY KEY AUTO_INCREMENT,  
    Name_ VARCHAR(100) NOT NULL,  
    Address VARCHAR(100),  
    DateofBirth DATE,  
    Gender CHAR(1),  
    CriminalRecord TEXT,  
    CaseID INT,  
    Age INT,
    TrialDuration VARCHAR(50),
    FOREIGN KEY (CaseID) REFERENCES CaseTable(CaseID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ========================================================
-- 6. Evidence Table
-- ========================================================
CREATE TABLE Evidence (
    EvidenceID INT PRIMARY KEY AUTO_INCREMENT,
    CaseID INT NOT NULL,
    CollectedBy INT,
    EvidenceType VARCHAR(100),
    Description TEXT,
    DateCollected DATE NOT NULL,
    StorageLocation VARCHAR(100),
    ImageFile VARCHAR(255),
    FOREIGN KEY (CaseID) REFERENCES CaseTable(CaseID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (CollectedBy) REFERENCES Police(PoliceID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ========================================================
-- 7. CourtProceedings Table
-- ========================================================
CREATE TABLE CourtProceedings (  
    ProceedingID INT PRIMARY KEY AUTO_INCREMENT,  
    CaseID INT NOT NULL,  
    ProceedingDate DATE NOT NULL,  
    CourtName VARCHAR(100) NOT NULL,  
    JudgeName VARCHAR(100) NOT NULL,  
    ProceedingType VARCHAR(100),  
    PoliceID INT,  
    Remarks TEXT,  
    FOREIGN KEY (CaseID) REFERENCES CaseTable(CaseID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (PoliceID) REFERENCES Police(PoliceID) ON DELETE SET NULL ON UPDATE CASCADE
);

-- ========================================================
-- 8. DepartmentLog Table
-- ========================================================
CREATE TABLE DepartmentLog (
  LogID INT AUTO_INCREMENT PRIMARY KEY,
  Dept_ID INT,
  ActionType VARCHAR(20),
  ActionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================================================
-- INSERT DATA
-- ========================================================

INSERT INTO Department (Dept_ID, DepartmentType, DepartmentHead, PhoneNumber, Email, EstablishedDate) VALUES
(1,'Cyber Crime','Ravi Verma','9876543210','ravi.verma@police.gov','2005-06-15'),
(2,'Homicide','Anita Desai','8765432109','anita.desai@police.gov','1998-03-22'),
(3,'Narcotics','Suresh Iyer','7654321098','suresh.iyer@police.gov','2001-11-05'),
(4,'Traffic Control','Meena Joshi','6543210987','meena.joshi@police.gov','2010-09-10'),
(5,'Forensics','Rajesh Khanna','5432109876','rajesh.khanna@police.gov','2003-01-18'),
(6,'Anti -Terrorism','Neha Kapoor','4321098765','neha.kapoor@police.gov','2007-07-30'),
(7,'Fraud Investigation','Amit Shah','3210987654','amit.shah@police.gov','2012-12-01');

ALTER TABLE Department AUTO_INCREMENT = 8;

INSERT INTO Police (PoliceID,PoliceName,Ranking,Email,PhoneNumber,Date_of_Birth,Age,Salary,Dept_ID) VALUES
(301,'Ravi Verma','Inspector','ravi.verma@police.gov','9876543210','1980-04-12',45,80000,1),
(302,'Anita Desai','Superintendent','anita.desai@police.gov','8765432109','1975-08-19',50,150000,2),
(303,'Suresh Iyer','Constable','suresh.iyer@police.gov','7654321098','1990-02-25',35,30000,3),
(304,'Meena Joshi','Inspector','meena.joshi@police.gov','6543210987','1985-06-30',40,80000,4),
(305,'Rajesh Khanna','Head Constable','rajesh.khanna@police.gov','5432109876','1988-11-11',37,45000,5),
(306,'Neha Kapoor','Deputy Commissioner','neha.kapoor@police.gov','4321098765','1973-03-03',52,175000,6),
(307,'Amit Shah','Inspector','amit.shah@police.gov','3210987654','1982-09-09',43,80000,7),
(308,'Vikram Malhotra','Inspector','vikram.malhotra@police.gov','9876501234','1984-01-15',41,82000,1),
(309,'Sunita Reddy','Constable','sunita.reddy@police.gov','8765409876','1991-07-21',34,32000,1),
(310,'Karan Gupta','Sub-Inspector','karan.gupta@police.gov','7654398765','1987-10-10',38,60000,2),
(311,'Pooja Sharma','Superintendent','pooja.sharma@police.gov','6543987654','1978-05-05',47,148000,2),
(312,'Alok Nair','Head Constable','alok.nair@police.gov','5439876543','1986-12-12',39,46000,3),
(313,'Rekha Patel','Inspector','rekha.patel@police.gov','4321987654','1981-02-28',44,81000,4),
(314,'Arvind Singh','Constable','arvind.singh@police.gov','3219876543','1993-09-19',32,31000,5),
(315,'Deepa Menon','Deputy Commissioner','deepa.menon@police.gov','2109876543','1970-06-25',55,180000,6);

ALTER TABLE Police AUTO_INCREMENT = 316;

INSERT INTO Station (Station_ID,StationName,Location,ContactNumber,Dept_ID,InChargeOfficer_ID) VALUES
(1,'Central Station','Mumbai','9988776655',1,301),
(2,'North Station','Delhi','8877665544',2,302),
(3,'East Station','Kolkata','7766554433',3,303),
(4,'West Station','Ahmedabad','6655443322',4,304),
(5,'South Station','Chennai','5544332211',5,305),
(6,'Metro Station','Bangalore','4433221100',6,306),
(7,'Riverfront Station','Lucknow','3322110099',7,307);

ALTER TABLE Station AUTO_INCREMENT = 8;

INSERT INTO CaseTable (CaseID,CaseType,DateReported,Description_Of_Case,ProgressPercentage,Verdict,Stage,AssignedOfficer_ID) VALUES
(401,'Cyber Fraud','2023-01-10','Unauthorized access to banking systems',80.50,'Pending','Investigation',301),
(402,'Murder','2022-11-05','Homicide in residential area',95.00,'Guilty','Trial',302),
(403,'Drug Possession','2023-03-15','Illegal narcotics found',60.00,'Pending','Investigation',303),
(404,'Traffic Violation','2023-04-20','Hit and run case',100.00,'Closed','Verdict Given',304),
(405,'Forgery','2022-12-01','Fake documents used',70.00,'Pending','Investigation',307),
(406,'Terror Threat','2023-05-25','Threat to transport',40.00,'Pending','Initial Review',306),
(407,'Bank Fraud','2023-06-10','Money laundering',85.00,'Pending','Investigation',305);

ALTER TABLE CaseTable AUTO_INCREMENT = 408;

INSERT INTO Criminal (Criminal_ID,Name_,Address,DateofBirth,Gender,CriminalRecord,CaseID,Age,TrialDuration) VALUES
(501,'Rohan Mehta','12 MG Road','1990-07-15','M','Cyber fraud',401,34,'6 months'),
(502,'Priya Sharma','45 Park Street','1985-03-22','F','Murder',402,39,'2 years'),
(503,'Arjun Rao','78 Lake View','1992-11-30','M','Drug trafficking',403,32,'1 year'),
(504,'Sneha Kulkarni','23 Beach Road','1995-05-10','F','Hit and run',404,29,'6 months'),
(505,'Vikram Singh','90 Hilltop','1988-08-08','M','Forgery',405,36,'8 months'),
(506,'Zoya Khan','66 Garden Lane','1993-01-01','F','Terror links',406,31,'3 years'),
(507,'Manish Tiwari','34 Riverbank','1980-12-12','M','Bank fraud',407,44,'1 year');

ALTER TABLE Criminal AUTO_INCREMENT = 508;

INSERT INTO Evidence (EvidenceID,CaseID,CollectedBy,EvidenceType,Description,DateCollected,StorageLocation) VALUES
(601,401,301,'Digital Logs','Server logs','2023-01-11','Locker A-12'),
(602,402,302,'Knife','Blood weapon','2022-11-06','Vault B-03'),
(603,403,303,'Powder Sample','Narcotics sample','2023-03-16','Chem-02'),
(604,404,304,'CCTV Footage','Camera footage','2023-04-21','Locker A-07');

ALTER TABLE Evidence AUTO_INCREMENT = 605;

INSERT INTO CourtProceedings (ProceedingID,CaseID,ProceedingDate,CourtName,JudgeName,ProceedingType,PoliceID,Remarks) VALUES
(801,401,'2025-09-12','Mumbai High Court','Justice R. Mehta','Preliminary Hearing',301,'Evidence review'),
(802,402,'2025-09-13','Delhi Sessions Court','Justice A. Kapoor','Final Verdict',302,'Verdict announced'),
(803,403,'2025-09-14','Kolkata Criminal Court','Justice S. Banerjee','Witness Examination',303,'Testimony scheduled'),
(804,404,'2025-09-15','Chennai Tribunal','Justice M. Iyer','Verdict Review',304,'Review session');

ALTER TABLE CourtProceedings AUTO_INCREMENT = 805;

-- ========================================================
-- TRIGGERS
-- ========================================================

DELIMITER $$

-- Trigger to log case insertion into Evidence
CREATE TRIGGER log_case_insert
AFTER INSERT ON CaseTable
FOR EACH ROW
BEGIN
  INSERT INTO Evidence (CaseID, EvidenceType, Description, DateCollected, StorageLocation)
  VALUES (NEW.CaseID, 'Auto-log: Case Created', 'System generated', CURDATE(), 'System');
END$$

-- Trigger to update Case stage when a criminal is assigned
CREATE TRIGGER update_case_on_criminal_insert
AFTER INSERT ON Criminal
FOR EACH ROW
BEGIN
  UPDATE CaseTable 
  SET Stage = 'Trial Phase' 
  WHERE CaseID = NEW.CaseID;
END$$

-- Trigger to compute criminal age before insert
CREATE TRIGGER update_criminal_age
BEFORE INSERT ON Criminal
FOR EACH ROW
BEGIN
  SET NEW.Age = TIMESTAMPDIFF(YEAR, NEW.DateofBirth, CURDATE());
END$$

-- Trigger to log department creation
CREATE TRIGGER after_department_insert
AFTER INSERT ON Department
FOR EACH ROW
BEGIN
  INSERT INTO DepartmentLog (Dept_ID, ActionType) 
  VALUES (NEW.Dept_ID, 'INSERT');
END$$

-- Trigger to log department deletion
CREATE TRIGGER after_department_delete
AFTER DELETE ON Department
FOR EACH ROW
BEGIN
  INSERT INTO DepartmentLog (Dept_ID, ActionType) 
  VALUES (OLD.Dept_ID, 'DELETE');
END$$

-- Trigger to schedule automatic initial court hearing when a criminal is added
CREATE TRIGGER after_criminal_insert
AFTER INSERT ON Criminal
FOR EACH ROW
BEGIN
  IF (SELECT COUNT(*) FROM CourtProceedings WHERE CaseID = NEW.CaseID) = 0 THEN
    INSERT INTO CourtProceedings (CaseID, ProceedingDate, CourtName, JudgeName, ProceedingType, PoliceID, Remarks)
    VALUES (
      NEW.CaseID,
      CURDATE(),
      'District Court',
      'To Be Assigned',
      'Initial Hearing',
      NULL,
      CONCAT('Auto-generated proceeding for criminal ', NEW.Name_)
    );
  END IF;
END$$

-- Trigger to update CourtRemarks when criminal details change
CREATE TRIGGER after_criminal_update
AFTER UPDATE ON Criminal
FOR EACH ROW
BEGIN
  IF NOT (NEW.CriminalRecord <=> OLD.CriminalRecord) 
     OR NOT (NEW.TrialDuration <=> OLD.TrialDuration) THEN

    UPDATE CourtProceedings
    SET Remarks = CONCAT(
        'Updated on ', DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i'),
        ': Criminal record or trial info changed for ',
        NEW.Name_, 
        '. New record: ', COALESCE(NEW.CriminalRecord, 'N/A'),
        ', Trial duration: ', COALESCE(NEW.TrialDuration, 'N/A')
    )
    WHERE CaseID = NEW.CaseID;
  END IF;
END$$

-- Trigger to update Case progress when evidence is added
CREATE TRIGGER trg_update_case_progress
AFTER INSERT ON Evidence
FOR EACH ROW
BEGIN
    UPDATE CaseTable
    SET ProgressPercentage = LEAST(ProgressPercentage + 5.00, 100.00)
    WHERE CaseID = NEW.CaseID;
END$$

DELIMITER ;

-- ========================================================
-- VIEWS
-- ========================================================

CREATE OR REPLACE VIEW CriminalCaseSummaryView AS
SELECT 
    c.CaseID,
    c.CaseType,
    c.Description_Of_Case,
    c.DateReported,
    c.Stage,
    c.ProgressPercentage,
    c.Verdict,

    -- Officer Info
    p.PoliceName AS AssignedOfficer,
    p.Ranking AS OfficerRank,
    p.PhoneNumber AS OfficerContact,

    -- Department Info
    d.DepartmentType AS Department,
    d.DepartmentHead AS DepartmentHead,

    -- Criminal Info
    cr.Name_ AS CriminalName,
    cr.Gender,
    cr.Age,
    cr.CriminalRecord,
    cr.TrialDuration,

    -- Court Info
    cp.CourtName,
    cp.JudgeName,
    cp.ProceedingType,
    cp.ProceedingDate,
    cp.Remarks AS CourtRemarks

FROM CaseTable c
LEFT JOIN Police p ON c.AssignedOfficer_ID = p.PoliceID
LEFT JOIN Department d ON p.Dept_ID = d.Dept_ID
LEFT JOIN Criminal cr ON c.CaseID = cr.CaseID
LEFT JOIN CourtProceedings cp ON c.CaseID = cp.CaseID;