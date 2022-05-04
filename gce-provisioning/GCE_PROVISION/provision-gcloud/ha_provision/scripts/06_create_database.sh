DB_NAME=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/DB_NAME -H "Metadata-Flavor: Google")

DB_NAME=${DB_NAME:-ORCL}

SGA=${SGA:-10G}

$ORACLE_HOME/bin/dbca -silent -createDatabase -gdbName ${DB_NAME} -sid ${DB_NAME} -sysPassword Oracle123 -systemPassword Oracle123 -templateName v1900.dbc -datafileJarLocation /u01/app/oracle/admin/common/templates -storageType asm -recoveryAreaDestination '+RECO01' -datafileDestination '+REG_DATA01' -initparams "sga_max_size=${SGA},sga_target=${SGA},pga_aggregate_target=4G,db_create_online_log_dest_1=+REDOLOG01,db_create_online_log_dest_2=+REDOLOG02"
