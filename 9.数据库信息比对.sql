���ݿ�Ա�
--sql server ����:
select count(1) from sysobjects where xtype='U'
--����ͼ:
select count(1) from sysobjects where xtype='V'
---���洢����
select count(1) from sysobjects where xtype='P'

SELECT * FROM sysobjects WHERE xtype='P' AND [NAME] NOT 
IN(select [NAME] from [200.200.22.22].OnlineOrdering.dbo.sysobjects where xtype='P')

C = CHECK Լ�� 
D = Ĭ��ֵ�� DEFAULT Լ�� 
F = FOREIGN KEY Լ�� 
L = ��־ 
FN = �������� 
IF = ��Ƕ���� 
P = �洢���� 
PK = PRIMARY KEY Լ���������� K�� 
RF = ����ɸѡ�洢���� 
S = ϵͳ�� 
TF = ���� 
TR = ������ 
U = �û��� 
UQ = UNIQUE Լ���������� K�� 
V = ��ͼ 
X = ��չ�洢����


---��ȡ�洢���̽ű�
declare @p_text varchar(max)
SELECT @p_text= definition FROM sys.sql_modules 
JOIN sys.objects ON sys.sql_modules.object_id=sys.objects.object_id --and type='P' 
and sys.objects.name='ChangeMessageReadUser'
print @p_text

---ˢ����ͼ
exec sp_refreshview @name   

--�Ƚ��������ֶβ���
1.
SELECT * FROM dlxd.[INFORMATION_SCHEMA].[COLUMNS] SC1 WHERE sc1.TABLE_NAME='pub_User'
		EXCEPT
		SELECT* FROM test.[INFORMATION_SCHEMA].[COLUMNS] SC2 WHERE sc2.TABLE_NAME='user1'


2.
select a.name columnname,c.name as typename,case when a.is_nullable =0 then 'Not Null' else 'Null' end as nullable,a.*
from sys.columns a , sys.objects b, sys.types c 
where a.object_id= b.object_id and b.name='Pub_User' and a.system_type_id=c.system_type_id 


