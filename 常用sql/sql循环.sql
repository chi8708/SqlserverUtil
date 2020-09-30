
  EXEC P_Settlement20200928 'SETT200927FR017101'

    DECLARE @i INT
    SET @i=0
    DECLARE @settlementMainID VARCHAR(30)
   
    
	---游标 少于1000行性能可以
    DECLARE curMoveMat CURSOR FOR
	SELECT B.settlementMainID
	  FROM dbo.Core_SettlementFrSub A LEFT OUTER JOIN dbo.Core_SettlementFrMain B ON A.settlementMainID=B.settlementMainID
	WHERE A.settlementMainID IN 
	(
	 SELECT settlementMainID FROM dbo.Core_SettlementFrMain WHERE settlementYear=2020 AND settlementMonth=9 AND WHCode LIKE 'FR01%' AND Status=1
	) AND A.sort=3 AND A.backQTY>0 AND A.RevNO=4

	OPEN curMoveMat
	FETCH NEXT FROM curMoveMat INTO @settlementMainID WHILE @@FETCH_STATUS = 0
	BEGIN
		
		Exec P_Settlement20200928 @settlementMainID
		FETCH NEXT FROM curMoveMat INTO @settlementMainID
										
	END
	CLOSE curMoveMat
	DEALLOCATE curMoveMat
	

	---while 推荐使用
	DECLARE @recId  INT         
	IF  OBJECT_ID(N'tempdb..#tempOrderGoods',N'U') IS NOT NULL DROP TABLE dbo.#tempOrderGoods
	SELECT * INTO #tempOrderGoods FROM Mall_Order_Goods AS mog WHERE 
	mog.Order_SN=@orderSN ORDER BY mog.Rec_ID
		
    WHILE EXISTS(SELECT rec_Id FROM #tempOrderGoods)
	BEGIN
		
		SET ROWCOUNT 1
		SELECT @recId=Rec_ID  FROM #tempOrderGoods
		SET ROWCOUNT 0
	
		DELETE FROM dbo.#tempOrderGoods WHERE rec_ID=@recId;
	END