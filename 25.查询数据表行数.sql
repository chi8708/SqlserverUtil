select a.name as '表名',b.rows as '表数据行数'
from sysobjects a inner join sysindexes b
on a.id = b.id
where a.type = 'u'
and b.indid in (0,1)
order by b.rows DESC
