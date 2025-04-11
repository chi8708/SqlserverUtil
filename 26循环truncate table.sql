-- 禁用所有外键约束（可选，解决外键依赖问题）
--EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
GO

-- 使用游标循环表并生成 TRUNCATE 语句
DECLARE @TableName NVARCHAR(128)
DECLARE TableCursor CURSOR FOR
    SELECT QUOTENAME(s.name) + '.' + QUOTENAME(t.name) 
    FROM sys.tables t
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    -- 可选：按特定条件过滤表（例如排除系统表）
    WHERE s.name = 'dbo' -- 仅处理 dbo 架构下的表

OPEN TableCursor
FETCH NEXT FROM TableCursor INTO @TableName

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        EXEC ('TRUNCATE TABLE ' + @TableName)
        PRINT 'Truncated: ' + @TableName
    END TRY
    BEGIN CATCH
        PRINT 'Failed to truncate ' + @TableName + ': ' + ERROR_MESSAGE()
    END CATCH

    FETCH NEXT FROM TableCursor INTO @TableName
END

CLOSE TableCursor
DEALLOCATE TableCursor
GO

-- 重新启用外键约束（如果之前禁用了）
--EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL'
GO