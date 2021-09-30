
---创建用户 制定数据库
USE master
 
CREATE LOGIN test --要创建的用户名
 
WITH PASSWORD = '123456', --密码
 
     DEFAULT_DATABASE = DBTest, --指定数据库
 
     CHECK_EXPIRATION = OFF,
 
     CHECK_POLICY = OFF
 
go
 
 
REVOKE VIEW ANY DATABASE TO [public]
 
 制定数据库
USE DBTest --数据库
go
EXEC dbo.sp_changedbowner N'test'