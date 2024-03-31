REM Description		: Easily Find the TBS Size and Get a Sample Command to Alter the datafiles.
SET TERMOUT OFF;
set colsep '|'
COLUMN current_instance NEW_VALUE current_instance NOPRINT;
SELECT rpad(instance_name, 17) current_instance FROM v$instance;
SET TERMOUT ON;

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : Tablespace anb Datafile Resize		                |
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

COLUMN tablespace  FORMAT a22                 HEADING 'Tablespace Name'
COLUMN filename    FORMAT a60                 HEADING 'Filename'
COLUMN filesize    FORMAT 9,999,999,999       HEADING 'File Size (Mb)'
COLUMN used        FORMAT 9,999,999,999       HEADING 'Used (Mb)'
COLUMN pct_used    FORMAT 999                 HEADING 'Pct. Used'

define tbs_name = &TABLESPACE_NAME;

set lines 165
set pages 2000
PROMPT +++++++++++++++++++
PROMPT TABLESPACE USAGE
PROMPT +++++++++++++++++++
select df.tablespace_name "TBSP", df.Ct "No of Datafiles", df.TotSize "Total (MB)", fr.FreSpac "Free (MB)",round((fr.FreSpac/df.TotSize)*100,2) "% Free",
round(df.TotSize-fr.FreSpac,0) "Used (MB)",round(((df.TotSize-fr.FreSpac)/df.TotSize)*100,2) "% Used"
from (Select tablespace_name,round(sum(bytes)/(1024*1024),0) TotSize,count(file_name) Ct
from dba_data_files group by tablespace_name) df,
(Select tablespace_name,round(sum(bytes)/(1024*1024),0) FreSpac
from dba_free_space group by tablespace_name) fr
where  df.tablespace_name=fr.tablespace_name and df.tablespace_name ='&tbs_name' order by 7 desc
/
set lines 240
set pages 2000
PROMPT +++++++++++++++++++++++++++++
PROMPT LIST OF DATAFILES FOR THE TBS
PROMPT +++++++++++++++++++++++++++++
col TABLESPACE_NAME for a40
col FILE_NAME for a60
select TABLESPACE_NAME,FILE_NAME,BYTES/1024/1024 "Total (MB)" from dba_data_files where TABLESPACE_NAME ='&tbs_name';


PROMPT +----------------------------------------------------------------------------+
PROMPT |  USE THE BELLOW COMMANDS TO RESIZE OR ADD TBS	                            |
PROMPT |  TBS Resize Commands							    |
PROMPT |  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	    |
PROMPT |  alter database datafile <DATA FILE NAME WITH PATH> resize 10000M;         |
PROMPT |  alter tablespace <TBS NAME>  add datafile <ADD LOCATION HERE> size 10000M;|
PROMPT +----------------------------------------------------------------------------+

undefine tbs_name;