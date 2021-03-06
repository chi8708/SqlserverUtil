USE [test]
GO
/****** 对象:  StoredProcedure [dbo].[sp_job_LoadPorc]    脚本日期: 01/18/2017 14:07:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_job_LoadPorc]
@command     nvarchar(4000),         --异步调用的存储过程或者要执行的 Transact-SQL 语句
@DatabaseName sysname=NULL,        --在那个数据库中执行作业步骤,默认在当前数据库中
@jobdelay      int=5,                --当前时间后的多少秒钟执行,该值大于等于5
@jobid        uniqueidentifier OUTPUT --定义的作业编号
AS
--作业名称,作业的执行时间
DECLARE @jobname sysname,@time int
SELECT @jobname=N'临时作业'
		+N'_'+LEFT(HOST_NAME(),40)
		+N'_'+CONVERT(char(19),GETDATE(),120)
		+N'_'+CAST(NEWID() as varchar(36)),
	@jobdelay=CASE 
		WHEN ISNULL(@jobdelay,0)<5 THEN 5
		ELSE @jobdelay+1 END,
	@time=REPLACE(CONVERT(char(8),
		DATEADD(Second,@jobdelay,GETDATE()),
		108),':','')

--数据库名
IF DB_ID(@DatabaseName) IS NULL
	SET @DatabaseName=DB_NAME()

--检查是否存在同名作业,存在则删除
IF EXISTS(SELECT * FROM msdb.dbo.sysjobs WHERE name=@jobname)
	EXEC msdb..sp_delete_job @job_name=@jobname 

--定义作业
EXEC msdb.dbo.sp_add_job
	@job_name = @jobname,
	@delete_level =3,           --作业执行后自动删除
	@job_id = @jobid OUTPUT

--定义作业步骤
EXEC msdb.dbo.sp_add_jobstep
	@job_id = @jobid,
	@step_name = N'异步调用存储过程或者执行Transact-SQL 语句',
	@subsystem = 'TSQL',
	@database_name=@DatabaseName,
	@command = @command

--创建调度
EXEC msdb..sp_add_jobschedule
	@job_id = @jobid,
	@name = N'异步调用存储过程或者执行Transact-SQL 语句',
	@freq_type=1,
	@active_start_time = @time

--添加目标服务器
DECLARE @servername sysname
SET @servername=CONVERT(nvarchar(128),SERVERPROPERTY(N'ServerName'))
EXEC msdb.dbo.sp_add_jobserver 
	@job_id = @jobid,
	@server_name = @servername