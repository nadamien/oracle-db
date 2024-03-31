PROMPT +------------------------------------------------------------------------+
PROMPT | Creation of Audit Trigger to Capture Invalid Logins                    |
PROMPT | ORA-1017: invalid username/password                                    |
PROMPT | Use ONLY When Auditing is Disabled (DEV/TEST)                                    |
PROMPT +------------------------------------------------------------------------+


set serveroutput on
define table_name = &Enter_Audit_Table_Name;
create  table &table_name (login_session varchar2(2000));

CREATE OR REPLACE TRIGGER logon_denied_write_alertlog AFTER SERVERERROR ON DATABASE
DECLARE
 l_message varchar2(2000);
BEGIN
 -- ORA-1017: invalid username/password; logon denied
 IF (IS_SERVERERROR(28000)) THEN
 select 'Failed login attempt to the "'|| sys_context('USERENV' ,'AUTHENTICATED_IDENTITY') ||'" schema'
 || ' using ' || sys_context ('USERENV', 'AUTHENTICATION_TYPE') ||' authentication'
 || ' at ' || to_char(logon_time,'dd-MON-yy hh24:mi:ss' )
 || ' from ' || osuser ||'@'||machine ||' ['||nvl(sys_context ('USERENV', 'IP_ADDRESS'),'Unknown IP')||']'
 || ' via the "' ||program||'" program.'
 into l_message
 from sys .v_$session
 where sid = to_number(substr(dbms_session.unique_session_id,1 ,4), 'xxxx')
 and serial# = to_number(substr(dbms_session.unique_session_id,5 ,4), 'xxxx');
 
 -- write to alert log
 --sys.dbms_system .ksdwrt( 2,l_message );
 INSERT INTO &table_name (login_session) VALUES (l_message);
 commit;
 END IF;
END;
/

show errors;

PROMPT +------------------------------------------------------------------------+
PROMPT | Query from &table_name to get Audit Data                               |
PROMPT | select * from  &table_name;                                            |
PROMPT +------------------------------------------------------------------------+
PROMPT +------------------------------------------------------------------------+
PROMPT | Drop the Trigger and the Table After Work is Done                      |
PROMPT | Copy Paste Bellow to Drop Table and the Trigger                        |
PROMPT +------------------------------------------------------------------------+
PROMPT +------------------------------------------------------------------------+
PROMPT | drop trigger logon_denied_write_alertlog;                              |
PROMPT | drop table &table_name;                                                |
PROMPT +------------------------------------------------------------------------+

undefine table_name;
