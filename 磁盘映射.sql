--
exec master..xp_cmdshell 'net use z: \\192.168.0.1\I$ Testpwd /USER:192.168.0.1\administrator' 
 --password是备份目标机器登录用户的密码，最好是拥有管理员权限的用户

--exec master..xp_cmdshell 'net use Z: /delete'


--192.168.0.1 Testpwd

---- 以上执行报错SQL Server 阻止了对组件“xp_cmdshell”的 过程“sys.xp_cmdshell”的访问，因为此组件已作为此服务器安全配置的一部分而被关闭
sp_configure 'show advanced options',1  -- 开启高级选项
reconfigure  -- 安装
go
sp_configure 'xp_cmdshell',1
reconfigure
go