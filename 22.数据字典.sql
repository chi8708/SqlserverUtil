--推荐
SELECT
    t.[name] AS 表名,
    c.[name] AS 字段名,
	CASE WHEN pkc.object_id IS NOT NULL THEN '√' ELSE '' END AS 是否主键,
	CASE WHEN c.is_identity = 1 THEN '√' ELSE '' END AS 是否标识,
    st.name AS 字段类型,
    c.max_length AS 字段长度,
	--CASE WHEN st.name IN ('decimal', 'numeric') THEN CONCAT(c.precision, ',', c.scale) ELSE CAST(c.max_length AS VARCHAR(10)) END AS 字段长度,
	CASE WHEN st.name IN ('decimal', 'numeric') THEN CAST(c.scale AS NVARCHAR(5))  ELSE '' END AS 小数位数,
   CASE when  c.is_nullable=1 THEN '√' ELSE ''END AS 是否为空,
   ISNULL(dc.definition,'')  AS 默认值,
   ISNULL(CAST(ep.[value] AS VARCHAR(1000)),'')  AS [字段说明]
FROM sys.tables AS t
INNER JOIN sys.columns AS c ON t.object_id = c.object_id
LEFT JOIN sys.extended_properties AS ep ON c.object_id = ep.major_id
    AND c.column_id = ep.minor_id
    AND ep.name = 'MS_Description'
LEFT JOIN sys.types AS st ON c.system_type_id = st.system_type_id
LEFT JOIN sys.key_constraints AS pkc ON t.object_id = pkc.parent_object_id
    AND c.column_id IN (SELECT ic.column_id FROM sys.index_columns AS ic WHERE ic.object_id = t.object_id AND ic.index_id = pkc.unique_index_id)
LEFT JOIN sys.default_constraints AS dc ON c.default_object_id = dc.object_id
WHERE st.name<>'sysname' AND t.name='PX_'
ORDER BY t.name, c.column_id;



-- 字段说明不会出来
-- 数据字典
SELECT
        (case when a.colorder=1 then d.name else '' end)表名,
        a.colorder 字段序号,
        a.name 字段名,
        (case when COLUMNPROPERTY( a.id,a.name,'IsIdentity')=1 then '√'else '' end) 标识,
       (case when (SELECT count(*)
        FROM sysobjects
        WHERE (name in
                (SELECT name
                FROM sysindexes
                WHERE (id = a.id) AND (indid in
                         (SELECT indid
                        FROM sysindexkeys
                        WHERE (id = a.id) AND (colid in
                                  (SELECT colid
                                 FROM syscolumns
                                 WHERE (id = a.id) AND (name = a.name))))))) AND
            (xtype = 'PK'))>0 then '√' else '' end) 主键,
       b.name 类型,
       a.length 占用字节数,
      COLUMNPROPERTY(a.id,a.name,'PRECISION') as 长度,
      isnull(COLUMNPROPERTY(a.id,a.name,'Scale'),0) as 小数位数,
      (case when a.isnullable=1 then '√'else '' end) 允许空,
      isnull(e.text,'') 默认值,
      isnull(g.[value],'') AS 字段说明
FROM  syscolumns  a left join systypes b
on  a.xtype=b.xusertype
inner join sysobjects d
on a.id=d.id  and  d.xtype='U' and  d.name<>'dtproperties'
left join syscomments e
on a.cdefault=e.id
left join sys.extended_properties g
on a.id=g.major_id  AND a.colid = g.major_id
order by a.id,a.colorder,表名