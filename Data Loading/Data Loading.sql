SELECT * FROM LOAD.PUBLIC.EMPLOYEE;

--> creating a file format to unload the csv data
CREATE OR REPLACE FILE FORMAT MY_CSV_UNLOADED
TYPE = CSV
FIELD_DELIMITER=','
SKIP_HEADER=1
NULL_IF = ('NULL','null')
empty_field_as_null =TRUE
COMPRESSION=GZIP;

-->DROP TABLE LOAD.INTERNAL_STAGE.EMPLOYEE;


---> To UNLOAD the data from table into table stage
COPY INTO @LOAD.INTERNAL_STAGE.MY_INTERNAL_STAGE 
FROM LOAD.PUBLIC.EMPLOYEE
FILE_FORMAT = (TYPE = 'CSV', SKIP_HEADER = 1);

---> To unload the table from stage to local filesystem and it will only run in snowsql
GET @LOAD.INTERNAL_STAGE.MY_INTERNAL_STAGE file://C:\Users\Administrator\Downloads\
