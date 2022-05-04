echo "Configuring Listener"

${ORACLE_HOME}/bin/srvctl add listener -oraclehome ${ORACLE_HOME} -p TCP:1700

${ORACLE_HOME}/bin/srvctl start listener

${ORACLE_HOME}/bin/srvctl enable ons

${ORACLE_HOME}/bin/srvctl start ons

