数据库对比
--sql server 数表:
select count(1) from sysobjects where xtype='U'
--数视图:
select count(1) from sysobjects where xtype='V'
---数存储过程
select count(1) from sysobjects where xtype='P'

SELECT * FROM sysobjects WHERE xtype='P' AND [NAME] NOT 
IN(select [NAME] from [200.200.22.22].OnlineOrdering.dbo.sysobjects where xtype='P')

C = CHECK 约束 
D = 默认值或 DEFAULT 约束 
F = FOREIGN KEY 约束 
L = 日志 
FN = 标量函数 
IF = 内嵌表函数 
P = 存储过程 
PK = PRIMARY KEY 约束（类型是 K） 
RF = 复制筛选存储过程 
S = 系统表 
TF = 表函数 
TR = 触发器 
U = 用户表 
UQ = UNIQUE 约束（类型是 K） 
V = 视图 
X = 扩展存储过程


---获取存储过程脚本
declare @p_text varchar(max)
SELECT @p_text= definition FROM sys.sql_modules 
JOIN sys.objects ON sys.sql_modules.object_id=sys.objects.object_id --and type='P' 
and sys.objects.name='ChangeMessageReadUser'
print @p_text

---刷新视图
exec sp_refreshview @name   

--比较两个表字段差异
1.
SELECT * FROM dlxd.[INFORMATION_SCHEMA].[COLUMNS] SC1 WHERE sc1.TABLE_NAME='pub_User'
		EXCEPT
		SELECT* FROM test.[INFORMATION_SCHEMA].[COLUMNS] SC2 WHERE sc2.TABLE_NAME='user1'


2.
select a.name columnname,c.name as typename,case when a.is_nullable =0 then 'Not Null' else 'Null' end as nullable,a.*
from sys.columns a , sys.objects b, sys.types c 
where a.object_id= b.object_id and b.name='Pub_User' and a.system_type_id=c.system_type_id 


