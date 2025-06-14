
CREATE TABLE CUST
AS (SELECT * FROM DEV_DB.FILE_FORMAT.CUSTOMERS);

SELECT * FROM CUST;

--> BY MISTAKENLY UPDATED THE TABLE WITH WRONG INFORMATION
UPDATE CUST SET GENDER = 'FEMALE';   ---> QUERY ID: 01bcf4f7-0306-b4eb-0002-bd7a00098192

UPDATE CUST SET AGE = 18;  ---> QUERY_ID: 01bcf4f9-0306-b4cd-0002-bd7a0009b14e

--- As it is the business critical edition and the permanent table - it can be retained upto 90 days.

---> To recover the data based on Time
SELECT * FROM CUST AT(OFFSET => -60*20); --> IN THIS CASE WE NEED TO KNOW THE EXACT TIME

---> So we can use statement ID (Query ID) TO RECOVER
SELECT * FROM CUST BEFORE (STATEMENT => '01bcf4f9-0306-b4cd-0002-bd7a0009b14e');
SELECT * FROM CUST BEFORE (STATEMENT => '01bcf4f7-0306-b4eb-0002-bd7a00098192');

DROP TABLE CUST;

UNDROP TABLE CUST;

--> If we alter the wrong information and drop it . ANd then after some specific time - if i ytry to retr
UPDATE CUST SET AGE = 18; ---> QUERY ID: 01bcf53b-0306-b633-0002-bd7a00097c16

SELECT * FROM CUST BEFORE (STATEMENT => '01bcf53b-0306-b633-0002-bd7a00097c16');

---> By Default for the standard + and business critical : the retention time is 1 days
---> SO we can alter the retention time (but only applicable for enterprise and business critical) : use DATA_RETENTION_TIME_IN_DAYS
ALTER TABLE CUST SET DATA_RETENTION_TIME_IN_DAYS = 10;
ALTER TABLE CUST SET DATA_RETENTION_TIME_IN_DAYS = 100; --> Exceeds maximum allowable retention time (90 day(s)). 

ALTER TABLE CUST SET DATA_RETENTION_TIME_IN_DAYS =3; ---> Data retention based on Table-level
ALTER ACCOUNT SET DATA_RETENTION_TIME_IN_DAYS=2; ---> Data retention based on Account-level (By default - if not specified)