----中奖概率 1/10
SELECT CAST(CEILING(RAND()*10) AS INT)



--奖品表
CREATE TABLE [dbo].[ac_prize_Goods_200226](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Grade] [int] NOT NULL,
	[code] [varchar](50) NULL,
	[GoodsName] [nvarchar](50) NULL,
	[Price] [decimal](18, 2) NULL,
	[TotalNum] [decimal](18, 0) NULL,
	[SurplusNum] [decimal](18, 0) NULL,
	[Pic] [varchar](500) NULL,
	[type] [int] NULL,
	[activ] [int] NULL,
	[SurplusNum2] [int] NULL,
	[SetCode] [varchar](50) NULL,
	[IsPost] [bit] NULL,
 CONSTRAINT [PK_ac_prize_Goods_200226] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

--记录表
CREATE TABLE [dbo].[ac_prize_record_200226](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[wxcode] [varchar](50) NULL,
	[goodsid] [varchar](50) NULL,
	[pname] [varchar](50) NULL,
	[issend] [int] NULL,
	[senddate] [datetime] NULL,
	[amount] [decimal](18, 2) NULL,
	[creattime] [datetime] NULL,
	[types] [int] NULL,
	[num] [int] NULL,
	[eid] [int] NULL,
	[SetCode] [varchar](50) NULL,
	[Score] [int] NULL,
	[PostMan] [nvarchar](10) NULL,
	[PostTel] [nvarchar](20) NULL,
	[PostAddress] [nvarchar](50) NULL,
	[IsPost] [bit] NULL,
	[source] [smallint] NULL,
 CONSTRAINT [PK_ac_prize_record_200226] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO





ALTER  PROCEDURE [dbo].[get_prize_200226]
   @eid INT,
   @ordercode VARCHAR(50),
   @bm VARCHAR(50),
   @score INT,
   @source SMALLINT
AS
BEGIN
SET NOCOUNT ON;
	declare @zjp int --总奖品数
	declare @midle int--中间变量
	declare @randmidle int --随机数
	declare @grade int  --奖品等级
	declare @goodsname varchar(50) --奖品名称
	declare @backgrade int  --奖品等级
	declare @backgoodsname varchar(50)
	declare @id int
	declare @num int --当前等级数量
	DECLARE @code VARCHAR(20)--奖品编号
	DECLARE @micode VARCHAR(20)
	DECLARE @amount DECIMAL(18,2)
	DECLARE @amount1 DECIMAL(18,2)
	
	DECLARE @activeCode VARCHAR(50)
	DECLARE @startTime DATETIME
	DECLARE @endTime DATETIME
	--初始化
	set @zjp=0
	set @midle=0
	set @randmidle=0
	set @grade=0
	set @goodsname=''
	set @id=0
	set @backgrade=0--返回等级
	set @backgoodsname=''--返回奖品名称
	set @num=0--奖品数量
	SET @code=''
	SET @micode=''
	SET @backgoodsname=''
	
	  
  IF EXISTS(SELECT 1 FROM  [dbo].[ac_prize_record_200226] WHERE eid=@eid  AND setCode=@bm)
   BEGIN
   		select '-1' AS ret, '你已参加过活动！' as msg,''  as goodsname, '' as  goodscode
		return
   END
   
   SELECT TOP 1 @activeCode=activeCode,@startTime=StartTime,@endTime=EndTime FROM ac_prize_set_200226 WHERE code=@bm
	

	
	select @zjp=sum(totalnum-surplusnum) from ac_prize_Goods_200226 where activ>=1 AND setCode=@bm --查询总奖品
	select @randmidle=cast(ceiling(rand() * @zjp) as int)--生成随机数
	if @zjp<= 0 --奖品抽完
	BEGIN
	    INSERT INTO ac_prize_record_200226(wxcode,[types],goodsid,pname,issend,amount,eid,setCode,score,isPost,creattime,[source]) 
			  SELECT '',1,'009','谢谢参与',0,Price,@eid,@bm,@score,isPost,GETDATE(),@source FROM ac_prize_Goods_200226 WHERE id =9
		
	    select '1' AS ret, '成功' as msg ,1 grade,'谢谢参与' goodsname,'009' AS goodscode
		return
	END	

	DECLARE @flag int;
	SET @flag = 0
    DECLARE @openid VARCHAR(50)

	---declare auth_cur cursor for--定义游标
	DECLARE @tabel TABLE (rowids int,id int,grade int,goodsname NVARCHAR(50),synumber int,code VARCHAR(50),Price DECIMAL(18,2)) 
	INSERT INTO @tabel (rowids,id,grade,goodsname,synumber,code,Price)
	SELECT  ROW_NUMBER() over(order by id) as rowids, id,grade,goodsname,totalnum-surplusnum,code,Price from ac_prize_Goods_200226 
	where  activ>=1 AND (totalnum-surplusnum) > 0 AND setCode=@bm 
	
	DECLARE @rowcont INT,@ii INT 
	SET @ii=0
    SELECT @rowcont=COUNT(1) FROM @tabel
    WHILE(@ii<@rowcont)
	 BEGIN
	 	
		   SET @ii=@ii+1
		   SELECT  @id=id,@grade=grade,@goodsname=goodsname,@num=synumber,@code=code,@amount=Price FROM @tabel WHERE rowids=@ii
		   if (@randmidle>=@midle and @randmidle<=@midle+@num)
		   begin 
			  set @backgrade=@grade
			  set @backgoodsname=@goodsname
			  set @micode=@code
			  set @amount1=@amount
			  
			  IF EXISTS(SELECT 1 FROM  [dbo].[ac_prize_record_200226] WHERE eid=@eid AND setCode=@bm )
			   BEGIN
   					select '-1' AS ret, '你的抽奖资格已使用！' as msg,''  as goodsname, '' as  goodscode
					return
			   END
			  
			  INSERT INTO ac_prize_record_200226(wxcode,[types],goodsid,pname,issend,amount,eid,setCode,score,isPost,creattime,[source]) 
			  SELECT '',1,@micode,@goodsname,0,Price,@eid,@bm,@score,isPost,GETDATE(),@source FROM ac_prize_Goods_200226 WHERE id = @id 
		  
			  update ac_prize_Goods_200226 set surplusnum=surplusnum+1 where id=@id AND setCode=@bm
			  
			  break
		   end
			set @midle=@midle+@num
   
  	      
	 END
	select '1' AS ret, '成功' as msg ,@backgrade grade,@backgoodsname goodsname,@micode AS goodscode

END






