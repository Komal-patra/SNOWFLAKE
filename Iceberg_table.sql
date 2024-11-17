--- When Creating the Iceberg Table, The snowfllake and AWS should be in the same region.


-----------------------------------ICEBERG TABLE AS A SNOWFLAKE--------------------------------------------
--- step 1: Create s3 bucket in AWS and a directory called 'tables'

--- step 2: Create a policy to give access to specific users

--- step 3: Configure External volume (it is like a connector) 
    --- create External volume to connect snowflake and AWS 
CREATE OR REPLACE EXTERNAL VOLUME my_ext_volume
STORAGE_LOCATIONS=
(
(
(NAME='MY_ICEBERG_EXT_VOLUME'
STORAGE_PROVIDER = 'S3'
STORAGE_BASE_URL= 's3://snowflake-iceberg-table/tables/'
STORAGE_AWS_ROLE_ARN = 'ARN:AWS:IAM:-----------'
)
);

--- step 4: To get informantion about AWS IAM user (AWS_IAM_USER_ARN & STORAGE_AWS_EXTERNAL_ID)
DESC EXTERNAL VOLUME my_ext_volume;
--Go to Roles and edit the trust policy and change the external ID anf IAM user ARN in AWS

--- step 5: Creating the Table
--- Create the ICEBERG table
CREATE OR REPLACE ICEBERG TABLE DEV_DB.PUBLIC.CUSTOMER (
	CUSTOMER_KEY INT,
	CUSTOMER_NAME STRING,
	CUSTOMER_ADDRESS STRNG,
	CUSTOMER_NATIONALITY STRING
)
CATALOG = 'SNOWFLAKE' --FOR EXTERNAL CATALOG USE AWS GLUE
EXTERNAL_VOLUME='MY_EXT_VOL'
BASE_LOCATION='CUSTOMER';
---(IN S3, the directory is created as the base location and inside that another directory called 'METADATA' is created in JSON format.)


--- step 6: Insert the value in the table.
INSERT INTO DEV_DB.PUBLIC.CUSTOMER VALUES(1,'KOMAL', 'IRELAND', 'INDIAN');
--( Inside the 'Customer (base location directory)', a directory called 'data/' is created inside which we ave data stored in .parquet file format')

SELECT * FROM DEV_DB.PUBLIC.CUSTOMER;


