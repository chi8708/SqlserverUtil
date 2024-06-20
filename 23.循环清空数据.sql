-- 创建临时表存储表名
CREATE TABLE #TempTables (ID INT IDENTITY(1,1), TableName NVARCHAR(255))

-- 插入所有表名，排除特定表
INSERT INTO #TempTables (TableName)
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_NAME NOT IN ('B_Active1') -- 排除特定表

DECLARE @maxID INT, @currentID INT, @tableName NVARCHAR(255), @sql NVARCHAR(MAX)
SELECT @maxID = MAX(ID) FROM #TempTables
SET @currentID = 1

WHILE @currentID <= @maxID
BEGIN
    -- 获取当前表名
    SELECT @tableName = TableName FROM #TempTables WHERE ID = @currentID
    
    -- 动态生成清空表数据的 SQL 语句
    SET @sql = 'TRUNCATE TABLE ' + @tableName
    EXEC sp_executesql @sql
    
    -- 更新当前ID
    SET @currentID = @currentID + 1
	PRINT @tableName+'已清空'
END

-- 删除临时表
DROP TABLE #TempTables
