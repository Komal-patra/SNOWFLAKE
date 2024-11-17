LOAD.INTERNAL_STAGE.MY_INTERNAL_STAGELOAD.INTERNAL_STAGE.MY_INTERNAL_STAGECREATE SCHEMA INTERNAL_STAGE; 

---> Creating a stage  without directory table
CREATE STAGE LOAD.INTERNAL_STAGE.MY_INTERNAL_STAGE;

----> create a directory table in named stage --->
CREATE OR REPLACE STAGE MY_INTERNAL_STAGE DIRECTORY = (ENABLE=TRUE) FILE_FORMAT = (TYPE='CSV', FIELD_DELIMITER=',', SKIP_HEADER =1) ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');

put file:///C:\Users\Administrator\Downloads\employee_data.csv @LOAD.INTERNAL_STAGE.%;

LIST @LOAD.INTERNAL_STAGE.MY_INTERNAL_STAGE;

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
);

 DROP TABLE EMPLOYEE;

---> To insert the data from 'Table Stage' to 'TABLE'
COPY INTO LOAD.INTERNAL_STAGE.EMPLOYEE 
FROM @LOAD.INTERNAL_STAGE.MY_INTERNAL_STAGE
FILE_FORMAT = (TYPE = 'CSV', SKIP_HEADER = 1)
ON_ERROR = 'CONTINUE';


---> Query will only execute when we enable the directory table as TRUE.
SELECT * FROM DIRECTORY(@LOAD.INTERNAL_STAGE.MY_INTERNAL_STAGE);

---> manually refreshing directory table metadata
ALTER STAGE LOAD.INTERNAL_STAGE.MY_INTERNAL_STAGE REFRESH;

---> to get the filE URL for directory table
SELECT FILE_URL FROM DIRECTORY(@MY_INTERNAL_STAGE);LOAD.INTERNAL_STAGE.MY_INTERNAL_STAGE
