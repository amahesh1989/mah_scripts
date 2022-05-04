
#!/bin/sh

echo "########## GRID POST INSTALL SCRIPT ###############"


/u01/app/oraInventory/orainstRoot.sh
 
/u01/app/oragrid/product/root.sh

export GRID_HOME=/u01/app/oragrid/product/
${GRID_HOME}/perl/bin/perl -I ${GRID_HOME}/perl/lib -I ${GRID_HOME}/crs/install ${GRID_HOME}/crs/install/roothas.pl
sleep 10
${GRID_HOME}/bin/crsctl stat res -t


