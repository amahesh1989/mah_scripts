declare -A array_disk_mapping

array_disk_mapping["sdb"]="/opt/oracle"
array_disk_mapping["sdc"]="/u01"
array_disk_mapping["sdd"]="/u01/app/oragrid/product"
array_disk_mapping["sde"]="/u01/app/oracle/product"
array_disk_mapping["sdf"]="/u01/app/oracle/agent"
array_disk_mapping["sdg"]="/u01/app/oracle/diag"
array_disk_mapping["sdh"]="/u01/app/oracle/admin"
array_disk_mapping["sdi"]="/u01/app/oracle/backup"

for CURRENT_DISK in $(lsblk --output NAME | grep -E '^sd[b-i]' ) ; do
    if df | grep $CURRENT_DISK
    then
            echo "$CURRENT_DISK already mounted "
    else
        echo "Mounting ${array_disk_mapping[${CURRENT_DISK}]}";
        mkdir -p ${array_disk_mapping[${CURRENT_DISK}]}
        mount -o discard,defaults /dev/${CURRENT_DISK}1 ${array_disk_mapping[${CURRENT_DISK}]}
sleep 2
        #UUID_U01=$(blkid /dev/$CURRENT_DISK |  awk -F '"' '{print $2}')
        echo "/dev/${CURRENT_DISK}1 ${array_disk_mapping[${CURRENT_DISK}]} ext4 discard,defaults,nofail 0 2" >> /etc/fstab
    fi
done

systemctl daemon-reload
