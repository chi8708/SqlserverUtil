-- ��ѯ����ִ�е�SQL���
SELECT TOP 10 [session_id],[request_id],[start_time] AS '��ʼʱ��',[status] AS '״̬',[command] AS '����',dest.[text]
AS 'sql���', DB_NAME([database_id]) AS '���ݿ���',[blocking_session_id] AS '�������������Ự�ĻỰID',
[wait_type] AS '�ȴ���Դ����',[wait_time] AS '�ȴ�ʱ��',[wait_resource] AS '�ȴ�����Դ',[reads] AS '���������',
[writes] AS 'д����',[logical_reads] AS '�߼�������',[row_count] AS '���ؽ������'FROM sys.[dm_exec_requests] AS der 
CROSS APPLY sys.dm_exec_sql_text(der.[sql_handle]) AS dest WHERE [session_id]>50 AND DB_NAME(der.[database_id])='Gemmymis'  ORDER BY [cpu_time] DESC

--KILL 255

-- ��ѯ����ִ�е�SQL���
SELECT TOP 10 [session_id],[request_id],[start_time] AS '��ʼʱ��',[status] AS '״̬',[command] AS '����',dest.[text]
AS 'sql���', DB_NAME([database_id]) AS '���ݿ���',[blocking_session_id] AS '�������������Ự�ĻỰID',
[wait_type] AS '�ȴ���Դ����',[wait_time] AS '�ȴ�ʱ��',[wait_resource] AS '�ȴ�����Դ',[reads] AS '���������',
[writes] AS 'д����',[logical_reads] AS '�߼�������',[row_count] AS '���ؽ������'FROM sys.[dm_exec_requests] AS der 
CROSS APPLY sys.dm_exec_sql_text(der.[sql_handle]) AS dest WHERE [session_id]>50  ORDER BY [cpu_time] DESC

KILL 318


--DBCC showcontig('Call_TelService_VW')

--DBCC DBREINDEX('Call_TelService_VW')

SELECT TOP 1000 * FROM dbo.Core_MaterialOrderProcessSubhis

--TRUNCATE TABLE Core_MaterialOrderProcessSubhis

select convert(char(10),getdate(),120)

SELECT
o.name, i.ROWS
FROM sysobjects o, sysindexes i
WHERE o.id = i.id  AND o.Xtype = 'U' AND i.indid < 2
ORDER BY i.ROWS DESC;

SELECT TOP 100 * FROM Core_SettleFRMaterial WHERE createdate >'2016-1-1'

--TRUNCATE TABLE Call_KeyPress2017020301