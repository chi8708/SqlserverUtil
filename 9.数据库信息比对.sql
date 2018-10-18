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