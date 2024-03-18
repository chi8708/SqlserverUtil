我们需要获取上面每一行记录的三个日期列的最大值。

方法一(效率高)：

select Guid,(select Max(NewDate) from (values (Date1),(Date2),(Date3)) as #temp(NewDate)) as MaxDate from Demo

方法二(效率高)：

select Guid, max(NewDate) as MaxDate from Demo unpivot (NewDate for DateVal in (Date1,Date2,Date3)) as u group by Guid

方法三(效率低，不建议用)：

select Guid, (select max(NewDate) as MaxDate from (select Demo.Date1 as NewDate union select Demo.Date2 union select Demo.Date3)ud) MaxDate from Demo



第一种方法使用values子句，将每行数据构造为只有一个字段的表，以后求最大值，非常巧妙；

第二种方法使用行转列经常用的UNPIVOT 关键字进行转换再显示；

第三种方法跟第一种方法差不多，但是使用union将三个UpdateByAppDate字段合并为只有一个字段的结果集然后求最大值。
————————————————
版权声明：本文为CSDN博主「weixin_39973410」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_39973410/article/details/112894519





多行 分组后取其中1行
SELECT  * FROM
(
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY villageId ORDER BY CountC DESC) AS rn
  FROM Village_Tel_20230907
  ) c WHERE rn=1