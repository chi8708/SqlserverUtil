set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




---代金券发放
ALTER PROC [dbo].[P_Mall_VouchersList_Add]
	@orderSN varchar(30),
	@wxCode  VARCHAR(32)
AS
BEGIN
	DECLARE @orderMoney decimal(18,2)     --订单总金额
	DECLARE @orderMoneyCut decimal(18,2)  --订单总金额减去单品活动和提货卡的金额
	DECLARE @orderCreateDate DATETIME     --订单创建时间
	DECLARE @recId  INT                   --订单商品中间表ID
	DECLARE @voucherId  INT				  --活动ID
	DECLARE @CouponsMoney DECIMAL(18,2)	  --提货卡商品金额总和
	DECLARE @CouponsGoodsIds VARCHAR(1024) --提货卡商品Ids
	DECLARE @insertedIds varchar(1024)     --返回值
	DECLARE @isOrderMoneySubCoupons BIT	   --订单金额是否去除提货卡金额 1是 0否
	DECLARE @voucherMoney DECIMAL(18,2)	   --代金券金额
	
	SET @insertedIds=''
	SET @CouponsMoney=0
	SET @CouponsGoodsIds=''
	Set @isOrderMoneySubCoupons=1
	SET @voucherMoney=0
	
	SELECT TOP 1 @orderMoney=moi.Goods_amount,@orderCreateDate=moi.CreateDate FROM Mall_OrderInfo AS moi 
	WHERE moi.Order_SN=@orderSN;
	SET @orderMoneyCut=@orderMoney
	
	IF @isOrderMoneySubCoupons=1
	BEGIN
	  --活动金额减去 提货卡金额
		SELECT @CouponsMoney=@CouponsMoney+mg.salePrice,@CouponsGoodsIds=@CouponsGoodsIds+mg.Goods_ID+','
		FROM Mall_Goods AS mg,
		(SELECT mc.goodsid FROM dbo.Mall_goodsCode AS mc WHERE charindex(','+mc.goodscode+',',
		(SELECT TOP 1 ','+moi.CouponsSN+',' FROM Mall_OrderInfo AS moi WHERE moi.Order_SN=@orderSN))>0) mv
		WHERE mg.Goods_ID=mv.goodsid
	    
		IF @CouponsMoney IS NOT NULL AND @CouponsMoney>0
		BEGIN
		   SET @orderMoneyCut=@orderMoneyCut-@CouponsMoney
		   SET @orderMoney=@orderMoneyCut
		END
	END
	
	--将该订单所有商品放入#tempOrderGoods 临时表
	IF OBJECT_ID('tempdb.dbo.#tempOrderGoods','U') IS NOT NULL DROP TABLE dbo.#tempOrderGoods
	SELECT * INTO #tempOrderGoods FROM Mall_Order_Goods AS mog WHERE 
	mog.Order_SN=@orderSN ORDER BY mog.Rec_ID
	
	--将此时间所有代金劵活动放入#tempVoucher 临时表
	IF OBJECT_ID('tempdb.dbo.#tempVoucher','U') IS NOT NULL DROP TABLE dbo.#tempVoucher
	SELECT * INTO #tempVoucher FROM Mall_Vouchers AS mv
	WHERE mv.ActiveType=1 AND mv.[Status]<>1 AND mv.GiveNum<mv.VouchersNum AND
	(@orderCreateDate>=mv.GiveStartDate AND @orderCreateDate<=mv.GiveEndDate)
	--SELECT * FROM Mall_Vouchers AS tv WHERE tv.GiveGoodsList

	---插入[Mall_VouchersList] sql
	DECLARE @insertSql NVARCHAR(1024)
	SET @insertSql= N'INSERT INTO [Mall_VouchersList]([VoucherID],[GiveOrderID],[WxID],[CreateDate],[GiveMoney],[IsDel])
		VALUES(@voucherId,@orderSN,@wxCode,GETDATE(),@voucherMoney,0)
		select @insertedIds=@insertedIds+CAST(SCOPE_IDENTITY() AS NVARCHAR(16))+'',''
		UPDATE Mall_Vouchers SET GiveNum=GiveNum+1 WHERE ID=@voucherId
		UPDATE #tempVoucher SET GiveNum=GiveNum+1  WHERE ID=@voucherId'
	--遍历订单商品 --单品活动送代金券
	WHILE EXISTS(SELECT rec_Id FROM #tempOrderGoods)
	BEGIN
		DECLARE @goodsId VARCHAR(10)
		DECLARE @orderGoodsMoney DECIMAL(18,2)
		SET @voucherMoney=0
		SET @orderGoodsMoney=0
		SET  @voucherId=0
		
		SET ROWCOUNT 1
		SELECT @recId=Rec_ID,@goodsId=Goods_ID,@orderGoodsMoney=Amount FROM #tempOrderGoods
		SET ROWCOUNT 0
		
		--检查是否符合单品发代金券
		SELECT TOP 1 @voucherId=tv.ID,@voucherMoney=FLOOR(RAND()*(tv.MaxMoney-tv.MinMoney)+tv.MinMoney) FROM #tempVoucher tv 
		WHERE tv.[Type]=1 AND tv.GiveNum<tv.VouchersNum AND charindex(','+@goodsId+',',','+tv.GiveGoodsList+',')>0
		
		IF @voucherId IS NOT NULL AND @voucherId<>0                          
		BEGIN
			--订单金额减 已参加单品活动的单品金额
			EXEC sys.sp_executesql @insertSql,N'@voucherId int ,@orderSN varchar(32),@wxCode varchar(32) ,@voucherMoney decimal(18,2),@insertedIds varchar(1024) OUT'
			,@voucherId,@orderSN,@wxCode,@voucherMoney,@insertedIds OUTPUT
			--SET @insertedIds=@insertedIds+CAST(SCOPE_IDENTITY() AS NVARCHAR(16))+'',''
			IF @isOrderMoneySubCoupons=1
			BEGIN
				IF CHARINDEX(','+@goodsId+',',','+@CouponsGoodsIds)<=0
				BEGIN
					set @orderMoneyCut=@orderMoneyCut-@orderGoodsMoney	
				END
			END
			ELSE
			BEGIN
				set @orderMoneyCut=@orderMoneyCut-@orderGoodsMoney			
			END

		END
		PRINT @orderMoneyCut
		DELETE FROM dbo.#tempOrderGoods WHERE rec_ID=@recId;
	END
	
	SET @voucherId=0;
	DECLARE @isOrderActive BIT;
	SET @isOrderActive=0;

	---获取该时间订单活动送代金券 单品活动重复
	SELECT TOP 1 @voucherId=tv.ID,@voucherMoney=FLOOR(RAND()*(tv.MaxMoney-tv.MinMoney)+tv.MinMoney)
	FROM #tempVoucher tv WHERE tv.[Type]=2 AND (@orderMoney>=tv.GiveMoney AND @orderMoney<tv.GiveMaxMoney)
	AND tv.IsRepeatUse=1 AND tv.GiveNum<tv.VouchersNum
	IF @voucherId IS NOT NULL AND @voucherId<>0
	BEGIN
		EXEC sys.sp_executesql @insertSql,N'@voucherId int ,@orderSN varchar(32),@wxCode varchar(32) ,@voucherMoney decimal(18,2),@insertedIds varchar(1024) OUT'
			,@voucherId,@orderSN,@wxCode,@voucherMoney,@insertedIds OUTPUT
		set @isOrderActive=1;
	END
	
	---获取该时间订单活动送代金券 单品活动不重复
	IF @isOrderActive=0
	BEGIN
		SELECT TOP 1 @voucherId=tv.ID,@voucherMoney=FLOOR(RAND()*(tv.MaxMoney-tv.MinMoney)+tv.MinMoney) 
		FROM #tempVoucher tv WHERE tv.[Type]=2 AND (@orderMoneyCut>=tv.GiveMoney AND @orderMoneyCut<tv.GiveMaxMoney)
		AND tv.IsRepeatUse=0 AND tv.GiveNum<tv.VouchersNum
		IF @voucherId IS NOT NULL AND @voucherId<>0
		BEGIN
			EXEC sys.sp_executesql @insertSql,N'@voucherId int ,@orderSN varchar(32),@wxCode varchar(32) ,@voucherMoney decimal(18,2),@insertedIds varchar(1024) OUT'
			,@voucherId,@orderSN,@wxCode,@voucherMoney,@insertedIds OUTPUT
		END
	END
	
	DELETE FROM #tempVoucher
	
	PRINT @insertedIds
    SELECT * FROM Mall_VouchersList AS mv WHERE CHARINDEX(','+cast(mv.ID AS VARCHAR(16))+',',','+@insertedIds)>0
END




