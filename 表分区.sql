
------创建数据库文件组
alter database ElectronicCoupons20200812 add filegroup CustomerGroup1
alter database ElectronicCoupons20200812 add filegroup CustomerGroup2
alter database ElectronicCoupons20200812 add filegroup CustomerGroup3
alter database ElectronicCoupons20200812 add filegroup CustomerGroup4

alter database ElectronicCoupons20200812 add filegroup AddressGroup1
alter database ElectronicCoupons20200812 add filegroup AddressGroup2
alter database ElectronicCoupons20200812 add filegroup AddressGroup3
alter database ElectronicCoupons20200812 add filegroup AddressGroup4
alter database ElectronicCoupons20200812 add filegroup AddressGroup5
alter database ElectronicCoupons20200812 add filegroup AddressGroup6
alter database ElectronicCoupons20200812 add filegroup AddressGroup7



---创建文件
alter database ElectronicCoupons20200812 add file 
(name=N'CustomerFile1',filename=N'I:\ElectronicCoupons20200812\CustomerFile1.ndf',size=5Mb,filegrowth=5mb)
to filegroup CustomerGroup1
alter database ElectronicCoupons20200812 add file 
(name=N'CustomerFile2',filename=N'I:\ElectronicCoupons20200812\CustomerFile2.ndf',size=5Mb,filegrowth=5mb)
to filegroup CustomerGroup2
alter database ElectronicCoupons20200812 add file 
(name=N'CustomerFile3',filename=N'I:\ElectronicCoupons20200812\CustomerFile3.ndf',size=5Mb,filegrowth=5mb)
to filegroup CustomerGroup3
alter database ElectronicCoupons20200812 add file 
(name=N'CustomerFile4',filename=N'I:\ElectronicCoupons20200812\CustomerFile4.ndf',size=5Mb,filegrowth=5mb)
to filegroup CustomerGroup4

alter database ElectronicCoupons20200812 add file 
(name=N'AddressFile1',filename=N'I:\ElectronicCoupons20200812\AddressFile1.ndf',size=5Mb,filegrowth=5mb)
to filegroup AddressGroup1
alter database ElectronicCoupons20200812 add file 
(name=N'AddressFile2',filename=N'I:\ElectronicCoupons20200812\AddressFile2.ndf',size=5Mb,filegrowth=5mb)
to filegroup AddressGroup2
alter database ElectronicCoupons20200812 add file 
(name=N'AddressFile3',filename=N'I:\ElectronicCoupons20200812\AddressFile3.ndf',size=5Mb,filegrowth=5mb)
to filegroup AddressGroup3
alter database ElectronicCoupons20200812 add file 
(name=N'AddressFile4',filename=N'I:\ElectronicCoupons20200812\AddressFile4.ndf',size=5Mb,filegrowth=5mb)
to filegroup AddressGroup4
alter database ElectronicCoupons20200812 add file 
(name=N'AddressFile5',filename=N'I:\ElectronicCoupons20200812\AddressFile5.ndf',size=5Mb,filegrowth=5mb)
to filegroup AddressGroup5
alter database ElectronicCoupons20200812 add file 
(name=N'AddressFile6',filename=N'I:\ElectronicCoupons20200812\AddressFile6.ndf',size=5Mb,filegrowth=5mb)
to filegroup AddressGroup6
alter database ElectronicCoupons20200812 add file 
(name=N'AddressFile7',filename=N'I:\ElectronicCoupons20200812\AddressFile7.ndf',size=5Mb,filegrowth=5mb)
to filegroup AddressGroup7




---customerInfo
--创建分区函数
CREATE   PARTITION FUNCTION [customerPF](INT) AS 
 RANGE LEFT
FOR VALUES (2000000,4000000,6000000)

--创建分区方案
CREATE PARTITION SCHEME customerPS AS PARTITION [customerPF]
TO ([CustomerGroup1], [CustomerGroup2],[CustomerGroup3], [CustomerGroup4])


--删除主键索引
alter table ElcCustomerinfo drop constraint PK_ElcCustomerinfo WITH ( ONLINE = OFF );
--DROP INDEX PK_ElcCustomerinfo ON [dbo].[ElcCustomerinfo] WITH ( ONLINE = OFF )


--创建分区索引
CREATE CLUSTERED INDEX [I_EId_CustomerP] ON ElcCustomerinfo
(
	EId
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [customerPS]([EId])


--添加主键
ALTER TABLE ElcCustomerinfo
ADD CONSTRAINT PK_ElcCustomerinfo PRIMARY KEY (EId);



---customerAddress --分区索引必须是聚集索引。若不是主键分区， 修改主键为非聚集索引
--创建分区函数
CREATE   PARTITION FUNCTION [addressPF](INT) AS 
 RANGE LEFT
FOR VALUES (1000000,2000000,3000000,4000000,5000000,6000000)

--创建分区方案
CREATE PARTITION SCHEME addressPS AS PARTITION [addressPF]
TO ([addressGroup1], [addressGroup2],[addressGroup3], [addressGroup4], [addressGroup5], [addressGroup6], [addressGroup7])

-- 删除全文索引
--DROP FULLTEXT INDEX ON ElcCustomerAddress
--删除主键索引
--ALTER TABLE ElcCustomerAddress drop constraint PK_ElcCustomerAddress WITH ( ONLINE = OFF );


BEGIN TRANSACTION

ALTER TABLE [dbo].[ElcCustomerAddress] DROP CONSTRAINT [PK_ElcCustomerAddress]

ALTER TABLE [dbo].[ElcCustomerAddress] ADD  CONSTRAINT [PK_ElcCustomerAddress] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [ELCdata9]


CREATE CLUSTERED INDEX I_EId_AddressP ON [dbo].[ElcCustomerAddress]
(
	[CustomerId]
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [addressPS]([CustomerId])

COMMIT TRANSACTION




---https://www.cnblogs.com/knowledgesea/p/3696912.html