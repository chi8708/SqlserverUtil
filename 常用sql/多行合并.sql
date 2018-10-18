-- =============================================================================
-- Title: 在SQL中分类合并数据行
-- Author: dobear        Mail(MSN): dobear_0922@hotmail.com
-- Environment: Vista + SQL2005
-- Date: 2008-04-22
-- =============================================================================

--1. 创建表，添加测试数据
CREATE TABLE tb(id int, [value] varchar(10))
INSERT tb SELECT 1, 'aa'
UNION ALL SELECT 1, 'bb'
UNION ALL SELECT 2, 'aaa'
UNION ALL SELECT 2, 'bbb'
UNION ALL SELECT 2, 'ccc'

--SELECT * FROM tb
/**//*
id          value
----------- ----------
1           aa
1           bb
2           aaa
2           bbb
2           ccc

(5 row(s) affected)
*/


--2 在SQL2000只能用自定义函数实现
----2.1 创建合并函数fn_strSum，根据id合并value值
GO
CREATE FUNCTION dbo.fn_strSum(@id int)
RETURNS varchar(8000)
AS
BEGIN
    DECLARE @values varchar(8000)
    SET @values = ''
    SELECT @values = @values + ',' + value FROM tb WHERE id=@id
    RETURN STUFF(@values, 1, 1, '')
END
GO

-- 调用函数
SELECT id, VALUE = dbo.fn_strSum(id) FROM tb GROUP BY id
DROP FUNCTION dbo.fn_strSum

----2.2 创建合并函数fn_strSum2，根据id合并value值
GO
CREATE FUNCTION dbo.fn_strSum2(@id int)
RETURNS varchar(8000)
AS
BEGIN
    DECLARE @values varchar(8000)    
    SELECT @values = isnull(@values + ',', '') + value FROM tb WHERE id=@id
    RETURN @values
END
GO

-- 调用函数
SELECT id, VALUE = dbo.fn_strSum2(id) FROM tb GROUP BY id
DROP FUNCTION dbo.fn_strSum2


--3 在SQL2005中的新解法
----3.1 使用OUTER APPLY
SELECT * 
FROM (SELECT DISTINCT id FROM tb) A OUTER APPLY(
        SELECT [values]= STUFF(REPLACE(REPLACE(
            (
                SELECT value FROM tb N
                WHERE id = A.id
                FOR XML AUTO
            ), '<N value="', ','), '"/>', ''), 1, 1, '')
)N

----3.2 使用XML
SELECT id, [values]=STUFF((SELECT ','+[value]+cast(id as varchar) FROM tb t WHERE id=tb.id FOR XML PATH('')), 1, 1, '')
FROM tb
GROUP BY id

--4 删除测试表tb
drop table tb

/**//*
id          values
----------- --------------------
1           aa,bb
2           aaa,bbb,ccc

(2 row(s) affected)




--用3.xml方式操作

USE [kc_db]
GO

/****** Object:  Table [dbo].[aTable]    Script Date: 06/24/2013 20:59:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[aTable](
	[aId] [int] IDENTITY(1,1) NOT NULL,
	[aTitle] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [kc_db]
GO

/****** Object:  Table [dbo].[bTable]    Script Date: 06/24/2013 20:59:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[bTable](
	[bId] [int] IDENTITY(1,1) NOT NULL,
	[aId] [int] NULL,
	[bSort] [varchar](50) NULL,
	[bView] [nvarchar](1000) NULL,
	[bName] [varchar](50) NULL,
	[bDate] [datetime] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

1.两行记录变一行记录。
SELECT aId, [values]=STUFF((SELECT ','+bView +cast(bDate as varchar) FROM bTable t WHERE aid=t.aId and t.bSort='2' FOR XML PATH('')), 1, 1, '')
FROM bTable
GROUP BY aId


2.最终效果
select * from atable as a2
inner join

(SELECT aId , [Lvalues]=STUFF((SELECT ','+bView +cast(bDate as varchar) FROM bTable as b1
inner join aTable a1
on a1.aId=b1.aId
 WHERE b3.aId=b1.aId and b1.bSort='2' and b1.aId=a1.aId FOR XML PATH('')), 1, 1, ''),
 [Ovalues]=STUFF((SELECT ','+bView +cast(bDate as varchar) FROM bTable as b1
inner join aTable a1
on a1.aId=b1.aId
 WHERE b3.aId=b1.aId and b1.bSort='1' and b1.aId=a1.aId FOR XML PATH('')), 1, 1, '')
FROM bTable as b3
GROUP BY aId) as b2

on a2.aId=b2.aId