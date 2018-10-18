--定义时赋值
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


--fetch: 提取类型first, last ,prior 不能与只进游标一起使用。

---释放游标
deallocate tempcursor


---定义后赋值
declare @testcursor cursor
set @testcursor=cursor for
select * from AdminUser