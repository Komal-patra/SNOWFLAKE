--->To Check the content of User STage -->
LIST @~;

--> this PUT command is not supported in Web UI instead use SnowSQL -->
put file:///C:\Users\Administrator\Downloads\employee_data.csv @~;

put file:///C:\Komal_notes\Snowflake_Notes\SNOWFLAKE\Data\Mall_Customers.csv @~;

---> To check the content of Table STage --->
LIST @%TEST;

---> Created the Database called 'LOAD' --->
create database load;

---> Created the Stage --->
CREATE STAGE LOAD.PUBLIC.TEST;

--> Exceute the below PUT command in SnowSQL --->
put file:///C:\Users\Administrator\Downloads\employee_data.csv @LOAD.PUBLIC.%TEST;

LIST @LOAD.PUBLIC.TEST;

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

---> DROP TABLE EMPLOYEE;



---> check whether the data is loaded or not.
select * from load.public.employee;
