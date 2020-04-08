SELECT nspname AS schemaname ,
       C.relname AS ObjectName ,
       reltuples AS TotalTuples ,
       pg_stat_get_live_tuples(c.oid) AS LiveTuples ,
       pg_stat_get_dead_tuples(c.oid) AS DeadTuples ,
       ((pg_stat_get_dead_tuples(c.oid)/reltuples)*100) AS Percentage ,
       last_vacuum AT time ZONE 'Asia/Jakarta' AS last_vacuum ,
       last_autovacuum AT time ZONE 'Asia/Jakarta' AS last_autovacuum ,
       last_analyze AT time ZONE 'Asia/Jakarta' AS last_analyze ,
       last_autoanalyze AT time ZONE 'Asia/Jakarta' AS last_autoanalyze
FROM pg_class c
LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
LEFT JOIN pg_stat_user_tables K ON (K.relname=C.relname)
WHERE nspname IN ('public')
  AND relkind='r'
  AND reltuples <> 0
  AND pg_stat_get_dead_tuples(c.oid) > 100000
ORDER BY ((pg_stat_get_dead_tuples(c.oid)/reltuples)*100) DESC
