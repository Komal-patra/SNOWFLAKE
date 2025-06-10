--------------------------------------Snowflake to Local File System-------------------------------------------------------
---> Creating a file format for unloading CSV Data
CREATE OR REPLACE FILE FORMAT MY_CSV_UNLOAD
TYPE = CSV
FIELD_DELIMITER=','
SKIP_HEADER=1
NULL_IF=('NULL','null')
EMPTY_FIELD_AS_NULL = TRUE
COMPRESSION=GZIP;

---> Step 1:  Unloading The data from SNowflake Database into Staging Area using 'COPY INTO'
COPY INTO @%CUSTOMERS
FROM CUSTOMERS
FILE_FORMAT = MY_CSV_UNLOAD;

---> to check the content 
list @%customers;

--->  Step 2: In snowsql, Unload Data from Staging to Local File SYstem.
GET @%customers file://C:/Komal_notes/Snowflake_Notes/SNOWFLAKE/;


---------------------------------------Snowflake to External Stage AWS----------------------------------------------------------

---> Loading Data from Sbowflake table to External Stage AWS
COPY INTO @AWS_EXTERNAL_STAGE
FROM  CUSTOMERS
FILE_FORMAT = MY_CSV_UNLOAD;

---> To check the content of External stage
LIST @AWS_EXTERNAL_STAGE;
