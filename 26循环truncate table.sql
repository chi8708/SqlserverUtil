-- �����������Լ������ѡ���������������⣩
--EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
GO

-- ʹ���α�ѭ�������� TRUNCATE ���
DECLARE @TableName NVARCHAR(128)
DECLARE TableCursor CURSOR FOR
    SELECT QUOTENAME(s.name) + '.' + QUOTENAME(t.name) 
    FROM sys.tables t
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    -- ��ѡ�����ض��������˱������ų�ϵͳ��
    WHERE s.name = 'dbo' -- ������ dbo �ܹ��µı�

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

-- �����������Լ�������֮ǰ�����ˣ�
--EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL'
GO