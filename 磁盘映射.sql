--
exec master..xp_cmdshell 'net use z: \\192.168.0.1\I$ Testpwd /USER:192.168.0.1\administrator' 
 --password是备份目标机器登录用户的密码，最好是拥有管理员权限的用户

--exec master..xp_cmdshell 'net use Z: /delete'


--192.168.0.1 Testpwd