SELECT
    obj.Name ������,
    sc.TEXT ����
FROM
    syscomments sc
INNER JOIN sysobjects obj ON sc.Id = obj.ID
WHERE
    sc.TEXT LIKE '%����%'
    
    
    