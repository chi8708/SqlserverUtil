SELECT 
    obj.Name ������,
    sc.TEXT ����,
    obj.[type],
    LEN(sc.TEXT)
FROM
    syscomments sc
INNER JOIN sysobjects obj ON sc.Id = obj.ID
WHERE
    sc.TEXT LIKE '%192.168%' AND LEN(sc.[text])>=4000
ORDER BY obj.[type]
    
    