SELECT schemaname, relname, n_live_tup ,n_dead_tup, 
((case when n_dead_tup = 0 then 1 else n_dead_tup end)::float  / (case when n_live_tup = 0 then 1 else n_live_tup end)::float)*100 as "dead_tupple (percentage)" 
FROM pg_stat_user_tables where schemaname = 'public' and n_live_tup > 0 and n_dead_tup > 0 order by 5 desc;
