UPDATE Tabl2
SET [name]=t.[name]
FROM Table1 AS t WHERE Tabl2.AId=t.Id

UPDATE Tabl2
SET [name]=t.[name]
FROM Table1 AS t,Tabl2 WHERE Tabl2.AId=t.Id

----£¨ÍÆ¼ö£©
UPDATE a SET a.name2=a.[name] from
(SELECT t.*,t2.[name] AS name2 FROM Table1 AS t,Tabl2 AS t2 WHERE t2.AId=t.id) a