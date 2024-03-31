SET TERMOUT OFF;
COLUMN current_instance NEW_VALUE current_instance NOPRINT;
SELECT rpad(instance_name, 17) current_instance FROM v$instance;
SET TERMOUT ON;

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : Minimum and Maximum Flashback Time                          |
PROMPT | Instance : &current_instance                                           |
PROMPT +------------------------------------------------------------------------+

PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : How Far Back Can We Flashback To (Time)                   |
PROMPT +------------------------------------------------------------------------+

select to_char(oldest_flashback_time,’dd-mon-yyyy hh24:mi:ss’) “Oldest Flashback Time” 
from v$flashback_database_log; 

PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : How Far Back Can We Flashback To (SCN)                          |
PROMPT +------------------------------------------------------------------------+

col oldest_flashback_scn format 99999999999999999999999999 
select oldest_flashback_scn from v$flashback_database_log;