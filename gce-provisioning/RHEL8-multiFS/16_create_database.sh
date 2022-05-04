
DB_NAME=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/DB_NAME -H "Metadata-Flavor: Google")


if [[ $DB_NAME == *"Error 404"* ]]
then
  echo "DB_NAME Metadata not found"
  exit 1
fi

db_name=${DB_NAME:-ORCL}
#echo $db_name

$ORACLE_HOME/bin/dbca -silent -createDatabase -gdbName ${db_name} -sid ${db_name} -sysPassword Oracle123 -systemPassword Oracle123 -templateName v1900.dbc -datafileJarLocation /u01/app/oracle/admin/common/templates -storageType asm -recoveryAreaDestination '+RECO01' -datafileDestination '+REG_DATA01' -initparams "sga_max_size=10G,sga_target=10G,pga_aggregate_target=4G,db_create_online_log_dest_1=+REDOLOG01,db_create_online_log_dest_2=+REDOLOG02"
