CREATE OR REPLACE PROCEDURE PD_PAGE_QUERY
(
IN_COLNAMES         VARCHAR2,            --����
IN_TABLENAME        VARCHAR2,            --����
IN_WHERE            VARCHAR2,            --��ѯ����
IN_ORDERCOL         VARCHAR2,            --������
IN_ORDERTYPE        VARCHAR2,            --����ʽ
IN_CURPAGE          NUMBER,              --��ǰҳ
IN_PAGESIZE         NUMBER,              --ÿҳ��¼��
OUT_TOTALRECORDS    OUT NUMBER,          --�ܼ�¼��
OUT_TOTALPAGES      OUT NUMBER,          --��ҳ��
OUT_QUERY_RESULT    OUT SYS_REFCURSOR    --���صĽ����
)
------------------------------------------------------------------------------
---����������ͨ������Ĳ�ѯ�������ض�Ӧ�ķ�ҳ��ѯ���
---ʱ�䣺    2015-07-10
---���ߣ�    sunw
---�汾��    1.0 beta
------------------------------------------------------------------------------

IS

V_SQL          VARCHAR2(1024):='';       --SQL���
V_START_RECORD NUMBER(4);                --��ʼ��ʾ�ļ�¼����
V_END_RECORD   NUMBER(4);                --������ʾ�ļ�¼����


BEGIN
  --��¼�ܼ�¼��
  V_SQL:='SELECT COUNT(*) FROM '||IN_TABLENAME;
  --�ж��Ƿ���WHERE����
  IF IN_WHERE IS NOT NULL  THEN
    V_SQL:=V_SQL||' WHERE '||IN_WHERE;
  END IF;
  EXECUTE IMMEDIATE V_SQL INTO OUT_TOTALRECORDS;

  --��֤ҳ���¼��С
  --IF IN_PAGESIZE  < 0 THEN
  --  IN_PAGESIZE := 0;
  --END IF;

  --����ҳ���С������ҳ��
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

  --ʵ�ַ�ҳ��ѯ
  --�õ���ʼ��ROWNUM
  V_START_RECORD := (IN_CURPAGE-1)*IN_PAGESIZE+1;
  --�õ�������ROWNUM
  V_END_RECORD   := IN_CURPAGE*IN_PAGESIZE;

  V_SQL := 'SELECT '||IN_COLNAMES|| ' FROM '||IN_TABLENAME;

  --�ж��Ƿ���WHERE����
  IF IN_WHERE IS NOT NULL  THEN
    V_SQL:=V_SQL||' WHERE '||IN_WHERE;
  END IF;

  --�ж��Ƿ���ORDER BY����
  IF IN_ORDERCOL IS NOT NULL  THEN
    V_SQL:=V_SQL||' ORDER BY '||IN_ORDERCOL||' '||IN_ORDERTYPE;
  END IF;

  V_SQL := 'SELECT ROWNUM RN,T.* FROM (' ||V_SQL|| ') T';

  V_SQL:='SELECT * FROM ('||V_SQL||') WHERE RN>='||V_START_RECORD||' AND RN<='||V_END_RECORD;
  --���ƴ�Ӻ�����,ֻ�п���SERVEROUTPUT�ſɼ�
  DBMS_OUTPUT.PUT_LINE(V_SQL);
  --�򿪹�귵�ؽ����
  OPEN OUT_QUERY_RESULT FOR V_SQL;

  --���´�������
  --��Ҫ���������´���ȥ�Ż�����Ĵ��룬ʵ��֤����������ڲ���������Ǵ����,���Ҿ����㻹֤��������
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
