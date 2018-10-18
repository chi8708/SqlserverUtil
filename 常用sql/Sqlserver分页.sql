CREATE Procedure [dbo].[P_ZGrid_PagingLarge]
@TableName varchar(50),         --表名 
@Fields varchar(4000) = '*',     --字段名(全部字段为*) 
@OrderField varchar(200),         --排序字段(必须!支持多字段) 
@sqlWhere varchar(8000) = Null,--条件语句(不用加where) 
@pageSize int,                     --每页多少条记录 
@pageIndex int = 1 ,             --指定当前为第几页 
@TotalPage int output ,            --返回总页数 
@Totalrow int output             --返回总行数
As 
begin 
     Declare @sql nvarchar(4000); 
     Declare @totalRecord int;

    --return

     --计算总记录数
         
     if (@SqlWhere='' or @sqlWhere=NULL) 
         set @sql = 'select @totalRecord = count(*) from ' + @TableName 
     else 
         set @sql = 'select @totalRecord = count(*) from ' + @TableName + ' where ' + @sqlWhere 

     EXEC sp_executesql @sql,N'@totalRecord int OUTPUT',@totalRecord OUTPUT--计算总记录数 
     set @Totalrow=@totalRecord        
     
     --计算总页数 
     select @TotalPage=CEILING((@totalRecord+0.0)/@PageSize) 

     if (@SqlWhere='' or @sqlWhere=NULL) 
         set @sql = 'Select * FROM (select ROW_NUMBER() Over(order by ' + @OrderField + ') as rowId,' + @Fields + ' from ' + @TableName 
     else 
         set @sql = 'Select * FROM (select ROW_NUMBER() Over(order by ' + @OrderField + ') as rowId,' + @Fields + ' from ' + @TableName + ' where ' + @SqlWhere     
         
     --处理页数超出范围情况 
     if @PageIndex<=0 
         Set @pageIndex = 1 
     
     if @pageIndex>@TotalPage 
         Set @pageIndex = @TotalPage

     --处理开始点和结束点 
     Declare @StartRecord int 
     Declare @EndRecord int 
     
     set @StartRecord = (@pageIndex-1)*@PageSize + 1 
     set @EndRecord = @StartRecord + @pageSize - 1 

     --继续合成sql语句 
     set @Sql = @Sql + ') as ' + @TableName + ' where rowId between ' + Convert(varchar(50),@StartRecord) + ' and ' + Convert(varchar(50),@EndRecord) 
     
   -- insert into dbo.ASQLprocess (SQLstring)values(@Sql)

     Exec(@Sql) 
end