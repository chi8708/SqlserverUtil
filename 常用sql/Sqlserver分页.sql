CREATE Procedure [dbo].[P_ZGrid_PagingLarge]
@TableName varchar(50),         --���� 
@Fields varchar(4000) = '*',     --�ֶ���(ȫ���ֶ�Ϊ*) 
@OrderField varchar(200),         --�����ֶ�(����!֧�ֶ��ֶ�) 
@sqlWhere varchar(8000) = Null,--�������(���ü�where) 
@pageSize int,                     --ÿҳ��������¼ 
@pageIndex int = 1 ,             --ָ����ǰΪ�ڼ�ҳ 
@TotalPage int output ,            --������ҳ�� 
@Totalrow int output             --����������
As 
begin 
     Declare @sql nvarchar(4000); 
     Declare @totalRecord int;

    --return

     --�����ܼ�¼��
         
     if (@SqlWhere='' or @sqlWhere=NULL) 
         set @sql = 'select @totalRecord = count(*) from ' + @TableName 
     else 
         set @sql = 'select @totalRecord = count(*) from ' + @TableName + ' where ' + @sqlWhere 

     EXEC sp_executesql @sql,N'@totalRecord int OUTPUT',@totalRecord OUTPUT--�����ܼ�¼�� 
     set @Totalrow=@totalRecord        
     
     --������ҳ�� 
     select @TotalPage=CEILING((@totalRecord+0.0)/@PageSize) 

     if (@SqlWhere='' or @sqlWhere=NULL) 
         set @sql = 'Select * FROM (select ROW_NUMBER() Over(order by ' + @OrderField + ') as rowId,' + @Fields + ' from ' + @TableName 
     else 
         set @sql = 'Select * FROM (select ROW_NUMBER() Over(order by ' + @OrderField + ') as rowId,' + @Fields + ' from ' + @TableName + ' where ' + @SqlWhere     
         
     --����ҳ��������Χ��� 
     if @PageIndex<=0 
         Set @pageIndex = 1 
     
     if @pageIndex>@TotalPage 
         Set @pageIndex = @TotalPage

     --����ʼ��ͽ����� 
     Declare @StartRecord int 
     Declare @EndRecord int 
     
     set @StartRecord = (@pageIndex-1)*@PageSize + 1 
     set @EndRecord = @StartRecord + @pageSize - 1 

     --�����ϳ�sql��� 
     set @Sql = @Sql + ') as ' + @TableName + ' where rowId between ' + Convert(varchar(50),@StartRecord) + ' and ' + Convert(varchar(50),@EndRecord) 
     
   -- insert into dbo.ASQLprocess (SQLstring)values(@Sql)

     Exec(@Sql) 
end