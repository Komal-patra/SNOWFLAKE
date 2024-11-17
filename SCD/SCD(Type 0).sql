CREATE OR REPLACE DATABASE SCD;

CREATE OR REPLACE SCHEMA SCD_SCHEMA;

USE DATABASE SCD;

USE SCHEMA SCD_SCHEMA;

------------------------------------Implementation of Type-0 SCD-----------------------------------------

---> Creating a source table
CREATE OR REPLACE TABLE SOURCE_TABLE (ProductID INT, ProductName STRING, Category STRING, Price FLOAT);


INSERT INTO SOURCE_TABLE (ProductID, ProductName, Category, Price) VALUES (1,'WIDGET','GADGETS',19.99),(2, 'GIZMO','GADGETS',29.99);

SELECT * FROM SOURCE_TABLE;

---> Creating a target table
CREATE OR REPLACE TABLE DIM_TARGET_TABLE (ProductID INT, ProductName STRING, Category STRING, Price FLOAT);

INSERT INTO DIM_TARGET_TABLE (ProductID, ProductName, Category, Price) VALUES (1,'WIDGET','GADGETS',19.99),(2, 'GIZMO','GADGETS',29.99);

TRUNCATE TABLE DIM_TARGET_TABLE;

UPDATE SOURCE_TABLE
SET ProductName= 'SUPER WIDGET'
WHERE ProductID=1;


MERGE INTO DIM_TARGET_TABLE AS TARGET
USING SOURCE_TABLE AS SOURCE
ON TARGET.ProductID=SOURCE.ProductID
WHEN MATCHED THEN
UPDATE SET TARGET.ProductName=TARGET.ProductName, ---No Update
TARGET.Category =  TARGET.Category,  --No update
TARGET.PRICE = TARGET.Price
WHEN NOT MATCHED THEN
INSERT (ProductID, ProductName, Category, Price) VALUES (SOURCE.ProductID, SOURCE.ProductName, SOURCE.Category, SOURCE.Price);

SELECT * FROM SOURCE_TABLE;

SELECT * FROM DIM_TARGET_TABLE;

INSERT INTO SOURCE_TABLE (ProductID, ProductName, Category, Price) VALUES (3,'WIDGET','GADGETS',19.99),(4, 'GIZMO','GADGETS',29.99);

--Conclusion: (whenever source table get's updated, the dimension table should not get updated as per SCD type-0 rule)
