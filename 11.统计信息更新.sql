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