CREATE OR REPLACE SCHEMA FILE_FORMAT;

---> Create a file format - its is mostly used for the testing purpose (not for bulk loading)
CREATE FILE FORMAT MYCSV_FF 
TYPE='CSV'
COMPRESSION = 'AUTO'
FIELD_DELIMITER = ','
RECORD_DELIMITER = '\n'
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = 'None'
TRIM_SPACE = FALSE
ERROR_ON_COLUMN_COUNT_MISMATCH = true
ESCAPE = 'NONE'
DATE_FORMAT= 'AUTO'
TIMESTAMP_FORMAT = 'AUTO'
NULL_IF = ('\\N');


---> To check the content of User Stage 
list @~;

--> this PUT command is not supported in Web UI instead use SnowSQL -->
put file:///C:\Komal_notes\Snowflake_Notes\SNOWFLAKE\Data\Mall_Customers.csv @~;

---> To remove the file from staging Area --->
rm @~;

---> to load the data into target table  - use COPY INTO command
COPY INTO DEV_DB.FILE_FORMAT.CUSTOMERS
FROM @~
FILE_FORMAT = 'DEV_DB.FILE_FORMAT.MYCSV_FF'
ON_ERROR = 'SKIP_FILE';

---> Creating a new table 
CREATE TABLE CUSTOMERS (
    CustomerID INT NOT NULL,
    Gender STRING,
    Age INT,
    AnnualIncome INT,
    Spending_Score INT,
    PRIMARY KEY (CustomerID)
);

---> staging the data into table stage
put file:///C:\Komal_notes\Snowflake_Notes\SNOWFLAKE\Data\Mall_Customers.csv @DEV_DB.FILE_FORMAT.%CUSTOMERS;

---> To check the content of Table Stage
list @%customers;

---> to load the data into target table  - use COPY INTO command
COPY INTO DEV_DB.FILE_FORMAT.CUSTOMERS
FROM @DEV_DB.FILE_FORMAT.%CUSTOMERS
FILE_FORMAT = 'DEV_DB.FILE_FORMAT.MYCSV_FF'
ON_ERROR = 'SKIP_FILE';

SELECT * FROM DEV_DB.FILE_FORMAT.CUSTOMERS;

DROP TABLE DEV_DB.FILE_FORMAT.CUSTOMERS;


-------------------------> Named Stages------------------------>

---> create a Stage in WEB UI or else from snow SQL
CREATE STAGE internal_named_stage 
	DIRECTORY = ( ENABLE = true );


---> Adding data into  Internal Named Stage
put file:///C:\Komal_notes\Snowflake_Notes\SNOWFLAKE\Data\Mall_Customers.csv @DEV_DB.FILE_FORMAT.INTERNAL_NAMED_STAGE;                                                                       

---> to load the data into target table  - use COPY INTO command
COPY INTO DEV_DB.FILE_FORMAT.CUSTOMERS
FROM @DEV_DB.FILE_FORMAT.INTERNAL_NAMED_STAGE
FILE_FORMAT = 'DEV_DB.FILE_FORMAT.MYCSV_FF'
ON_ERROR = 'SKIP_FILE'
PURGE = FALSE
FORCE = FALSE; ---> IF ITS true - the data will load again n will create the replication

---> to check the content of the Internal named Stage
LIST @DEV_DB.FILE_FORMAT.INTERNAL_NAMED_STAGE;

---> We can ALso query the data in Internal name stage and can see the rows and columns.
SELECT  t.$1, t.$2, t.$3, t.$4, t.$5 FROM @DEV_DB.FILE_FORMAT.INTERNAL_NAMED_STAGE t;

SELECT metadata$filename, t.$1, t.$2, t.$3, t.$4, t.$5 FROM @DEV_DB.FILE_FORMAT.INTERNAL_NAMED_STAGE t;

---> to check the content of the Directory Table
SELECT * FROM DIRECTORY(@DEV_DB.FILE_FORMAT.INTERNAL_NAMED_STAGE);

----------------------------------------> External Stage (Using AWS) ----------------------------------->

----> 1. Create the External Stage from web UI inside the stages ----> select the cloud services

----> 2. to check the content of external stage
LIST @DEV_DB.FILE_FORMAT.AWS_EXTERNAL_STAGE;

---> to see the data of a table in a staged file
SELECT metadata$filename, t.$1, t.$2, t.$3, t.$4, t.$5 FROM @DEV_DB.FILE_FORMAT.AWS_EXTERNAL_STAGE t;

----> 3. Creating a new table 
CREATE TABLE CUSTOMERS (
    CustomerID INT NOT NULL,
    Gender STRING,
    Age INT,
    AnnualIncome INT,
    Spending_Score INT,
    PRIMARY KEY (CustomerID)
);

----> 4. to load the data into target table  - use COPY INTO command
COPY INTO DEV_DB.FILE_FORMAT.CUSTOMERS
FROM @DEV_DB.FILE_FORMAT.AWS_EXTERNAL_STAGE
FILE_FORMAT = 'DEV_DB.FILE_FORMAT.MYCSV_FF'
ON_ERROR = 'SKIP_FILE'
PURGE = FALSE
FORCE = FALSE; ---> IF ITS true - the data will load again n will create the replication

SELECT * FROM DEV_DB.FILE_FORMAT.CUSTOMERS;