#### Switch to root user

sudo su

#### Download the scripts
SCRIPT_DIR=RHEL8-multiFS  
mkdir /tmp/oracle_install  
gsutil cp -r gs://oracle-bin-dbapoc/$SCRIPT_DIR /tmp/oracle_install/ 

#### Prepare the target folders

chmod u+x /tmp/oracle_install/$SCRIPT_DIR/*.sh  

#### Run the Install script if it was not already started in the metadata
echo "INITIAL_STATE" > /tmp/oracle_install/status_installation   
/tmp/oracle_install/$SCRIPT_DIR/run_all.sh  

