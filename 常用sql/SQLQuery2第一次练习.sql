insert into tslary(name,age,slary)values('jj',22,2500)
update tslary set name=N'������'where age>25
delete from tslary where name='jj'
select *from tslary where slary>3000 order by age desc
select max(slary)from tslary where age<25
select name as '����',age as '����',slary as '����',getdate() as '����'from tslary ;
select count(*)from tslary
select sum(age)from tslary where age>25
select age ,count(*)as '����'from tslary group by age
select age,count(*),max(slary)from tslary group by age
select age,COUNT(*) from tslary where slary>2000 group by age
--û�г���group by ����ֶβ��ܷ���select����У����Ϻ������⣩
select age ,count(*)as '����'from tslary group by age having age>=25

select *from tslary where name like '_a%'
select * from tslary where name like '%n%'
select * from tslary where name is  Null


select top 3* from tslary
select top 3* from tslary where age>=23
select * from tslary where age>=22and age<=23 order by slary desc;

select top 3*from tslary  where age not in
(select top 3 age from tslary order by age asc)
order by age;
--ȡ�����������456������

select top 3 name,age from tslary order by age asc

select '�������',max(age)from tslary
union all
select '��С����',min(age)from tslary

select name,age  from tslary 
union  all
select'����ϼ�', SUM(age) from tslary


select datediff(year,datetimeIn,getdate())as '��ְ����'from 
tslary group by datetimein

select count(*)from tslary 
group by datediff(year,datetimeIn,getdate())

select name,datediff(year,datetimeIn,getdate())as '��ְ����'from tslary

select count(*)as '�ܹ�����',datediff(year,datetimeIn,getdate())as '��ְ����'from tslary 
group by datediff(year,datetimeIn,getdate())--����Ա���Ĺ��䲢ͳ��

 select DATEPART(year,getdate())
 
 select DATEPART(year,datetimeIn),count(*) from tslary 
 group by DATEPART(year,datetimeIn);
--ȡ��ÿһ����ְԱ������
 select CAST('123' as int),CAST('2008-08-01' as datetime)
 ,CONVERT(int,'123')
 
 select isnull(name,'����')as '����'from  tslary


select name,
(
case
when slary<2000 then '������'
when slary>=2000 and slary<=3000then '�е�����'
else '������'
end
)as '����ˮƽ',slary
from tslary

select name,
(case
when payIn>0 then PayIn
else 0
end
)as '����',
(case
when payIn<0 then ABS(payIn)
else 0
end
)as '֧��'
from T_payIn


select convert(varchar(30),@@SERVICENAME) as shili

--vs��ִ��SQL���ղ�����������
INSERT INTO T_users(userName, userPwd)
OUTPUT  inserted.userID
VALUES   ('ga', 'hah')

