
#!/bin/sh

WORKING_DIR=/tmp/oracle_install/
OS_FOLDER=RHEL8-multiFS

if test -f $WORKING_DIR/status_installation
then
        current_status_value=$(cat $WORKING_DIR/status_installation )
else
        echo "INITIAL_STATE" > $WORKING_DIR/status_installation
fi

LOG_FILE=$WORKING_DIR/installation_logs

if [ "$current_status_value" == "INITIAL_STATE" ]
then
	echo "" > $LOG_FILE
	echo "INSTALLING_ORACLE" > $WORKING_DIR/status_installation
	$WORKING_DIR/$OS_FOLDER/01_os_prerequisites.sh 2>&1 >> $LOG_FILE
	echo "Rebooting the VM" >> $LOG_FILE
	reboot
fi


if [ "$current_status_value" == "INSTALLING_ORACLE" ]
then
        echo "Perform the Oracle installation" >> $LOG_FILE
	$WORKING_DIR/$OS_FOLDER/02_user_and_FS_prerequisites.sh 2>&1 >> $LOG_FILE
        $WORKING_DIR/$OS_FOLDER/03_download_oracle_bin.sh 2>&1 >> $LOG_FILE
        chown oracle:oinstall $WORKING_DIR/$OS_FOLDER/*
	chmod g+rx $WORKING_DIR/$OS_FOLDER/*
	su -c "$WORKING_DIR/$OS_FOLDER/04_unzip_oragrid_dir.sh" - oragrid 2>&1 >> $LOG_FILE
        su -c "$WORKING_DIR/$OS_FOLDER/05_unzip_oracle_dir.sh" - oracle 2>&1 >> $LOG_FILE
        $WORKING_DIR/$OS_FOLDER/06_install_cvuqdisk.sh 2>&1 >> $LOG_FILE
        $WORKING_DIR/$OS_FOLDER/07_install_tmp_fs.sh 2>&1 >> $LOG_FILE
        su -c "$WORKING_DIR/$OS_FOLDER/08_install_grid.sh" - oragrid  2>&1 >> $LOG_FILE
        $WORKING_DIR/$OS_FOLDER/09_post_install_grid.sh 2>&1 >> $LOG_FILE
        $WORKING_DIR/$OS_FOLDER/10_prepare_ASM_disks.sh 2>&1 >> $LOG_FILE
        su -c "$WORKING_DIR/$OS_FOLDER/11_install_RDBMS.sh" - oracle 2>&1 >> $LOG_FILE
        $WORKING_DIR/$OS_FOLDER/12_post_install_RDBMS.sh 2>&1 >> $LOG_FILE
        su -c "$WORKING_DIR/$OS_FOLDER/13_configure_listener.sh" - oragrid 2>&1 >> $LOG_FILE
        su -c "$WORKING_DIR/$OS_FOLDER/14_start_ASM.sh" - oragrid 2>&1 >> $LOG_FILE
        su -c "$WORKING_DIR/$OS_FOLDER/15_ASM_configuration.sh" - oragrid 2>&1 >> $LOG_FILE
        su -c "$WORKING_DIR/$OS_FOLDER/16_create_database.sh" - oracle 2>&1 >> $LOG_FILE
        su -c "$WORKING_DIR/$OS_FOLDER/17_post_database_creation.sh" - oracle 2>&1 >> $LOG_FILE
	echo "ORACLE_INSTALLED" > $WORKING_DIR/status_installation 
fi

echo "####################### ORACLE INSTALLATION DONE #######################" >> $LOG_FILE

exit 0;

