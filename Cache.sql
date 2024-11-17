select * from snowflake_sample_data.tpch_sf100.partsupp;

--> To check the parameters
SHOW PARAMETERS LIKE 'USE_CACHED_RESULT';


--> By default the cache is enabled, so to disable the cahe, run the below command:
ALTER SESSION SET USE_CACHED_RESULT='FALSE';
