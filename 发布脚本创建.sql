-- ���ø������ݿ�
use master
exec sp_replicationdboption @dbname = N'CNet', @optname = N'publish', @value = N'true'
GO

exec [CNet].sys.sp_addlogreader_agent @job_login = null, @job_password = null, @publisher_security_mode = 1
GO
exec [CNet].sys.sp_addqreader_agent @job_login = null, @job_password = null, @frompublisher = 1
GO
-- ������񷢲�
use [CNet]
exec sp_addpublication @publication = N'CNetPub', @description = N'���Է�����������HP�������ݿ⡰CNet�������񷢲���'
, @sync_method = N'concurrent', @retention = 0, @allow_push = N'true', @allow_pull = N'true', @allow_anonymous = N'true',
 @enabled_for_internet = N'false', @snapshot_in_defaultfolder = N'true', @compress_snapshot = N'false', @ftp_port = 21,
 @ftp_login = N'anonymous', @allow_subscription_copy = N'false', @add_to_active_directory = N'false', @repl_freq = N'continuous',
 @status = N'active', @independent_agent = N'true', @immediate_sync = N'true', @allow_sync_tran = N'false', @autogen_sync_procs = N'false', 
 @allow_queued_tran = N'false', @allow_dts = N'false', @replicate_ddl = 1, @allow_initialize_from_backup = N'false',
 @enabled_for_p2p = N'false',
 @enabled_for_het_sub = N'false'
GO
---Ȼ��鿴����״̬ ���ÿ��ա���ʼ�������ļ