ALTER  function   [dbo].[Dhf_split](@c   varchar(2000),@split   varchar(2))   
 returns   @t   table(col   varchar(20))   
 as   
     begin   

       while(charindex(@split,@c)<>0)   
         begin   
           insert   @t(col)   values   (substring(@c,1,charindex(@split,@c)-1))   
           set   @c   =   stuff(@c,1,charindex(@split,@c),'')   
         end   
       insert   @t(col)   values   (@c)   
       return   
     end 



将多行某列值合并为逗号分隔的一列  SELECT STUFF((SELECT ','+name FROM 表名 for xml path('')),1,1,'')