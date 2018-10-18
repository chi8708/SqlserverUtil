----索引重建
----1.查询索引碎片 避开高峰
Declare @dbid int
Select @dbid=DB_ID()
SELECT DB_NAME(ps.database_id) AS [Database Name], OBJECT_NAME(ps.OBJECT_ID) AS [Object Name],
i.name AS [Index Name], ps.index_id, ps.index_type_desc, ps.avg_fragmentation_in_percent,
ps.fragment_count, ps.page_count, i.fill_factor, i.has_filter, i.filter_definition
FROM sys.dm_db_index_physical_stats(@dbid,NULL, NULL, NULL,null) AS ps
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON ps.[object_id] = i.[object_id]
AND ps.index_id = i.index_id
WHERE ps.database_id = DB_ID()
AND ps.index_type_desc <> 'HEAP'
AND ps.page_count > 2500
ORDER BY ps.avg_fragmentation_in_percent DESC OPTION (RECOMPILE);

----单表
dbcc showcontig('ElcCustomerinfo','index_wxopenid')

---avg_fragmentation_in_percent （逻辑扫描碎片）大于50%就可以考虑重建了

-----2.索引重建 
-----！！！重要警告：操作前先备份全库
-----索引重建前建议把数据库切换为完整模式，否则索引复制会在数据文件中进行，导致数据文件很大，而数据文件的收缩比日志文件的收缩要困
--难的多，且会对业务造成影响。
alter index index_wxopenid
on ElcCustomerinfo
rebuild
with(online = on ,sort_in_tempDB = on , maxdop = 3); -----最大并行度，操作系统CPU核数的80%为宜
