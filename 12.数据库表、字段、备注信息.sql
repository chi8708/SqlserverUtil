24.获取数据库表、字段、备注信息
    SELECT TOP 10 * FROM sysobjects WHERE NAME ='V_Order'
    
    SELECT TOP 100 * FROM syscolumns AS s WHERE s.id='688721506'
    
    SELECT TOP 100 * FROM sys.extended_properties a 
    LEFT JOIN  (SELECT * FROM syscolumns AS s WHERE s.id='1668200993') b
    ON a.minor_id=b.colid
    WHERE a.major_id='1668200993'