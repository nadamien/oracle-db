REM Description		: Get the OS PID from the SID value from v$session and v$process views.
col sid format 999999
col username format a20
col osuser format a15
select a.sid, a.serial#,a.username, a.osuser, b.spid
from gv$session a, gv$process b
where a.paddr= b.addr
and a.sid='&EnterSID'
order by a.sid;