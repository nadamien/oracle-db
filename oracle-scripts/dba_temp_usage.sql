-- |----------------------------------------------------------------------------|
-- | DATABASE : Oracle                                                          |
-- | FILE     : dba_temp_usage.sql                                        	|
-- | CLASS    : Database Administration                                         |
-- | PURPOSE  : Reports on all temp  usage. This script was designed to     	|
-- |            work with Oracle8i or higher. It will include true TEMPORARY    |
-- |            tablespaces. (i.e. use of "tempfiles")                          |
-- | NOTE     : As with any code, ensure to test this script in a development   |
-- |            environment before attempting to run it in production.          |
-- +----------------------------------------------------------------------------+

SET TERMOUT OFF;
COLUMN current_instance NEW_VALUE current_instance NOPRINT;
SELECT rpad(instance_name, 17) current_instance FROM v$instance;
SET TERMOUT ON;

PROMPT 
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : Temp Usage                                                  |
PROMPT | Instance : &current_instance                                           |
PROMPT +------------------------------------------------------------------------+

SET ECHO        OFF
SET FEEDBACK    6
SET HEADING     ON
SET LINESIZE    256
SET PAGESIZE    50000
SET TERMOUT     ON
SET TIMING      OFF
SET TRIMOUT     ON
SET TRIMSPOOL   ON
SET VERIFY      OFF

CLEAR COLUMNS
CLEAR BREAKS
CLEAR COMPUTES

COLUMN username 	FORMAT a15
COLUMN temp_used_mb	FORMAT 999,999,999	HEADING 'Temp Used (MB)'

COMPUTE sum OF filesize  ON report
COMPUTE sum OF used      ON report
COMPUTE avg OF pct_used  ON report


SELECT distinct ss.inst_id,NVL(s.username, '(background)') AS username,
       s.sid,
       s.serial#,
       s.sql_id,
       ROUND(ss.value/1024/1024, 2) AS temp_used_mb
FROM   gv$session s
       JOIN gv$sesstat ss ON s.sid = ss.sid
       JOIN gv$statname sn ON ss.statistic# = sn.statistic#
WHERE  sn.name = 'temp space allocated (bytes)'
AND    ss.value > 0
ORDER BY 6 desc;