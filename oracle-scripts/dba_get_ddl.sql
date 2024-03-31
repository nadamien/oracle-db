REM Description		: Extracts the DDL statement for the object when the parameters are passed, Object Name and Object Type creates a spool file on location

SET ECHO OFF
SET HEADING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET LINESIZE 10000
SET LONG 2000000000
SET LONGCHUNKSIZE 16000
SET TRIMSPOOL ON
SET PAGESIZE 0

COLUMN test FORMAT A10000

DEFINE _object_file = '&1'
DEFINE _object_name = '&2'
DEFINE _object_type = '&3'

SPOOL &_object_file

SELECT DBMS_METADATA.GET_DDL('&&_object_type', '&&_object_name',USER) test FROM DUAL;

SPOOL OFF