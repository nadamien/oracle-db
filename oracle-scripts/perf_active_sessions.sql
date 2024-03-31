-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : perf_active.sql                                                 |
-- | CLASS    : Performance Tuning                                    		|
-- | PURPOSE  : To find active sessions		    			 	|
-- |                                                 		     		|
-- | NOTE     : As with any code, ensure to test this script in a development   |
-- |            environment before attempting to run it in production.          |
-- +----------------------------------------------------------------------------+

SET TERMOUT OFF;
COLUMN current_instance NEW_VALUE current_instance NOPRINT;
SELECT rpad(sys_context('USERENV', 'INSTANCE_NAME'), 17) current_instance FROM dual;
SET TERMOUT ON;

PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : Active Running Sessions                                     |
PROMPT | Instance : &current_instance                                           |
PROMPT +------------------------------------------------------------------------+
set colsep '|'
SET ECHO        OFF
SET FEEDBACK    6
SET HEADING     ON
SET LINESIZE    194
SET PAGESIZE    50000
SET TERMOUT     ON
SET TIMING      OFF
SET TRIMOUT     ON
SET TRIMSPOOL   ON
SET VERIFY      OFF
CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

COLUMN wait_class        FORMAT a26        HEAD 'Wait Class'
COLUMN username          FORMAT a18        HEAD 'User Name'
COLUMN INST_ID		    FORMAT 999999   
COLUMN MACHINE		    FORMAT a20
COLUMN INST_ID		    FORMAT 999999 
COLUMN LOGON_TIME	    FORMAT a20		HEAD 'Logon Time'
COLUMN OSUSER 		    FORMAT a18		HEAD 'OS User'
COLUMN TERMINAL		    FORMAT a15

select 
	INST_ID
	,SID
	,SERIAL#
	,USERNAME
	,TERMINAL
	,LAST_CALL_ET/60 "in Mins"
	,SQL_ID
	,OSUSER
	,to_char(LOGON_TIME,'DD-MON-YYYY HH24:MI') "LOGON_TIME"
	,status
from 
	gv$session 
where 
	username like upper(nvl('&USERNAME','%'))
and 
	status='ACTIVE'
/