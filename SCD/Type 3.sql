CREATE OR REPLACE TABLE STAGING_PRODUCT_SCD3(
PRODUCTID STRING,
PRODUCTNAME STRING,
PRODUCTCATEGORY STRING,
PRODUCTDESCRIPTION STRING,
EFFECTIVEDATE DATE
);

CREATE OR REPLACE TABLE DIM_PRODUCT_SCD3(
SURROGATEKEY NUMBER AUTOINCREMENT,
PRODUCTID STRING,
PRODUCTNAME STRING,
PREVIOUS_PRODUCTNAME STRING,
PRODUCTCATEGORY STRING,
PREVIOUS_PRODUCTCATEGORY STRING,
PRODUCTDESCRIPTION STRING,
EFFECTIVEDATE DATE,
CURRENTFLAG BOOLEAN
);

DROP TABLE DIME_PRODUCT_SCD3;

---> To instert the value in staging Table
INSERT INTO STAGING_PRODUCT_SCD3 VALUES ('P001','LAPTOP','ELECTONICS', 'DESCRIPTION PRODUCT A','2023-07-01 12:00:00');
INSERT INTO STAGING_PRODUCT_SCD3 VALUES ('P002','SMARTPHONE','ELECTONICS','DESCRIPTION PRODUCT B', '2023-07-01 12:00:00');

SELECT * FROM STAGING_PRODUCT_SCD3;


---> merge statement
MERGE INTO DIM_PRODUCT_SCD3 AS TARGET
USING STAGING_PRODUCT_SCD3 AS SOURCE
ON TARGET.PRODUCTID=SOURCE.PRODUCTID

WHEN MATCHED AND TARGET.CURRENTFLAG=TRUE THEN
UPDATE SET TARGET.CURRENTFLAG=FALSE, TARGET.EFFECTIVEDATE=SOURCE.EFFECTIVEDATE

WHEN MATCHED AND TARGET.CURRENTFLAG=FALSE THEN
UPDATE SET TARGET.PRODUCTNAME=SOURCE.PRODUCTNAME,
TARGET.PREVIOUS_PRODUCTNAME =TARGET.PRODUCTNAME,
TARGET.PRODUCTCATEGORY = SOURCE.PRODUCTCATEGORY,
TARGET.PREVIOUS_PRODUCTCATEGORY=TARGET.PRODUCTCATEGORY,
TARGET.PRODUCTDESCRIPTION=SOURCE.PRODUCTDESCRIPTION,
TARGET.EFFECTIVEDATE=SOURCE.EFFECTIVEDATE,
TARGET.CURRENTFLAG=TRUE

WHEN NOT MATCHED THEN 
INSERT (PRODUCTID, PRODUCTNAME, PREVIOUS_PRODUCTNAME, PRODUCTCATEGORY, PREVIOUS_PRODUCTCATEGORY, PRODUCTDESCRIPTION, EFFECTIVEDATE, CURRENTFLAG) VALUES(SOURCE.PRODUCTID, SOURCE.PRODUCTNAME, NULL, SOURCE.PRODUCTCATEGORY, NULL, SOURCE.PRODUCTDESCRIPTION, SOURCE.EFFECTIVEDATE, TRUE);


SELECT * FROM STAGING_PRODUCT_SCD3;
SELECT * FROM DIM_PRODUCT_SCD3;

INSERT INTO STAGING_PRODUCT_SCD3 VALUES ('P003','TABLET','ELECTONICS', 'DESCRIPTION PRODUCT C','2023-07-01 12:00:00');


UPDATE STAGING_PRODUCT_SCD3 SET PRODUCTNAME='PHONE' WHERE PRODUCTID='P002';

---Conclusion:
-- (The previous value  are updated in their previous and set to false in that case , while inserting new record, the previous value attributes are set to NULL and the FLAG is True)
