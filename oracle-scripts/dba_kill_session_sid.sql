REM Description		: Generate a disconnect session from the ACTIVE sid
select 'alter system disconnect session ' || '''' || s.sid|| ',' || s.serial# || 
       ',@' || s.inst_id || ''';' as "Kill_Session_Command"
FROM   gv$session s
JOIN   gv$process p ON p.addr = s.paddr AND p.inst_id = s.inst_id
WHERE  s.status='ACTIVE'
AND    s.username='&_sid';