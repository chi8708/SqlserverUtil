--�����������ݿ�
CREATE DATABASE test
 GO
--�ĳ������ָ�ģʽ
ALTER DATABASE test SET  RECOVERY FULL
--���һ���ļ���
ALTER DATABASE test
ADD FILEGROUP WW_GROUP
 GO
 --���ļ���������ļ�
ALTER DATABASE test
ADD FILE 
( NAME = ww,
FILENAME = 'F:\db\wwdat1.ndf',
SIZE = 5MB,
MAXSIZE = 100MB,
FILEGROWTH = 5MB)
TO FILEGROUP ww_Group
 
 --�ڲ�ͬ�ļ����Ϸֱ𴴽�������
CREATE TABLE test..test ( id INT IDENTITY,name varchar(50))
ON  [primary]
CREATE TABLE test..test_GR ( id INT IDENTITY,name varchar(50) )
ON  ww_Group
 go
 insert into test..test(name)
 values ('jack')
 insert into test..test_GR(name)
 values ('jack')
 
--����������
BACKUP DATABASE test
 TO DISK='F:\db\Test_backup.bak'WITH INIT


----�����ļ���---------------------
--���ļ�����
BACKUP DATABASE test
    FILE = 'ww',
    FILEGROUP = 'ww_Group'
    TO DISK='F:\db\CROUPFILES.bak'WITH INIT
--������־
BACKUP LOG test
    TO DISK='F:\db\Test__log.ldf'WITH INIT
---------------------------------
 
--ɾ���ļ����еı��ڵ�����
TRUNCATE TABLE test..test_GR


---��ԭ�ļ���-----------------
--��ԭ���ݣ���־������Ӧ�����Ǹ���ԭ״̬���ļ�
RESTORE DATABASE test
    FILE = 'ww',
    FILEGROUP = 'ww_Group'
    FROM DISK ='F:\db\CROUPFILES.bak'
    WITH FILE = 1, NORECOVERY
RESTORE LOG test
    FROM DISK='F:\db\Test__log.ldf'
    WITH FILE = 1, NORECOVERY



--����β����־
BACKUP LOG test
    TO DISK='F:\db\Test__log.ldf' WITH NOINIT,NO_TRUNCATE
--��ԭβ����־
RESTORE LOG test
    FROM DISK='F:\db\Test__log.ldf'
    WITH FILE = 2, RECOVERY
 GO
---------------------------------

 --�鿴���ݣ�ɾ�����ݵĲ������ɹ��ָ�
 SELECT  *
FROM    test..test_GR


--��ԭ����
RESTORE DATABASE [DataBaseName]
WITH RECOVERY