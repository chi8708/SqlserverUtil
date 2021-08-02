---sqlserver count()很慢 ，需要更新统计信息

--更新指定统计信息
UPDATE STATISTICS Sales.SalesOrderDetail AK_SalesOrderDetail_rowguid;
GO

--更新表格上的所有统计信息
UPDATE STATISTICS Sales.SalesOrderDetail;
GO

--更新整个数据库上的所有统计信息
EXEC sp_updatestats;

--删除统计信息
DROP STATISTICS Purchasing.Vendor.VendorCredit, Sales.SalesOrderHeader.CustomerTotal;
GO

--查看统计信息上一次更新时间
SELECT
       OBJECT_NAME(OBJECT_ID)
FROM sys.stats
WHERE STATS_DATE(object_id, stats_id) is not null

---查看统计信息更新信息
SELECT *
FROM sys.stats
WHERE object_id = object_id('Pub_Client')
SELECT OBJECT_NAME(1236967533)
DBCC SHOW_STATISTICS('Pub_Client',Address_index)


参考：https://www.cnblogs.com/xinysu/p/6484788.html


---方法2.更新整个库 对使用全文索引的表有用
USE DB1
Go 

DECLARE @DBCCString NVARCHAR(1000)
DECLARE @TableName VARCHAR(100)
DECLARE Cur_Index CURSOR FOR  SELECT Name AS TblName FROM sysobjects  WHERE xType='U' ORDER BY TblName
FOR READ ONLY
OPEN Cur_Index
FETCH NEXT FROM Cur_Index INTO @TableName
WHILE @@FETCH_STATUS=0
BEGIN
   SET @DBCCString = 'update STATISTICS [' +@TableName +']'
   print @DBCCString
   EXEC SP_EXECUTESQL  @DBCCString
   PRINT convert(char(20),getdate(),120)+ '更新表' + @TableName +'的统计信息........OK!'
   waitfor delay'00:00:02'
   FETCH NEXT FROM Cur_Index INTO @TableName
END
CLOSE Cur_Index
DEALLOCATE Cur_Index
PRINT '操作完成！'
