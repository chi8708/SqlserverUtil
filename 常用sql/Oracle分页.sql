CREATE OR REPLACE PROCEDURE PD_PAGE_QUERY
(
IN_COLNAMES         VARCHAR2,            --列名
IN_TABLENAME        VARCHAR2,            --表名
IN_WHERE            VARCHAR2,            --查询条件
IN_ORDERCOL         VARCHAR2,            --排序列
IN_ORDERTYPE        VARCHAR2,            --排序方式
IN_CURPAGE          NUMBER,              --当前页
IN_PAGESIZE         NUMBER,              --每页记录数
OUT_TOTALRECORDS    OUT NUMBER,          --总记录数
OUT_TOTALPAGES      OUT NUMBER,          --总页数
OUT_QUERY_RESULT    OUT SYS_REFCURSOR    --返回的结果集
)
------------------------------------------------------------------------------
---功能描述：通过传入的查询条件返回对应的分页查询结果
---时间：    2015-07-10
---作者：    sunw
---版本：    1.0 beta
------------------------------------------------------------------------------

IS

V_SQL          VARCHAR2(1024):='';       --SQL语句
V_START_RECORD NUMBER(4);                --开始显示的记录条数
V_END_RECORD   NUMBER(4);                --结束显示的记录条数


BEGIN
  --记录总记录数
  V_SQL:='SELECT COUNT(*) FROM '||IN_TABLENAME;
  --判断是否传入WHERE条件
  IF IN_WHERE IS NOT NULL  THEN
    V_SQL:=V_SQL||' WHERE '||IN_WHERE;
  END IF;
  EXECUTE IMMEDIATE V_SQL INTO OUT_TOTALRECORDS;

  --验证页面记录大小
  --IF IN_PAGESIZE  < 0 THEN
  --  IN_PAGESIZE := 0;
  --END IF;

  --根据页面大小计算总页数
  IF MOD(OUT_TOTALRECORDS,IN_PAGESIZE) = 0 THEN
    OUT_TOTALPAGES:=OUT_TOTALRECORDS/IN_PAGESIZE;
  ELSE
    OUT_TOTALPAGES:=TRUNC(OUT_TOTALRECORDS/IN_PAGESIZE)+1;
  END IF;

  --IF IN_CURPAGE < 1 THEN
  --  IN_CURPAGE := 1;
  --END IF;

  --IF IN_CURPAGE > OUT_TOTALPAGES THEN
  --  IN_CURPAGE:=OUT_TOTALPAGES;
  --END IF;

  --实现分页查询
  --得到开始的ROWNUM
  V_START_RECORD := (IN_CURPAGE-1)*IN_PAGESIZE+1;
  --得到结束的ROWNUM
  V_END_RECORD   := IN_CURPAGE*IN_PAGESIZE;

  V_SQL := 'SELECT '||IN_COLNAMES|| ' FROM '||IN_TABLENAME;

  --判断是否传入WHERE条件
  IF IN_WHERE IS NOT NULL  THEN
    V_SQL:=V_SQL||' WHERE '||IN_WHERE;
  END IF;

  --判断是否传入ORDER BY条件
  IF IN_ORDERCOL IS NOT NULL  THEN
    V_SQL:=V_SQL||' ORDER BY '||IN_ORDERCOL||' '||IN_ORDERTYPE;
  END IF;

  V_SQL := 'SELECT ROWNUM RN,T.* FROM (' ||V_SQL|| ') T';

  V_SQL:='SELECT * FROM ('||V_SQL||') WHERE RN>='||V_START_RECORD||' AND RN<='||V_END_RECORD;
  --输出拼接后的语句,只有开启SERVEROUTPUT才可见
  DBMS_OUTPUT.PUT_LINE(V_SQL);
  --打开光标返回结果集
  OPEN OUT_QUERY_RESULT FOR V_SQL;

  --以下代码弃用
  --不要想着用以下代码去优化上面的代码，实践证明下面代码在部分情况下是错误的,而且就怕你还证明不出来
  --V_SQL := 'SELECT ROWNUM RN, '||IN_COLNAMES|| ' FROM '||IN_TABLENAME;


  --V_SQL :=V_SQL||' WHERE ROWNUM<= '||V_END_RECORD;

  --IF IN_WHERE IS NOT NULL  THEN
  --  V_SQL:=V_SQL||' AND '||IN_WHERE;
  --END IF;

  --IF IN_ORDERCOL IS NOT NULL  THEN
  --  V_SQL:=V_SQL||' ORDER BY '||IN_ORDERCOL||' '||IN_ORDERTYPE;
  --END IF;

  --V_SQL:='SELECT * FROM ('||V_SQL||') WHERE RN>='||V_START_RECORD;
  --DBMS_OUTPUT.PUT_LINE(V_SQL);
  --OPEN OUT_QUERY_RESULT FOR V_SQL;

END PD_PAGE_QUERY;
