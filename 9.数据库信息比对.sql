���ݿ�Ա�
--sql server ����:
select count(1) from sysobjects where xtype='U'
--����ͼ:
select count(1) from sysobjects where xtype='V'
---���洢����
select count(1) from sysobjects where xtype='P'

SELECT * FROM sysobjects WHERE xtype='P' AND [NAME] NOT 
IN(select [NAME] from [200.200.22.22].OnlineOrdering.dbo.sysobjects where xtype='P')

C = CHECK Լ�� 
D = Ĭ��ֵ�� DEFAULT Լ�� 
F = FOREIGN KEY Լ�� 
L = ��־ 
FN = �������� 
IF = ��Ƕ���� 
P = �洢���� 
PK = PRIMARY KEY Լ���������� K�� 
RF = ����ɸѡ�洢���� 
S = ϵͳ�� 
TF = ���� 
TR = ������ 
U = �û��� 
UQ = UNIQUE Լ���������� K�� 
V = ��ͼ 
X = ��չ�洢����