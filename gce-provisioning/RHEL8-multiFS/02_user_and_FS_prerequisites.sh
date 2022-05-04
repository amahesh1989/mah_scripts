
#!/bin/sh

echo "## User creation  ###"


echo "## CREATE GROUPS "

groupadd -g 54327 asmdba
groupadd -g 54328 asmoper
groupadd -g 54329 asmadmin
groupadd -g 54321 oinstall
groupadd -g 54322 dba
groupadd -g 54323 oper
groupadd -g 54324 backupdba
groupadd -g 54325 dgdba
groupadd -g 54326 kmdba
groupadd -g 54330 racdba

echo "## CREATE ORACLE User "

adduser -u 54321 -g oinstall -G dba,oper oracle

cat <<EOF >> /home/oracle/.bashrc
     
 #  Oracle RDBMS Settings:
 export ORACLE_SID=ORCL
 export ORACLE_BASE=/u01/app/oracle
 export ORACLE_HOME=\${ORACLE_BASE}/product/19.0.0.0/dbhome_1
 export GRID_HOME=/u01/app/oragrid/product
 export PATH=\${ORACLE_HOME}/bin:\${PATH}
 export SWLIB=/u01/app/oracle_software
EOF

 usermod -u 54321 -g oinstall -G dba,asmadmin,asmdba,asmoper,oper,oinstall oracle
 
 echo "umask 022" >> /home/oracle/.bashrc

chown oracle:oinstall -R /home/oracle 

echo "## CREATE ORAGRID User "

adduser -u 54322 -g oinstall -G dba,oper oragrid

cat <<EOF >> /home/oragrid/.bashrc
     
 #  Oracle RDBMS Settings:
 export ORACLE_SID=+ASM
 export ORACLE_BASE=/u01/app/oracle
 export ORACLE_HOME=/u01/app/oragrid/product
 export GRID_HOME=/u01/app/oragrid/product
 export PATH=\${ORACLE_HOME}/bin:\${GRID_HOME}:\${PATH}
 export SWLIB=/u01/app/oracle_software
EOF

 usermod -u 54322 -g oinstall -G dba,asmadmin,asmdba,asmoper,oinstall oragrid
 
 echo "umask 022" >> /home/oragrid/.bashrc

chown oragrid:oinstall -R /home/oragrid 


echo "## Disk mount ###"

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
    	echo "Mount $CURRENT_DISK on ${array_disk_mapping[${CURRENT_DISK}]}";
    	mkdir -p ${array_disk_mapping[${CURRENT_DISK}]}
    	mkfs.ext4 /dev/$CURRENT_DISK
    	mount -o discard,defaults /dev/$CURRENT_DISK ${array_disk_mapping[${CURRENT_DISK}]}
    	UUID_U01=$(blkid /dev/$CURRENT_DISK |  awk -F '"' '{print $2}')
    	echo "UUID=$UUID_U01 ${array_disk_mapping[${CURRENT_DISK}]} ext4 discard,defaults,nofail 0 2" >> /etc/fstab
    fi
done

echo "## Create the target directories"

mkdir -p /u01/app/oracle/product/19.0.0.0/dbhome_1
mkdir -p /u01/app/oracle/fast_recovery_area
mkdir -p /u01/app/oracle_software
mkdir -p /home/oracle/working
mkdir -p /home/oragrid/working
chown -R oracle:oinstall /home/oracle/working
chown -R oragrid:oinstall /home/oragrid/working


mkdir -m 755 /u01  
chgrp oinstall /u01  
cd /opt/ 
mkdir oracle  
mkdir -m 755 -p /opt/oracle/extapi/64/asm/orcl/1  
mkdir -p /u01/app/oracle/product  
mkdir -p /u01/app/oracle/agent  
mkdir -p /u01/app/oragrid/product  
mkdir -m 775 -p /u01/app/oraInventory  
mkdir -p /u01/app/grid_base  
mkdir -m 755 -p /u01/app/grid_base/admin/common  
mkdir -m 760 -p /u01/app/grid_base/admin/common/pki/stage  
mkdir -m 760 -p /u01/app/grid_base/admin/common/pki/wallet  
mkdir -m 775 -p /u01/app/oracle/admin  
mkdir -m 775 -p /u01/app/oracle/backup  
mkdir -m 775 -p /u01/app/oracle/diag  
chown root.oinstall /u01  
chmod 775 /u01/app  
chgrp oinstall /u01/app  
chown -R oragrid.oinstall /u01/app/oraInventory  
chown -R oragrid.oinstall /u01/app/grid_base  
chown -R oragrid.oinstall /u01/app/oragrid/*  
chgrp oinstall /u01/app/oragrid  
chmod 775 /u01/app/oragrid 
chown -R oracle.oinstall /u01/app/oracle
chmod -R g+wx /u01/app/

 



