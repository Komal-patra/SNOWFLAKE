
# Table Types

1. Permanent Tables (by default)
2. Temporary Tables
3. Transient tables 

### Permanent tables

---> Creating a Temporary Table

```
CREATE OR REPLACE TEMPORARY TABLE EMPLOYEE_TMP(
employee_id number,
empl_join_date date,
dept varchar(10),
salary number,
manager_id number
);
```

```
INSERT INTO EMPLOYEE_TMP VALUES (8,'2014-10-01','HR',40000,4),
(9,'2014-10-02','MARKETING',50000,9),
(13,'2014-11-01','TECH',100000,3),
(12,'2014-10-01','HR',50000,4),
(2,'2014-11-01','MARKETING',40000,9);
```

```
SELECT * FROM EMPLOYEE_TMP;
```