---���ؽ������ٸ���ͳ����Ϣ
Use Test
Go 

DECLARE @DBCCString NVARCHAR(1000)
DECLARE @TableName VARCHAR(100)
DECLARE Cur_Index CURSOR FOR  SELECT Name AS TblName FROM sysobjects  WHERE xType='U' ORDER BY TblName
FOR READ ONLY
OPEN Cur_Index
FETCH NEXT FROM Cur_Index INTO @TableName
WHILE @@FETCH_STATUS=0
BEGIN
   SET @DBCCString = 'DBCC DBREINDEX(@TblName,'''',90)WITH NO_INFOMSGS'
   EXEC SP_EXECUTESQL  @DBCCString,N'@TblName VARCHAR(100)', @TableName
   PRINT convert(char(20),getdate(),120)+ '�ؽ���' + @TableName +'������........OK!'
   FETCH NEXT FROM Cur_Index INTO @TableName
END
CLOSE Cur_Index
DEALLOCATE Cur_Index
PRINT '������ɣ�'