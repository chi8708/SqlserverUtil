 ---自动编号
 SELECT @Result=COUNT(1) FROM dbo.ACT_SaleOrderMain WHERE ActOrd_ID LIKE '%ACT'+right(CONVERT(varchar(100), GETDATE(), 112),6)+'%'

        IF (@Result>0)
        BEGIN
            SELECT TOP 1 @dd=ActOrd_ID FROM dbo.ACT_SaleOrderMain WHERE ActOrd_ID LIKE '%ACT'+ right(CONVERT(varchar(100), GETDATE(), 112),6)+'%' ORDER BY ActOrd_ID DESC

            SET @ActOrd_ID = 'ACT' + right(CONVERT(varchar(100), GETDATE(), 112),6) +'-'+ right('00000'+cast(CONVERT(VARCHAR(50),CONVERT(FLOAT,RIGHT(@dd,5)) + 1) AS VARCHAR),5)
        END
        ELSE
        BEGIN
            SET @ActOrd_ID='ACT'+right(CONVERT(varchar(100), GETDATE(), 112),6)+'-00001';
        END
        
        
----时间加随机数生成主键
    SET @now=REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(varchar(16), GETDATE(), 121), '-',''),':',''),' ',''),'.','')
    SET @now=SUBSTRING(@now,3,LEN(@now))
    SET @MainId='QTR'+@now+LEFT(ABS(CHECKSUM(NEWID())),5)