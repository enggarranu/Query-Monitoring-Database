# SIZE MONITORING POSTGRES
Monitoring Table Size
```
SELECT pg_size_pretty( pg_total_relation_size('table_name') );
```

Monitoring Database Size
```
SELECT pg_size_pretty( pg_database_size('dbname') );
```


# SIZE MONITORING MySQL

size of a spesific table:
```
SELECT 
    table_name AS `Table`, 
    round(((data_length + index_length) / 1024 / 1024), 2) `Size in MB` 
FROM information_schema.TABLES 
WHERE table_schema = ‘db_name’
    AND table_name = ‘table_name’;
```

size of all table, Descending order :
```
SELECT 
     table_schema as `Database`, 
     table_name AS `Table`, 
     round(((data_length + index_length) / 1024 / 1024), 2) `Size in MB` 
FROM information_schema.TABLES 
ORDER BY (data_length + index_length) DESC;
```
