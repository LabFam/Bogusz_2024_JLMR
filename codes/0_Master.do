* HONORATA BOGUSZ -- 0. MASTER FILE *

clear all
set max_memory .
* sysdir set PERSONAL "D:\gastwissenschaftler\gastw_7\Bogusz\ado"

do "..\dofiles\1_AKVS_Preparation.do" 
do "..\dofiles\1_Data_Preparation.do"
do "..\dofiles\3_Descriptives.do"
do "..\dofiles\2_Modelling_First_Birth_3d.do"
do "..\dofiles\2_Modelling_First_Birth_2d.do"
