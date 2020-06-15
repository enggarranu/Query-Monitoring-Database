\copy (SELECT n.nspname AS "Schema", c.relname AS "Name", pg_catalog.pg_size_pretty(pg_catalog.pg_table_size(c.oid)) AS "Size", pg_stat_get_live_tuples(c.oid) AS LiveTuples, pg_stat_get_dead_tuples(c.oid) AS DeadTuples, CASE WHEN c.reltuples <> 0 THEN (pg_stat_get_dead_tuples(c.oid)/c.reltuples)*100 ELSE 0 END AS Percentage, greatest(age(c.relfrozenxid),age(t.relfrozenxid)) as age FROM pg_catalog.pg_class c LEFT JOIN pg_class t ON c.reltoastrelid = t.oid LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace WHERE c.relkind ='r' AND n.nspname NOT IN ('pg_catalog', 'information_schema', 'pglogical', 'pgq', 'pgq_ext', 'pgq_node', 'londiste') AND n.nspname !~ '^pg_toast' AND pg_catalog.pg_table_is_visible(c.oid) ORDER BY 1, 2) to 'statistic.csv' CSV HEADER DELIMITER E'\t';

SELECT n.nspname AS "Schema",
       c.relname AS "Name",
       pg_catalog.pg_size_pretty(pg_catalog.pg_table_size(c.oid)) AS "Size",
       pg_stat_get_live_tuples(c.oid) AS LiveTuples,
       pg_stat_get_dead_tuples(c.oid) AS DeadTuples,
       CASE
           WHEN c.reltuples <> 0 THEN (pg_stat_get_dead_tuples(c.oid)/c.reltuples)*100
           ELSE 0
       END AS Percentage,
       greatest(age(c.relfrozenxid),age(t.relfrozenxid)) as age,
       psut.last_vacuum, psut.last_autovacuum, psut.last_analyze, psut.last_autoanalyze
FROM pg_catalog.pg_class c
LEFT JOIN pg_class t ON c.reltoastrelid = t.oid
LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
LEFT JOIN pg_stat_user_tables psut on psut.relname = c.relname
WHERE c.relkind ='r'
    AND n.nspname NOT IN ('pg_catalog',
                          'information_schema',
                          'pglogical',
                          'pgq',
                          'pgq_ext',
                          'pgq_node',
                          'londiste')
    AND n.nspname !~ '^pg_toast'
    AND pg_catalog.pg_table_is_visible(c.oid)
ORDER BY 1,
         2;
------


\copy (SELECT n.nspname AS "Schema", c.relname AS "Name", pg_catalog.pg_size_pretty(pg_catalog.pg_table_size(c.oid)) AS "Size", pg_stat_get_live_tuples(c.oid) AS LiveTuples, pg_stat_get_dead_tuples(c.oid) AS DeadTuples, CASE WHEN c.reltuples <> 0 THEN (pg_stat_get_dead_tuples(c.oid)/c.reltuples)*100 ELSE 0 END AS Percentage, greatest(age(c.relfrozenxid),age(t.relfrozenxid)) as age, psut.last_vacuum, psut.last_autovacuum, psut.last_analyze, psut.last_autoanalyze FROM pg_catalog.pg_class c LEFT JOIN pg_class t ON c.reltoastrelid = t.oid LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace LEFT JOIN pg_stat_user_tables psut on psut.relname = c.relname WHERE c.relkind ='r' AND n.nspname NOT IN ('pg_catalog', 'information_schema', 'pglogical', 'pgq', 'pgq_ext', 'pgq_node', 'londiste') AND n.nspname !~ '^pg_toast' AND pg_catalog.pg_table_is_visible(c.oid) ORDER BY 1, 2) to 'statistic.csv' CSV HEADER DELIMITER E'\t';
         
 
