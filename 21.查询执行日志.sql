SELECT * FROM (
SELECT 
--创建时间
QS.creation_time,
--查询语句
SUBSTRING(ST.text,(QS.statement_start_offset/2)+1,
((CASE QS.statement_end_offset WHEN -1 THEN DATALENGTH(st.text)
ELSE QS.statement_end_offset END - QS.statement_start_offset)/2) + 1
) AS statement_text,
--执行文本
ST.text,
--执行计划
QS.total_worker_time,
QS.last_worker_time,
QS.max_worker_time,
QS.min_worker_time,
qs.execution_count
FROM
sys.dm_exec_query_stats QS
--关键字
CROSS APPLY
sys.dm_exec_sql_text(QS.sql_handle) ST
WHERE
QS.creation_time BETWEEN '2023-04-26 17:40:00' AND '2023-04-26 19:00:00' --'2022-05-20 09:00:00' AND '2022-05-20 18:00:00'
--AND ST.text LIKE '%%'
--and ST.text like '%UPDATE%'
) a WHERE LOWER(a.text)  LIKE '%cu_orderMain%' AND LOWER(a.text) LIKE '%update%'