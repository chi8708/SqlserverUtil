---CTE递归 查询多级所有子项
with f as 
(
select * FROM Pub_FeeSort where id=222
union all
select a.* from Pub_FeeSort as a inner join f as b on a.parentNode=b.id
)
select * from f