1'or'1'='1 (sqlע�룩

insert into T_Users(username,age)
values('ggg','22');

select* from(SELECT  id,username,age,row_number() over(order by id)rownumber
FROM  T_Users
where id>3)t
where t.rownumber>2 and t.rownumber<6
--(ȥ�����еĵڼ������ݣ���Ч��ҳ)
distinct �����ظ���Ϣ







--��ҵ��Ƶ��ϰ
--�������Ӷ�������
insert into T_students
select'С��2',22,0,1 union
select'С��3',32,0,2 union 
select'С��3',21,1,2 union
select'С��4',22,0,1

--T_students���Ƶ�T_studentbak(ϵͳ���Լ�����)��
select* into T_studentbak  from T_students

--delete form �� ��truncate table �������
--delete ɾ�����ֶ����������ͷ����truncate���ͷ(��1��ʼ)
--truncateɾ���ٶȽϿ죬���ܲ�������־�н��м�¼��


--create �������� alert�������޸����ݣ������޸��Ѿ������

--��ǰ���ڼ�183��
select GETDATE()+ DATEPART(DAY,GETDATE())+183
select DATEADD(DAY,183,GETDATE())
select getdate()+180

--ɾ��Լ��
alter table student
drop constraint FK_student

--��һ�����Ϊ�����Ӷ��Լ���� 
alter table Employees add 
constraint PK_Employees_EmpId primary key(EmpId),--��������Լ��
constraint UQ_Employees_EmpName unique(EmpName),--����ΨһԼ��
constraint DF_Employees_EmpGender default('Ů') for EmpGender,--Ĭ��Լ��
constraint CK_Employees_EmpAge check(EmpAge>=0 and EmpAge<=120),
constraint FK_Employees_Department_DepId foreign key(DepId) references Department(DepId)


use MyPhotos

alter proc usp_getPagedphotos
  @PageIndex int,
  @PageSize int,
  @pageCount int output
 as 
 declare @n int
 select  @n=COUNT(*) from  Photos
 set @pageCount=ceiling((@n*1.0/@PageSize)) 
 
 select * from
 (select *,ROW_NUMBER()  over(order by pTime Desc ) as rownum from  Photos) as t
 where  t.rownum between (@PageIndex-1)*@PageSize+1 and @PageSize*@PageIndex
 order by pTime desc
 --as ��Ҳ���Լ�Begin end ��ʾ����
 
--���Դ洢����
declare @n int
exec usp_getPagedphotos
3,3, @n output

print @n

  
  
  
  ListView��Ч��ҳ
  
  use MyPhotos
select * from
(select *,ROW_NUMBER() over(order by ptime desc) as num from Photos )as t
where t.num>@stratRowIndex and num<=(@startRowIndex+1)*PageSize



--with as ȫ����ʱ��ִ��һ��
with 
cr as
(
select * from ChatRecord_2015
),
cid as
(
select top 10 cr.Id from cr
)

select * from cr where Id in(select * from cid)--�ٲ�ѯһ�α���

---sql��ȡ���ŷָ�����
       DECLARE @detailLone VARCHAR(2000),@DPointerPrev INT,@DPointerCurr INT
       DECLARE @MaterialCode VARCHAR(200),@UnitCode VARCHAR(200)
       SET @detailLone='1212,1234,123232,'
       Set @DPointerPrev=1
       SET @DPointerCurr=1
           if CharIndex(',',@detailLone,2)>0
           begin
           ------get @MaterialCode------------
           set @DPointerCurr=CharIndex(',',@detailLone,@DPointerPrev+1)
           PRINT @DPointerPrev
           SET @MaterialCode=SUBSTRING(@detailLone,@DPointerPrev,@DPointerCurr-@DPointerPrev)
           SET @DPointerPrev = @DPointerCurr
           PRINT @DPointerPrev
           PRINT @MaterialCode
           ------end @MaterialCode-------------------------

            ------get @UnitCode------------
           set @DPointerCurr=CharIndex(',',@detailLone,@DPointerPrev+1)
           SET @UnitCode=SUBSTRING(@detailLone,@DPointerPrev+1,@DPointerCurr-@DPointerPrev-1)
           SET @DPointerPrev = @DPointerCurr
           PRINT @UnitCode
           ------get @UnitCode------------

            ------get @Last------------
           set @DPointerCurr=CharIndex(',',@detailLone,@DPointerPrev+1)
           set @UnitCode=SUBSTRING(@detailLone,@DPointerPrev+1,@DPointerCurr-@DPointerPrev-1)
           SET @DPointerPrev = @DPointerCurr
           PRINT @UnitCode
           PRINT @DPointerCurr
           ------get @Last------------
           end

 ---�������ָ�������
       DECLARE @detailLone VARCHAR(2000),@DPointerPrev INT,@DPointerCurr INT
       DECLARE @FunctionCode VARCHAR(200)
       SET @detailLone='1212,1234,123232,'
       Set @DPointerPrev=1
       SET @DPointerCurr=1
        while (@DPointerPrev+1 < LEN(@detailLone))
         Begin
             Set @DPointerCurr=CharIndex(',',@detailLone,@DPointerPrev+1)
             PRINT @DPointerCurr
             if(@DPointerCurr>0)
             Begin
             set @FunctionCode=SUBSTRING(@detailLone,@DPointerPrev+1,@DPointerCurr-@DPointerPrev-1)
             SET @DPointerPrev = @DPointerCurr
             PRINT @FunctionCode
             END
         End
---�������ָ������� N'12,34ss,#56����,78��ˮ,#'
alter PROCEDURE [dbo].[P_SendGoodsInStorage]
  @detailList varchar(8000) --������ϸ ����
AS
BEGIN
     DECLARE @SendGoodItemId BIGINT --�����ӱ�Id
     DECLARE @dateNow DATETIME
     DECLARE @PointerPrev int
     DECLARE @PointerCurr INT
     DECLARE @DPointerPrev int
     DECLARE @DPointerCurr int
     DECLARE @detailLone varchar(500)
     DECLARE @MaterialCode VARCHAR(10)
     DECLARE @UnitCode VARCHAR(20)
     Set @PointerPrev=1
     set @PointerCurr=1

     SET @dateNow=GETDATE()

    begin TRANSACTION 

    if CharIndex('#',@detailList,2)>0
    begin
         while (@PointerPrev+1 < LEN(@detailList))
         BEGIN
             if(@PointerCurr>0)
             BEGIN

               Set @PointerCurr=CharIndex('#',@detailList,@PointerPrev+1)

               set @detailLone=SUBSTRING(@detailList,@PointerPrev,@PointerCurr-@PointerPrev)
               SET @PointerPrev = @PointerCurr+1

               SET @DPointerPrev=1
                ------get @MaterialCode------------
               set @DPointerCurr=CharIndex(',',@detailLone,@DPointerPrev+1)
               SET @MaterialCode=SUBSTRING(@detailLone,@DPointerPrev,@DPointerCurr-@DPointerPrev)
               SET @DPointerPrev = @DPointerCurr
           ------end @MaterialCode-------------------------

              -- PRINT @detailLone
                ------get @UnitCode------------
                 PRINT @DPointerCurr
               set @DPointerCurr=CharIndex(',',@detailLone,@DPointerPrev+1)
                PRINT @DPointerCurr
               SET @UnitCode=SUBSTRING(@detailLone,@DPointerPrev+1,@DPointerCurr-@DPointerPrev-1)
               SET @DPointerPrev = @DPointerCurr
           ------end @UnitCode-------------------------

--               PRINT @DPointerPrev;
--               PRINT @MaterialCode;
--               PRINT @UnitCode;
             End
             ELSE
             begin
             BREAK
             end
         End
    END 

    if @@error=0
    begin
    commit transaction
    end
    else
    begin
    rollback transaction
    end
 END

---�����������
 SELECT @Result=COUNT(1) FROM dbo.ACT_SaleOrderMain WHERE ActOrd_ID LIKE '%ACT'+right(CONVERT(varchar(100), GETDATE(), 112),6)+'%'

        IF (@Result>0)
        BEGIN
            SELECT TOP 1 @dd=ActOrd_ID FROM dbo.ACT_SaleOrderMain WHERE ActOrd_ID LIKE '%ACT'+ right(CONVERT(varchar(100), GETDATE(), 112),6)+'%' ORDER BY ActOrd_ID DESC

            SET @ActOrd_ID = 'ACT' + right(CONVERT(varchar(100), GETDATE(), 112),6) +'-'+ right('00000'+cast(CONVERT(VARCHAR(50),CONVERT(FLOAT,RIGHT(@dd,5)) + 1) AS VARCHAR),5)
        END
        ELSE
        BEGIN
            SET @ActOrd_ID='ACT'+right(CONVERT(varchar(100), GETDATE(), 112),6)+'-00001';
        END

