-- ��ѯ����ִ�е�SQL��� 
SELECT TOP 10 [session_id],[request_id],[start_time] AS '��ʼʱ��',[status] AS '״̬',[command] AS '����',dest.[text]
AS 'sql���', DB_NAME([database_id]) AS '���ݿ���',[blocking_session_id] AS '�������������Ự�ĻỰID',
[wait_type] AS '�ȴ���Դ����',[wait_time] AS '�ȴ�ʱ��',[wait_resource] AS '�ȴ�����Դ',[reads] AS '���������',
[writes] AS 'д����',[logical_reads] AS '�߼�������',[row_count] AS '���ؽ������'FROM sys.[dm_exec_requests] AS der 
CROSS APPLY sys.dm_exec_sql_text(der.[sql_handle]) AS dest WHERE [session_id]>50 AND DB_NAME(der.[database_id])='TestDB'  ORDER BY [cpu_time] DESC

--KILL 255

-- ��ѯ����ִ�е�SQL��� ����50 ���п����쳣�����ݿ����� ����Ϊ10
SELECT TOP 10 [session_id],[request_id],[start_time] AS '��ʼʱ��',[status] AS '״̬',[command] AS '����',dest.[text]
AS 'sql���', DB_NAME([database_id]) AS '���ݿ���',[blocking_session_id] AS '�������������Ự�ĻỰID',
[wait_type] AS '�ȴ���Դ����',[wait_time] AS '�ȴ�ʱ��',[wait_resource] AS '�ȴ�����Դ',[reads] AS '���������',
[writes] AS 'д����',[logical_reads] AS '�߼�������',[row_count] AS '���ؽ������'FROM sys.[dm_exec_requests] AS der 
CROSS APPLY sys.dm_exec_sql_text(der.[sql_handle]) AS dest WHERE [session_id]>50  ORDER BY [cpu_time] DESC

KILL 318


--DBCC showcontig('Table1')

--DBCC DBREINDEX('Table1')


