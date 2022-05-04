. /tmp/oracle_install/ha_provision/scripts/set_env

$ORACLE_HOME/bin/crsctl stop has

$ORACLE_HOME/bin/asmcmd afd_configure

$ORACLE_HOME/bin/crsctl start has -wait

sleep 5

echo "Configuring AFD"

for i in regdata01 redolog01 redolog02 reco01 temp01
do
        k=1
        for j in `ls -l /dev/disk/by-id/scsi*${i}* |grep -v [0-9]$ |awk -F"/" '{print $NF}'`
        do
                if fdisk -l /dev/${j} |grep Device;then
                        echo "$j already partitioned"
                else
                        echo -e "n\np\n1\n\n\nw" | fdisk /dev/${j}
                        $ORACLE_HOME/bin/asmcmd afd_label ${i}0${k} /dev/${j}1
                fi
                k=$(( $k + 1 ))
        done
done

$ORACLE_HOME/bin/asmcmd afd_lsdsk
