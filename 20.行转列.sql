
CREATE TABLE CJ
(
	Id INT PRIMARY KEY IDENTITY(1,1), --主键
	NZ VARCHAR(50),	 --姓名
	KM VARCHAR(50),  --科目
	CJ INT,	         --成绩
	CJSJ DATETIME    --时间
)

insert into CJ  (NZ,KM,CJ,CJSJ) VALUES ('大明','语文',100,getdate()) 
insert into CJ  (NZ,KM,CJ,CJSJ) VALUES ('大明','数学',90,getdate())
insert into CJ  (NZ,KM,CJ,CJSJ) VALUES ('大明','英语',80,getdate())
insert into CJ  (NZ,KM,CJ,CJSJ) VALUES ('大明','生物',70,getdate())
insert into CJ  (NZ,KM,CJ,CJSJ) VALUES ('大明','物理',60,getdate())

insert into CJ  (NZ,KM,CJ,CJSJ) VALUES ('小明','语文',50,getdate()) 
insert into CJ  (NZ,KM,CJ,CJSJ) VALUES ('小明','数学',60,getdate())
insert into CJ  (NZ,KM,CJ,CJSJ) VALUES ('小明','英语',70,getdate())
insert into CJ  (NZ,KM,CJ,CJSJ) VALUES ('小明','生物',80,getdate())
insert into CJ  (NZ,KM,CJ,CJSJ) VALUES ('小明','物理',60,getdate())


方式1
SELECT  NZ '姓名',
MAX(CASE KM WHEN '语文' then CJ ELSE 0 END) '语文',
MAX(CASE KM WHEN '数学' then CJ ELSE 0 END) '数学',
MAX(CASE KM WHEN '数学' then CJ ELSE 0 END) '数学',
MAX(CASE KM WHEN '生物' then CJ ELSE 0 END) '生物',
MAX(CASE KM WHEN '物理' then CJ ELSE 0 END) '物理'
FROM CJ
GROUP BY NZ

方式2 推荐
SELECT * FROM
(
	SELECT 姓名=NZ,科目=KM,成绩=CJ 
	FROM CJ
) A  
PIVOT 
(
	MAX(A.成绩) FOR A.科目 IN (语文,数学,英语,生物,物理)
) P
