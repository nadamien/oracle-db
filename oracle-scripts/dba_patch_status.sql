REM Description		: Patch status from DBMS Opatch 
set serveroutput on

exec dbms_qopatch.get_sqlpatch_status;