--创建测试数据库
CREATE DATABASE test
 GO
--改成完整恢复模式
ALTER DATABASE test SET  RECOVERY FULL
--添加一个文件组
ALTER DATABASE test
ADD FILEGROUP WW_GROUP
 GO
 --向文件组中添加文件
ALTER DATABASE test
ADD FILE 
( NAME = ww,
FILENAME = 'F:\db\wwdat1.ndf',
SIZE = 5MB,
MAXSIZE = 100MB,
FILEGROWTH = 5MB)
TO FILEGROUP ww_Group
 
 --在不同文件组上分别创建两个表
CREATE TABLE test..test ( id INT IDENTITY,name varchar(50))
ON  [primary]
CREATE TABLE test..test_GR ( id INT IDENTITY,name varchar(50) )
ON  ww_Group
 go
 insert into test..test(name)
 values ('jack')
 insert into test..test_GR(name)
 values ('jack')
 
--做完整备份
BACKUP DATABASE test
 TO DISK='F:\db\Test_backup.bak'WITH INIT


----备份文件组---------------------
--做文件备份
BACKUP DATABASE test
    FILE = 'ww',
    FILEGROUP = 'ww_Group'
    TO DISK='F:\db\CROUPFILES.bak'WITH INIT
--备份日志
BACKUP LOG test
    TO DISK='F:\db\Test__log.ldf'WITH INIT
---------------------------------
 
--删除文件组中的表内的数据
TRUNCATE TABLE test..test_GR


---还原文件组-----------------
--还原备份，日志仅仅被应用于那个还原状态的文件
RESTORE DATABASE test
    FILE = 'ww',
    FILEGROUP = 'ww_Group'
    FROM DISK ='F:\db\CROUPFILES.bak'
    WITH FILE = 1, NORECOVERY
RESTORE LOG test
    FROM DISK='F:\db\Test__log.ldf'
    WITH FILE = 1, NORECOVERY



--备份尾端日志
BACKUP LOG test
    TO DISK='F:\db\Test__log.ldf' WITH NOINIT,NO_TRUNCATE
--还原尾端日志
RESTORE LOG test
    FROM DISK='F:\db\Test__log.ldf'
    WITH FILE = 2, RECOVERY
 GO
---------------------------------

 --查看数据，删除数据的操作被成功恢复
 SELECT  *
FROM    test..test_GR


--还原在线
RESTORE DATABASE [DataBaseName]
WITH RECOVERY