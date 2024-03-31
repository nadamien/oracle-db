SET TERMOUT OFF;
COLUMN current_instance NEW_VALUE current_instance NOPRINT;
SELECT rpad(instance_name, 17) current_instance FROM v$instance;
SET TERMOUT ON;

PROMPT
PROMPT +------------------------------------------------------------------------+
PROMPT | Report   : This will Display Who Locked the Account                    |
PROMPT | Instance : &current_instance                                           |
PROMPT | Capturing ORA 1017,28000 Error Codes                                   |
PROMPT +------------------------------------------------------------------------+


set pagesize 1299 
set lines 299 
col username for a15 
col userhost for a35 
col timestamp for a39 
col terminal for a23
col OS_USERNAME for a30 
SELECT OS_USERNAME,username,userhost,terminal,to_char(timestamp,'DD-MON-YY HH24:MI'),returncode 
FROM dba_audit_session 
WHERE username='&USER_NAME' and returncode in (1017,28000);

