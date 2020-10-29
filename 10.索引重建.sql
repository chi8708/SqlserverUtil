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



----���
Use Test
Go 

DECLARE @DBCCString NVARCHAR(1000)
DECLARE @TableName VARCHAR(100)
DECLARE Cur_Index CURSOR FOR  
	SELECT Name AS TblName FROM sysobjects  WHERE xType='U' ORDER BY TblName FOR READ ONLY
	OPEN Cur_Index
	FETCH NEXT FROM Cur_Index INTO @TableName
		WHILE @@FETCH_STATUS=0
			BEGIN
   				SET @DBCCString = 'DBCC DBREINDEX(@TblName,'''')WITH NO_INFOMSGS'
   				EXEC SP_EXECUTESQL  @DBCCString,N'@TblName VARCHAR(100)', @TableName
   				PRINT '�ؽ���' + @TableName +'������........OK!'
   				FETCH NEXT FROM Cur_Index INTO @TableName
			END
CLOSE Cur_Index
DEALLOCATE Cur_Index
PRINT '������ɣ�'
