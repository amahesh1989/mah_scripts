
#!/bin/sh
echo "########## LISTENER CONFIGURATION SCRIPT ###############"
#lsnrctl start
#lsnrctl stop
srvctl add listener
srvctl start listener

