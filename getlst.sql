--getlst.sql – Script to download information about eScript from Oracle Database via SQL*Plus
set termout off
set colsep "#"
set head off verify off feedback off
set linesize 2000 trimspool on pagesize 9999 longchunksize 2000 long 1000000000
col repository_name format a120
col application_name format a120
col applet_name format a120
col bc_name format a120
col service_name format a120
col script_name format a120
col last_upd format a40
col obj_type format a40

column app new_value _app
column applet new_value _applet
column bc new_value _bc
column bs new_value _bs
select '&1' || 'application.lst' app from dual;
select '&1' || 'applet.lst' applet from dual;
select '&1' || 'bc.lst' bc from dual;
select '&1' || 'bs.lst' bs from dual;

spool '&_app'
select r.name as repository_name, 'Application' as obj_type , a.name as application_name, ast.name as script_name, ast.last_upd, ast.script
  from SIEBEL.S_APPL_SCRIPT ast, SIEBEL.S_APPLICATION a, SIEBEL.S_REPOSITORY r
 where r.row_id = ast.repository_id
 and   ast.application_id = a.row_id
 and   ast.repository_id = a.repository_id
 and   r.name = 'Siebel Repository'
 and   ast.last_upd > to_date('01.01.2009','DD.MM.RRRR');
spool off

spool '&_applet'
select r.name as repository_name, 'Applet' as obj_type , a.name as applet_name, ast.name as script_name, ast.last_upd, ast.script
  from SIEBEL.S_APPL_WEBSCRPT ast, SIEBEL.S_APPLET a, SIEBEL.S_REPOSITORY r
 where r.row_id = ast.repository_id
 and   ast.applet_id = a.row_id
 and   ast.repository_id = a.repository_id
 and   r.name = 'Siebel Repository'
 and   ast.last_upd > to_date('01.01.2009','DD.MM.RRRR');
spool off

spool '&_bc'
select r.name as repository_name, 'Business Component' as obj_type , b.name as bc_name, bst.name as script_name, bst.last_upd, bst.script
  from SIEBEL.S_BUSCOMP_SCRIPT bst, SIEBEL.S_BUSCOMP b, SIEBEL.S_REPOSITORY r
 where r.row_id = bst.repository_id
 and   bst.buscomp_id = b.row_id
 and   bst.repository_id = b.repository_id
 and   r.name = 'Siebel Repository'
 and   bst.last_upd > to_date('01.01.2009','DD.MM.RRRR');
spool off

spool '&_bs'
select r.name as repository_name, 'Business Service' as obj_type , s.name as service_name, sst.name as script_name, sst.last_upd, sst.script
  from SIEBEL.S_SERVICE_SCRPT sst, SIEBEL.S_SERVICE s, SIEBEL.S_REPOSITORY r
 where r.row_id = sst.repository_id
 and   sst.service_id = s.row_id
 and   sst.repository_id = s.repository_id
 and   r.name = 'Siebel Repository'
 and   sst.last_upd > to_date('01.01.2009','DD.MM.RRRR');
spool off

exit
