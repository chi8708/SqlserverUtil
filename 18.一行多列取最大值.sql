������Ҫ��ȡ����ÿһ�м�¼�����������е����ֵ��

����һ(Ч�ʸ�)��

select Guid,(select Max(NewDate) from (values (Date1),(Date2),(Date3)) as #temp(NewDate)) as MaxDate from Demo

������(Ч�ʸ�)��

select Guid, max(NewDate) as MaxDate from Demo unpivot (NewDate for DateVal in (Date1,Date2,Date3)) as u group by Guid

������(Ч�ʵͣ���������)��

select Guid, (select max(NewDate) as MaxDate from (select Demo.Date1 as NewDate union select Demo.Date2 union select Demo.Date3)ud) MaxDate from Demo



��һ�ַ���ʹ��values�Ӿ䣬��ÿ�����ݹ���Ϊֻ��һ���ֶεı��Ժ������ֵ���ǳ����

�ڶ��ַ���ʹ����ת�о����õ�UNPIVOT �ؼ��ֽ���ת������ʾ��

�����ַ�������һ�ַ�����࣬����ʹ��union������UpdateByAppDate�ֶκϲ�Ϊֻ��һ���ֶεĽ����Ȼ�������ֵ��
��������������������������������
��Ȩ����������ΪCSDN������weixin_39973410����ԭ�����£���ѭCC 4.0 BY-SA��ȨЭ�飬ת���븽��ԭ�ĳ������Ӽ���������
ԭ�����ӣ�https://blog.csdn.net/weixin_39973410/article/details/112894519





���� �����ȡ����1��
SELECT  * FROM
(
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY villageId ORDER BY CountC DESC) AS rn
  FROM Village_Tel_20230907
  ) c WHERE rn=1