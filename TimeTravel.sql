-----------------------------------TO RESTORE DROPPED DATABASE OBJECTS-------------------------------------

SHOW TABLES;

USE LOAD;
SELECT * FROM EMPLOYEE;

DROP TABLE EMPLOYEE;

--->To restore the table which has been dropped using Time Travel
UNDROP TABLE EMPLOYEE;

DROP DATABASE LOAD;

USE DATABASE LOAD;

---> To restore the database object
UNDROP DATABASE LOAD;

DROP SCHEMA EXTERNAL_STAGE;

UNDROP SCHEMA EXTERNAL_STAGE;

------------------------------------TO RESTORE THE HISTORICAL DATA --------------------------------------------

---> USE (AT / BEFORE)
USE LOAD;
SELECT * FROM EMPLOYEE;

UPDATE EMPLOYEE SET FIRSTNAME='KOMAL';  ---(entire columns get updated as the prescedent [where clause] is not given)

--->WAY 1
SELECT * FROM EMPLOYEE AT(OFFSET=> -60*10)  ----(-60 SEC * 10 -> 6 MINS)

--->WAY 2
SELECT * FROM EMPLOYEE AT(TIMESTAMP=> '2024-11-16 03:07:05.658 -0800')
--->(Time travel data is not available for table EMPLOYEE. The requested time is either beyond the allowed time travel period or before the object creation time.)
---> to solve this we need exact timestamp which can be taken from the log.

--->WAY 3
SELECT * FROM EMPLOYEE BEFORE(STATEMENT => '01b86876-0105-6976-0002-6cde000e39fe')


----------------------------------------TIME TRAVEL SQL EXTENSION---------------------------------------------

--->how to find the time travel data retention periods of snowflake objects
SHOW PARAMETERS IN DATABASE LOAD;

SHOW PARAMETERS IN SCHEMA PUBLIC;

SHOW PARAMETERS IN TABLE EMPLOYEE;

--->Providing data retention time while creating the tables
CREATE OR REPLACE TABLE MEMBERS_TT (
ID INT,
NAME STRING DEFAULT NULL,
FEE INT NULL
) DATA_RETENTION_TIME_IN_DAYS=90;

---> Modifying the data retention
ALTER TABLE MEMBERS_TT SET DATA_RETENTION_TIME_IN_DAYS=1;

SHOW PARAMETERS IN TABLE MEMBERS_TT;

INSERT INTO MEMBERS_TT (ID, NAME, FEE) VALUES(1, 'KOMAL',0),(2, 'NIKHIL',0), (3, 'RIDDHI',0),(4,'SIDDHI',0),(5, 'ASHA',0);

SELECT * FROM MEMBERS_TT;

--->Updating the records
UPDATE MEMBERS_TT SET FEE='1000' WHERE ID=4;

-->check the query history and take the query ID
SELECT * FROM MEMBERS_TT BEFORE(STATEMENT=>'01b86931-0105-65f5-0002-6cde000e7a2a');

---------------------------------------CLONE (TIME TRAVEL FEATURE)--------------------------------------------
                                   -- (CLONING HISTORICAL OBJECT)--

---> cloning the table
CREATE TABLE MEMBERS_TT_BKP CLONE MEMBERS_TT AT (OFFSET => -10*10); --This offset means going back 1 min

--#DROP TABLE MEMBERS_TT_BKP;

SELECT * FROM MEMBERS_TT_BKP;

---Cloning the database
CREATE DATABASE LOAD_BKP CLONE LOAD AT (OFFSET=>-60*15);

--------------------------------------------------------------------------------------------------------------


CREATE DATABASE IF NOT EXISTS TIME_TAVEL_DB;

USE DATABASE TIME_TAVEL_DB;

CREATE OR REPLACE SCHEMA TIME_TRAVEL_SCHEMA;

USE SCHEMA TIME_TRAVEL_SCHEMA;

--> Create a Table
CREATE TABLE Employee (
    EmpID INT NOT NULL,
    FirstName STRING,
    LastName STRING,
    StartDate DATE,
    ExitDate DATE,
    Title STRING,
    Supervisor STRING,
    ADEmail STRING,
    BusinessUnit STRING,
    EmployeeStatus STRING,
    EmployeeType STRING,
    PayZone STRING,
    EmployeeClassificationType STRING,
    TerminationType STRING,
    TerminationDescription STRING,
    DepartmentType STRING,
    Division STRING,
    DOB STRING,
    State STRING,
    JobFunctionDescription STRING,
    GenderCode CHAR(10),
    LocationCode STRING,
    RaceDesc STRING,
    MaritalDesc STRING,
    PerformanceScore STRING,
    CurrentEmployeeRating STRING,
    PRIMARY KEY (EmpID)
)DATA_RETENTION_TIME_IN_DAYS=3;

SHOW PARAMETERS IN TABLE EMPLOYEE;
