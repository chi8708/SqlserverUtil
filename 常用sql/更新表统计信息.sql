--先重建索引后再更新统计信息
USE Test

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

