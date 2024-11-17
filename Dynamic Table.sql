CREATE DATABASE IF NOT EXISTS DATA_TRANFORMATION;

USE DATABASE DATA_TRANFORMATION;

CREATE SCHEMA DATA_TX_SCHEMA;

USE SCHEMA DATA_TX_SCHEMA;

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

SELECT GET_DDL('TABLE','EMPLOYEE');

PUT file://C:\Users\Administrator\Downloads\employee_data.csv @~

---> To insert the data from 'USER Stage' to 'TABLE'
COPY INTO DATA_TRANFORMATION.DATA_TX_SCHEMA.EMPLOYEE 
FROM @~
FILE_FORMAT = (TYPE = 'CSV', SKIP_HEADER = 1)
ON_ERROR = 'CONTINUE';

---> CREATED THE DYNAMIC TABLE 
CREATE OR REPLACE DYNAMIC TABLE DT1
TARGET_LAG = '1 MINUTE'
WAREHOUSE = COMPUTE_WH
AS 
SELECT EmpID, FirstName, LastName, StartDate
FROM EMPLOYEE;

CREATE OR REPLACE DYNAMIC TABLE DT2
TARGET_LAG = '1 MINUTES'
WAREHOUSE = COMPUTE_WH
AS 
SELECT EmpID, FirstName, LastName, StartDate
FROM dt1 WHERE EmpId >3000;


select * from dt2;

--> to drop the dynamic tableDATA_TRANFORMATION.DATA_TX_SCHEMA.DT1DATA_TRANFORMATION
DROP DYNAMIC TABLE dt2;

--> To suspend the dynamic table
ALTER DYNAMIC TABLE dt1 SUSPEND;

--> To resume the dynamic table
ALTER DYNAMIC TABLE dt1 RESUME;

--> to manually refresh the dyanmic table
ALTER DYNAMIC TABLE dt2 REFRESH;

---> to refresh the dynamic refresh history table 
SELECT * FROM TABLE (DATA_TRANSFORMATION.INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY (NAME_PREFIX => 'DATA_TRANSFORMATION.DATA_TX_SCHEMA.' , ERROR_ONLY => TRUE)) ORDER BY name, data_timestamp;


