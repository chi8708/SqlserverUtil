SELECT
    obj.Name 过程名,
    sc.TEXT 内容
FROM
    syscomments sc
INNER JOIN sysobjects obj ON sc.Id = obj.ID
WHERE
    sc.TEXT LIKE '%条件%'
    
    
    