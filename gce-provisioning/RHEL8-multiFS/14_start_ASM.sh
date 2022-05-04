
#!/bin/sh

echo "########## ASM setup script  ###############"

declare -A array_disk_mapping

array_disk_mapping["sdj"]="REG_DATA01"
array_disk_mapping["sdk"]="RECO01"
array_disk_mapping["sdl"]="REDOLOG01"
array_disk_mapping["sdm"]="REDOLOG02"
array_disk_mapping["sdn"]="TEMP01"
array_disk_mapping["sdo"]="GRID"

export ORACLE_SID=+ASM
cat <<EOT > ${GRID_HOME}/dbs/init+ASM.ora
instance_type=ASM
asm_diskstring='/dev/oracleasm/*'
large_pool_size=12M
remote_login_passwordfile='EXCLUSIVE'
memory_target=0
sga_target=3G
pga_aggregate_target=400M
processes=1024
EOT
  
srvctl add asm -d '/dev/oracleasm/*'
srvctl start asm
 
export ORAENV_ASK=NO
. oraenv
  
echo "CREATE spfile FROM pfile;" | sqlplus -s / as sysasm
 
srvctl stop asm
srvctl start asm
 
## Create the ASM disk groups


for key in ${!array_disk_mapping[@]}; do
    echo " Create DISKGROUP for ${array_disk_mapping[${key}]}"

CURRENT_DISK_NAME=$(echo ${array_disk_mapping[${key}]} | tr [a-z] [A-Z])

echo "
SELECT header_status,path FROM v\$asm_disk;
  
CREATE DISKGROUP $CURRENT_DISK_NAME EXTERNAL REDUNDANCY
   DISK '/dev/oracleasm/${array_disk_mapping[${key}]}'
   ATTRIBUTE
      'compatible.asm'   = '19.0.0.0.0',
      'compatible.rdbms' = '19.0.0.0.0';
  
SELECT header_status,path FROM v\$asm_disk;
" | sqlplus -s / as sysasm

done

echo "### service check "
crsctl stat res -t
