---sqlserver count()���� ����Ҫ����ͳ����Ϣ

--����ָ��ͳ����Ϣ
UPDATE STATISTICS Sales.SalesOrderDetail AK_SalesOrderDetail_rowguid;
GO

--���±���ϵ�����ͳ����Ϣ
UPDATE STATISTICS Sales.SalesOrderDetail;
GO

--�����������ݿ��ϵ�����ͳ����Ϣ
EXEC sp_updatestats;

--ɾ��ͳ����Ϣ
DROP STATISTICS Purchasing.Vendor.VendorCredit, Sales.SalesOrderHeader.CustomerTotal;
GO

--�鿴ͳ����Ϣ��һ�θ���ʱ��
SELECT
       OBJECT_NAME(OBJECT_ID)
FROM sys.stats
WHERE STATS_DATE(object_id, stats_id) is not null

---�鿴ͳ����Ϣ������Ϣ
SELECT *
FROM sys.stats
WHERE object_id = object_id('Pub_Client')
SELECT OBJECT_NAME(1236967533)
DBCC SHOW_STATISTICS('Pub_Client',Address_index)


�ο���https://www.cnblogs.com/xinysu/p/6484788.html


---����2.���������� ��ʹ��ȫ�������ı�����
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
   PRINT convert(char(20),getdate(),120)+ '���±�' + @TableName +'��ͳ����Ϣ........OK!'
   waitfor delay'00:00:02'
   FETCH NEXT FROM Cur_Index INTO @TableName
END
CLOSE Cur_Index
DEALLOCATE Cur_Index
PRINT '������ɣ�'
