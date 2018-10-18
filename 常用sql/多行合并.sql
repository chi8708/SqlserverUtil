-- =============================================================================
-- Title: ��SQL�з���ϲ�������
-- Author: dobear        Mail(MSN): dobear_0922@hotmail.com
-- Environment: Vista + SQL2005
-- Date: 2008-04-22
-- =============================================================================

--1. ��������Ӳ�������
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


--2 ��SQL2000ֻ�����Զ��庯��ʵ��
----2.1 �����ϲ�����fn_strSum������id�ϲ�valueֵ
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

-- ���ú���
SELECT id, VALUE = dbo.fn_strSum(id) FROM tb GROUP BY id
DROP FUNCTION dbo.fn_strSum

----2.2 �����ϲ�����fn_strSum2������id�ϲ�valueֵ
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

-- ���ú���
SELECT id, VALUE = dbo.fn_strSum2(id) FROM tb GROUP BY id
DROP FUNCTION dbo.fn_strSum2


--3 ��SQL2005�е��½ⷨ
----3.1 ʹ��OUTER APPLY
SELECT * 
FROM (SELECT DISTINCT id FROM tb) A OUTER APPLY(
        SELECT [values]= STUFF(REPLACE(REPLACE(
            (
                SELECT value FROM tb N
                WHERE id = A.id
                FOR XML AUTO
            ), '<N value="', ','), '"/>', ''), 1, 1, '')
)N

----3.2 ʹ��XML
SELECT id, [values]=STUFF((SELECT ','+[value]+cast(id as varchar) FROM tb t WHERE id=tb.id FOR XML PATH('')), 1, 1, '')
FROM tb
GROUP BY id

--4 ɾ�����Ա�tb
drop table tb

/**//*
id          values
----------- --------------------
1           aa,bb
2           aaa,bbb,ccc

(2 row(s) affected)




--��3.xml��ʽ����

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

1.���м�¼��һ�м�¼��
SELECT aId, [values]=STUFF((SELECT ','+bView +cast(bDate as varchar) FROM bTable t WHERE aid=t.aId and t.bSort='2' FOR XML PATH('')), 1, 1, '')
FROM bTable
GROUP BY aId


2.����Ч��
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