
---sql获取逗号分隔内容
       DECLARE @detailLone VARCHAR(2000),@DPointerPrev INT,@DPointerCurr INT
       DECLARE @MaterialCode VARCHAR(200),@UnitCode VARCHAR(200)
       SET @detailLone='1212,1234,123232,'
       Set @DPointerPrev=1
       SET @DPointerCurr=1
           if CharIndex(',',@detailLone,2)>0
           begin
           ------get @MaterialCode------------
           set @DPointerCurr=CharIndex(',',@detailLone,@DPointerPrev+1)
           PRINT @DPointerPrev
           SET @MaterialCode=SUBSTRING(@detailLone,@DPointerPrev,@DPointerCurr-@DPointerPrev)
           SET @DPointerPrev = @DPointerCurr
           PRINT @DPointerPrev
           PRINT @MaterialCode
           ------end @MaterialCode-------------------------

            ------get @UnitCode------------
           set @DPointerCurr=CharIndex(',',@detailLone,@DPointerPrev+1)
           SET @UnitCode=SUBSTRING(@detailLone,@DPointerPrev+1,@DPointerCurr-@DPointerPrev-1)
           SET @DPointerPrev = @DPointerCurr
           PRINT @UnitCode
           ------get @UnitCode------------

            ------get @Last------------
           set @DPointerCurr=CharIndex(',',@detailLone,@DPointerPrev+1)
           set @UnitCode=SUBSTRING(@detailLone,@DPointerPrev+1,@DPointerCurr-@DPointerPrev-1)
           SET @DPointerPrev = @DPointerCurr
           PRINT @UnitCode
           PRINT @DPointerCurr
           ------get @Last------------
           end

 ---遍历，分隔的内容
       DECLARE @detailLone VARCHAR(2000),@DPointerPrev INT,@DPointerCurr INT
       DECLARE @FunctionCode VARCHAR(200)
       SET @detailLone='1212,1234,123232,'
       Set @DPointerPrev=1
       SET @DPointerCurr=1
        while (@DPointerPrev+1 < LEN(@detailLone))
         Begin
             Set @DPointerCurr=CharIndex(',',@detailLone,@DPointerPrev+1)
             PRINT @DPointerCurr
             if(@DPointerCurr>0)
             Begin
             set @FunctionCode=SUBSTRING(@detailLone,@DPointerPrev+1,@DPointerCurr-@DPointerPrev-1)
             SET @DPointerPrev = @DPointerCurr
             PRINT @FunctionCode
             END
         End



 ---遍历，分隔的内容 N'12,34ss,#56发放,78升水,#'
alter PROCEDURE [dbo].[P_SendGoodsInStorage]
  @detailList varchar(8000) --出库明细 遍历
AS
BEGIN
     DECLARE @SendGoodItemId BIGINT --发货子表Id
     DECLARE @dateNow DATETIME
     DECLARE @PointerPrev int
     DECLARE @PointerCurr INT
     DECLARE @DPointerPrev int
     DECLARE @DPointerCurr int
     DECLARE @detailLone varchar(500)
     DECLARE @MaterialCode VARCHAR(10)
     DECLARE @UnitCode VARCHAR(20)
     Set @PointerPrev=1
     set @PointerCurr=1

     SET @dateNow=GETDATE()


      --inser into main-----------------------

--        Insert into dbo.Pub_StorageMain (MainId,MainType,BTypeCode,MainDate,OperatorCode,Editor,EditorDate,Remark,StorageCodeIn) 
--        Values(@MainId,'出库',@BTypeCode,@MainDate,@OperatorCode,@UserCode,@dateNow,@Remark,@StorageCode)
   --------------end inser into main-----------------------
    begin TRANSACTION 

    if CharIndex('#',@detailList,2)>0
    begin
         while (@PointerPrev+1 < LEN(@detailList))
         BEGIN
             if(@PointerCurr>0)
             BEGIN

               Set @PointerCurr=CharIndex('#',@detailList,@PointerPrev+1)

               set @detailLone=SUBSTRING(@detailList,@PointerPrev,@PointerCurr-@PointerPrev)
               SET @PointerPrev = @PointerCurr+1

               SET @DPointerPrev=1
                ------get @MaterialCode------------
               set @DPointerCurr=CharIndex(',',@detailLone,@DPointerPrev+1)
               SET @MaterialCode=SUBSTRING(@detailLone,@DPointerPrev,@DPointerCurr-@DPointerPrev)
               SET @DPointerPrev = @DPointerCurr
           ------end @MaterialCode-------------------------

              -- PRINT @detailLone
                ------get @UnitCode------------
                 PRINT @DPointerCurr
               set @DPointerCurr=CharIndex(',',@detailLone,@DPointerPrev+1)
                PRINT @DPointerCurr
               SET @UnitCode=SUBSTRING(@detailLone,@DPointerPrev+1,@DPointerCurr-@DPointerPrev-1)
               SET @DPointerPrev = @DPointerCurr
           ------end @UnitCode-------------------------

--               PRINT @DPointerPrev;
--               PRINT @MaterialCode;
--               PRINT @UnitCode;
             End
             ELSE
             begin
             BREAK
             end
         End
    END 

    if @@error=0
    begin
    commit transaction
    end
    else
    begin
    rollback transaction
    end
 END