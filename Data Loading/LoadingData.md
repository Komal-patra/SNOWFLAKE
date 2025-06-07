
# Internal Storage
## User Stage

---> To Check the content of User STage -->
LIST @~;

--> this PUT command is not supported in Web UI use SnowSQL -->
```
put file:///C:\Komal_notes\Snowflake_Notes\SNOWFLAKE\Data\Mall_Customers.csv @~;
```

![alt text](../output_screenshot/user_stage.png)

---> To remove the file from staging Area --->
```
rm @~;
```
![alt text](../output_screenshot/remove_user_stage.png)

---> to load the data into target table  - use COPY INTO command
```
COPY INTO DEV_DB.FILE_FORMAT.CUSTOMERS
FROM @~
FILE_FORMAT = 'DEV_DB.FILE_FORMAT.MYCSV_FF'
ON_ERROR = 'SKIP_FILE';
```

## Table Stage

--> Create a Table
```
CREATE TABLE CUSTOMERS (
    CustomerID INT NOT NULL,
    Gender STRING,
    Age INT,
    AnnualIncome INT,
    Spending_Score INT,
    PRIMARY KEY (CustomerID)
);
```

---> Adding data into Table Internal Stage

```
put file:///C:\Komal_notes\Snowflake_Notes\SNOWFLAKE\Data\Mall_Customers.csv @DEV_DB.FILE_FORMAT.%CUSTOMERS;
```

![alt text](../output_screenshot/Table_stage.png)

---> To check the content of Table Stage
```
list @%customers;
```

---> to load the data into target table  - use COPY INTO command
```
COPY INTO DEV_DB.FILE_FORMAT.CUSTOMERS
FROM @DEV_DB.FILE_FORMAT.%CUSTOMERS
FILE_FORMAT = 'DEV_DB.FILE_FORMAT.MYCSV_FF'
ON_ERROR = 'SKIP_FILE';
```
Note:
If there is any change in the file/data, --> Again add into staging by removing the previous one
[ if u again just re-run the PUT query, it will not make an update as it will be skipped because of the same name of file]


## Named Stage

---> create a Stage in WEB UI or else from snow SQL

```
CREATE STAGE internal_named_stage 
	DIRECTORY = ( ENABLE = true ); 
```
(directory table is enabled)

---> Adding data into  Internal Named Stage

```
put file:///C:\Komal_notes\Snowflake_Notes\SNOWFLAKE\Data\Mall_Customers.csv @DEV_DB.FILE_FORMAT.INTERNAL_NAMED_STAGE;
```
---> to check the content of the Internal named Stage
```
LIST @DEV_DB.FILE_FORMAT.INTERNAL_NAMED_STAGE;
```

---> We can ALso query the data in Internal name stage and can see the rows and columns.
```
SELECT  t.$1, t.$2, t.$3, t.$4, t.$5 FROM @DEV_DB.FILE_FORMAT.INTERNAL_NAMED_STAGE t;
```
```
SELECT metadata$filename, t.$1, t.$2, t.$3, t.$4, t.$5 FROM @DEV_DB.FILE_FORMAT.INTERNAL_NAMED_STAGE t;
```

---> to check the content of the Directory Table
```
SELECT * FROM DIRECTORY(@DEV_DB.FILE_FORMAT.INTERNAL_NAMED_STAGE);
```

---> To Log all the execution of commands in snowsql
```
!spool c:\Komal_notes\Snowflake_Notes\SNOWFLAKE\logs
```

# External Storage

Loading data from cloud services are the part of External Stage - (no need of ETL use to load data from different services)

----> 1. Create the External Stage from web UI inside the stages ----> select the cloud services.
            OR
        Through the SQL Command :

    ```
    CREATE STAGE AWS_External_Stage 
        URL = 's3://devopskomi/Mall_Customers.csv' 
        CREDENTIALS = ( AWS_KEY_ID = 'AKIA4AQ3T3KT3OZZIPK7 ' AWS_SECRET_KEY = '*****' ) 
        DIRECTORY = ( ENABLE = true );
    ```

![alt text](../output_screenshot/External_AWS_Stage.png)

---> 2. to check the content of external stage : 
    ```
    LIST @DEV_DB.FILE_FORMAT.AWS_EXTERNAL_STAGE;
    ```

---> to see the data of a table in a staged file
SELECT metadata$filename, t.$1, t.$2, t.$3, t.$4, t.$5 FROM @DEV_DB.FILE_FORMAT.AWS_EXTERNAL_STAGE t;

---> 3. Create the Target Table
    ```
    CREATE TABLE CUSTOMERS (
        CustomerID INT NOT NULL,
        Gender STRING,
        Age INT,
        AnnualIncome INT,
        Spending_Score INT,
        PRIMARY KEY (CustomerID)
    );
    ```
----> 4. to load the data into target table  - use COPY INTO command
    ```
    COPY INTO DEV_DB.FILE_FORMAT.CUSTOMERS
    FROM @DEV_DB.FILE_FORMAT.AWS_EXTERNAL_STAGE
    FILE_FORMAT = 'DEV_DB.FILE_FORMAT.MYCSV_FF'
    ON_ERROR = 'SKIP_FILE'
    PURGE = FALSE
    FORCE = FALSE; ---> IF ITS true - the data will load again n will create the replication
    ```

----> Validate the table whether data is added
```
SELECT * FROM DEV_DB.FILE_FORMAT.CUSTOMERS;
```



