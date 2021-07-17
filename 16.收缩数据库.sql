
--清空日志
--DUMP TRANSACTION OnlineOrdering WITH NO_LOG 

--截断事务日志 
--BACKUP LOG OnlineOrdering WITH NO_LOG

--收缩数据库 
DBCC SHRINKDATABASE(gemmymiscall)  WITH NO_INFOMSGS 