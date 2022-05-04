
#!/bin/sh

echo "########## INSTALL RDBMS SCRIPT ###############"

export CV_ASSUME_DISTID=OEL7.6

cp ${ORACLE_HOME}/install/response/db_install.rsp ${SWLIB}/db_install.rsp
  
sed -i '/^oracle.install.option/ s~oracle.install.option=$~oracle.install.option=INSTALL_DB_SWONLY~' ${SWLIB}/db_install.rsp
sed -i '/^oracle.install.db.InstallEdition/ s~oracle.install.db.InstallEdition=$~oracle.install.db.InstallEdition=EE~' ${SWLIB}/db_install.rsp
sed -i '/^ORACLE_HOSTNAME/ s~ORACLE_HOSTNAME=$~ORACLE_HOSTNAME=`hostname -A`~' ${SWLIB}/db_install.rsp
sed -i '/^UNIX_GROUP_NAME/ s~UNIX_GROUP_NAME=$~UNIX_GROUP_NAME=oinstall~' ${SWLIB}/db_install.rsp
sed -i '/^INVENTORY_LOCATION/ s~INVENTORY_LOCATION=$~INVENTORY_LOCATION=/u01/app/oraInventory~' ${SWLIB}/db_install.rsp
sed -i '/^ORACLE_HOME/ s~ORACLE_HOME=$~ORACLE_HOME='${ORACLE_HOME}'~' ${SWLIB}/db_install.rsp
sed -i '/^ORACLE_BASE/ s~ORACLE_BASE=$~ORACLE_BASE='${ORACLE_BASE}'~' ${SWLIB}/db_install.rsp
sed -i '/^oracle.install.db.DBA_GROUP/ s~oracle.install.db.DBA_GROUP=$~oracle.install.db.DBA_GROUP=dba~' ${SWLIB}/db_install.rsp
sed -i '/^oracle.install.db.OPER_GROUP/ s~oracle.install.db.OPER_GROUP=$~oracle.install.db.OPER_GROUP=dba~' ${SWLIB}/db_install.rsp
sed -i '/^oracle.install.db.BACKUPDBA_GROUP/ s~oracle.install.db.BACKUPDBA_GROUP=$~oracle.install.db.BACKUPDBA_GROUP=dba~' ${SWLIB}/db_install.rsp
sed -i '/^oracle.install.db.DGDBA_GROUP/ s~oracle.install.db.DGDBA_GROUP=$~oracle.install.db.DGDBA_GROUP=dba~' ${SWLIB}/db_install.rsp
sed -i '/^oracle.install.db.KMDBA_GROUP/ s~oracle.install.db.KMDBA_GROUP=$~oracle.install.db.KMDBA_GROUP=dba~' ${SWLIB}/db_install.rsp
sed -i '/^oracle.install.db.OSDBA_GROUP/ s~oracle.install.db.OSDBA_GROUP=$~oracle.install.db.OSDBA_GROUP=dba~' ${SWLIB}/db_install.rsp
sed -i '/^oracle.install.db.OSOPER_GROUP/ s~oracle.install.db.OSOPER_GROUP=$~oracle.install.db.OSOPER_GROUP=dba~' ${SWLIB}/db_install.rsp
sed -i '/^oracle.install.db.OSBACKUPDBA_GROUP/ s~oracle.install.db.OSBACKUPDBA_GROUP=$~oracle.install.db.OSBACKUPDBA_GROUP=dba~' ${SWLIB}/db_install.rsp
sed -i '/^oracle.install.db.OSDGDBA_GROUP/ s~oracle.install.db.OSDGDBA_GROUP=$~oracle.install.db.OSDGDBA_GROUP=dba~' ${SWLIB}/db_install.rsp
sed -i '/^oracle.install.db.OSKMDBA_GROUP/ s~oracle.install.db.OSKMDBA_GROUP=$~oracle.install.db.OSKMDBA_GROUP=dba~' ${SWLIB}/db_install.rsp
sed -i '/^oracle.install.db.OSRACDBA_GROUP/ s~oracle.install.db.OSRACDBA_GROUP=$~oracle.install.db.OSRACDBA_GROUP=dba~' ${SWLIB}/db_install.rsp
sed -i '/^SECURITY_UPDATES_VIA_MYORACLESUPPORT/ s~SECURITY_UPDATES_VIA_MYORACLESUPPORT$=~SECURITY_UPDATES_VIA_MYORACLESUPPORT=FALSE~' ${SWLIB}/db_install.rsp
sed -i '/^DECLINE_SECURITY_UPDATES/ s~DECLINE_SECURITY_UPDATES=$~DECLINE_SECURITY_UPDATES=TRUE~' ${SWLIB}/db_install.rsp
  
diff ${ORACLE_HOME}/install/response/db_install.rsp ${SWLIB}/db_install.rsp
 
## Install RDBMS
 
${ORACLE_HOME}/runInstaller -silent -waitforcompletion -responseFile ${SWLIB}/db_install.rsp


