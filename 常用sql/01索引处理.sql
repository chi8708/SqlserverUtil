--创建 非聚集索引
--CREATE NONCLUSTERED INDEX 索引名 on 表名(字段名)

--创建主键，主键默认为聚集索引
---ALTER TABLE Production.TransactionHistoryArchive
  --ADD CONSTRAINT PK_TransactionHistoryArchive_TransactionID PRIMARY KEY CLUSTERED (TransactionID);