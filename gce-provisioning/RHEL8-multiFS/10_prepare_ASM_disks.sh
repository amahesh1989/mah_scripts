
#!/bin/sh

echo "########## ASM DISK preparation ###############"

declare -A array_disk_mapping

array_disk_mapping["sdj"]="REG_DATA01"
array_disk_mapping["sdk"]="RECO01"
array_disk_mapping["sdl"]="REDOLOG01"
array_disk_mapping["sdm"]="REDOLOG02"
array_disk_mapping["sdn"]="TEMP01"
array_disk_mapping["sdo"]="GRID"

echo "Current disk mapping for ASM "
for key in ${!array_disk_mapping[@]}; do
    echo ${key} ${array_disk_mapping[${key}]}
done

for CURRENT_FS in ${!array_disk_mapping[@]}; 
do 
    echo $CURRENT_FS; 
    echo "########## ASM DISK $CURRENT_FS / $array_disk_mapping["$CURRENT_FS"] preparation ###############"

if [ ! -e "${CURRENT_FS}1" ]; then
   echo -e "n\np\n1\n\n\nw" | fdisk /dev/$CURRENT_FS
fi
 
ASM_DISK1=$(/usr/lib/udev/scsi_id -g -u -d /dev/$CURRENT_FS)

SYMLINK_VALUE=${array_disk_mapping["$CURRENT_FS"]}

cat >> /etc/udev/rules.d/99-oracle-asmdevices.rules <<EOF
KERNEL=="sd?1", SUBSYSTEM=="block", PROGRAM=="/usr/lib/udev/scsi_id -g -u -d /dev/\$parent", RESULT=="${ASM_DISK1}", SYMLINK+="oracleasm/$SYMLINK_VALUE", OWNER="oracle", GROUP="dba", MODE="0660"
EOF
 
 
cat /etc/udev/rules.d/99-oracle-asmdevices.rules
 
/sbin/partprobe "/dev/${CURRENT_FS}1"
sleep 10
/sbin/udevadm control --reload-rules
sleep 10
/sbin/partprobe "/dev/${CURRENT_FS}1"
sleep 10
/sbin/udevadm control --reload-rules
sleep 10
echo "Disks under /dev/oracleasm"
ls -al /dev/oracleasm/*
done

