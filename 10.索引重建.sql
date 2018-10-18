----�����ؽ�
----1.��ѯ������Ƭ �ܿ��߷�
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

----����
dbcc showcontig('ElcCustomerinfo','index_wxopenid')

---avg_fragmentation_in_percent ���߼�ɨ����Ƭ������50%�Ϳ��Կ����ؽ���

-----2.�����ؽ� 
-----��������Ҫ���棺����ǰ�ȱ���ȫ��
-----�����ؽ�ǰ��������ݿ��л�Ϊ����ģʽ�������������ƻ��������ļ��н��У����������ļ��ܴ󣬶������ļ�����������־�ļ�������Ҫ��
--�ѵĶ࣬�һ��ҵ�����Ӱ�졣
alter index index_wxopenid
on ElcCustomerinfo
rebuild
with(online = on ,sort_in_tempDB = on , maxdop = 3); -----����жȣ�����ϵͳCPU������80%Ϊ��
