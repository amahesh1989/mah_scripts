db_name=`cat /tmp/oracle_install/ha_provision/db.config |grep DB_NAME |cut -d'=' -f2`
APP_PREFIX=`cat /tmp/oracle_install/ha_provision/db.config |grep APP_PREFIX |cut -d'=' -f2`
SERVICE_NAME=`cat /tmp/oracle_install/ha_provision/db.config |grep SERVICE_NAME |cut -d'=' -f2`
hostname=`hostname -f`
export ORACLE_SID=${db_name}
export ORAENV_ASK=NO
. oraenv
db_name=${db_name:-ORCL}
[[ -z $APP_PREFIX ]] && APP_PREFIX=`echo ${db_name} | cut -c1-3`


## PDB creation and post scripts

sqlplus -s "/ as sysdba" << EOF

prompt Creating PDB
create pluggable database ${APP_PREFIX}_PDB admin user pdbadmin identified by admin123;

alter pluggable database ${APP_PREFIX}_PDB open;

alter session set container=${APP_PREFIX}_PDB;


-- create user tablespaces
prompt Creating tablespaces
create tablespace ${APP_PREFIX}_DATA01;
create tablespace ${APP_PREFIX}_INDEX01;
create tablespace ${APP_PREFIX}_LOB01;


-- create default app users
prompt Creating app users

create user ${APP_PREFIX}_USER identified by "NewP#ss123" profile DB_APPLICATION_USER_PROFILE;
create user ${APP_PREFIX}_OWNER identified by "NewP#ss123" profile DB_APPLICATION_USER_PROFILE;


-- quota to default tablespaces
alter user ${APP_PREFIX}_USER quota unlimited on ${APP_PREFIX}_DATA01;
alter user ${APP_PREFIX}_USER quota unlimited on ${APP_PREFIX}_INDEX01;
alter user ${APP_PREFIX}_USER quota unlimited on ${APP_PREFIX}_LOB01;

alter user ${APP_PREFIX}_OWNER quota unlimited on ${APP_PREFIX}_DATA01;
alter user ${APP_PREFIX}_OWNER quota unlimited on ${APP_PREFIX}_INDEX01;
alter user ${APP_PREFIX}_OWNER quota unlimited on ${APP_PREFIX}_LOB01;

-- role grants
prompt Assigning roles
grant pdb_dba to pdbadmin;
grant resource,connect,create session to ${APP_PREFIX}_USER;
grant resource,connect,create session to ${APP_PREFIX}_OWNER;

exit
EOF

#Service creation
echo "Creating cluster service for pdb"
[[ -z $SERVICE_NAME ]] && SERVICE_NAME="${APP_PREFIX}_PDB_app"

srvctl add service -d ${db_name} -s ${SERVICE_NAME} -pdb ${APP_PREFIX}_PDB
srvctl start service -d ${db_name} -s ${SERVICE_NAME} -pdb ${APP_PREFIX}_PDB

echo "Provisioning complete"
echo "Hostname : $hostname"
echo "Port     : 1700"
echo "Service  : $SERVICE_NAME"

echo "Try connecting as --> sqlplus ${APP_PREFIX}_OWNER/\"NewP#ss123\"@\"(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$hostname)(PORT=1700))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=${SERVICE_NAME})))\""
