--����ʱ��ֵ
declare tempcursor cursor for 
select AU_LoginId  from AdminUser

--open tempcursor
--declare @loginId varchar(30)
--fetch next from tempcursor into @loginId
--print @loginId
--close tempcursor

open tempcursor
declare @loginId varchar(30)
while @@FETCH_STATUS=0
begin
print @loginId
fetch next from tempcursor into @loginId
end

close tempcursor


--fetch: ��ȡ����first, last ,prior ������ֻ���α�һ��ʹ�á�

---�ͷ��α�
deallocate tempcursor


---�����ֵ
declare @testcursor cursor
set @testcursor=cursor for
select * from AdminUser