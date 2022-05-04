. /tmp/oracle_install/ha_provision/scripts/set_env

echo "Configuring HA stack"

cd $ORACLE_HOME/crs/install

sed -i "s/^INSTALL_NODE=.*/INSTALL_NODE=`hostname -f`/g" $ORACLE_HOME/crs/install/crsconfig_params

$ORACLE_HOME/crs/install/roothas.sh

$ORACLE_HOME/bin/crsctl stat res -t
