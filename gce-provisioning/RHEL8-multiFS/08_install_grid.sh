
#!/bin/sh

echo "########## INSTALL GRID SCRIPT ###############"

cd ${GRID_HOME}
export CV_ASSUME_DISTID=OEL7.6
echo "########## PATCH THE GRID ENV ###############"
./gridSetup.sh -silent -applyRU ${GRID_HOME}/31305339/

echo "########## RUN CLUVFY PREINSTALL###############"
./runcluvfy.sh stage -pre crsinst -n `hostname -s` 
 
cp ${GRID_HOME}/inventory/response/grid_install.rsp ${SWLIB}/grid_install.rsp

sed -i '/^oracle.install.option/ s~oracle.install.option=$~oracle.install.option=CRS_SWONLY~' ${SWLIB}/grid_install.rsp
sed -i '/^ORACLE_HOSTNAME/ s~ORACLE_HOSTNAME=$~ORACLE_HOSTNAME=`hostname -A`~' ${SWLIB}/grid_install.rsp
sed -i '/^INVENTORY_LOCATION/ s~INVENTORY_LOCATION=$~INVENTORY_LOCATION=/u01/app/oraInventory~' ${SWLIB}/grid_install.rsp
sed -i '/^ORACLE_BASE/ s~ORACLE_BASE=$~ORACLE_BASE='${ORACLE_BASE}'~' ${SWLIB}/grid_install.rsp
sed -i '/^oracle.install.asm.OSDBA/ s~oracle.install.asm.OSDBA=$~oracle.install.asm.OSDBA=asmdba~' ${SWLIB}/grid_install.rsp
sed -i '/^oracle.install.asm.OSOPER/ s~oracle.install.asm.OSOPER=$~oracle.install.asm.OSOPER=asmoper~' ${SWLIB}/grid_install.rsp
sed -i '/^oracle.install.asm.OSASM/ s~oracle.install.asm.OSASM=$~oracle.install.asm.OSASM=asmadmin~' ${SWLIB}/grid_install.rsp

echo "########## INSTALL GRID ###############"

diff ${GRID_HOME}/inventory/response/grid_install.rsp ${SWLIB}/grid_install.rsp
 
${GRID_HOME}/gridSetup.sh -silent -responseFile ${SWLIB}/grid_install.rsp
 



