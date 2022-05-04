. /tmp/oracle_install/ha_provision/scripts/set_env

chown -R oragrid.oinstall /tmp/oracle_install
chmod -R g+rwx /tmp/oracle_install

if [[ ! -f /tmp/hp_setup_complete ]];then
${WORKING_DIR}/00_configure_hugepages.sh >> $LOGFILE
fi
${WORKING_DIR}/01_mount_fs.sh >> $LOGFILE
${WORKING_DIR}/02_configure_ha.sh >> $LOGFILE
su -c ${WORKING_DIR}/03_start_listener.sh - oragrid >> $LOGFILE
${WORKING_DIR}/04_configure_afd_disks.sh >> $LOGFILE
su -c ${WORKING_DIR}/05_configure_asm.sh - oragrid >> $LOGFILE
su -c ${WORKING_DIR}/06_create_database.sh - oracle >> $LOGFILE
su -c ${WORKING_DIR}/07_post_database_script.sh - oracle >> $LOGFILE
su -c ${WORKING_DIR}/08_change_profile.sh - oragrid >> $LOGFILE
su -c ${WORKING_DIR}/08_change_profile.sh - oracle >> $LOGFILE
${WORKING_DIR}/09_cleanup_files.sh >> $LOGFILE
