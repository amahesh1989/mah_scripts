
#!/bin/sh

echo "####################### START OS PREREQUISITES SCRIPT #######################"
### Yum prerequisites

echo "########## CLOUD LOGGINGAGENT INSTALL"

curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
bash add-logging-agent-repo.sh
yum install -y google-fluentd
yum install -y google-fluentd-catch-all-config
cat <<EOF > /etc/google-fluentd/config.d/custom-oracleinstall.conf
<source>
  @type tail
  format none
  path /tmp/oracle_install/installation_logs
  pos_file /var/lib/google-fluentd/pos/custom-oracle-install.pos
  read_from_head true
  tag custom-oracle-install
</source> 
EOF
systemctl restart google-fluentd

echo "########## PACKAGES PREREQUISITES ###############"

dnf -y install wget java-11-openjdk gcc gcc-c++ unzip smartmontools

dnf install -y bc binutils elfutils-libelf elfutils-libelf-devel fontconfig-devel glibc glibc-devel ksh libaio libaio-devel libXrender libXrender-devel libX11 libXau libXi libXtst libgcc librdmacm-devel libstdc++ libstdc++-devel  libxcb make net-tools nfs-utils python3 python3-configshell  python3-rtslib python3-six targetcli 

yum install libvirt-devel -y 

dnf install -y https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/oracle-database-preinstall-19c-1.0-1.el8.x86_64.rpm

echo "########## CREATE SWAP ###############"

dd if=/dev/zero of=/swapfile bs=1M count=16384
mkswap /swapfile
chmod 0600 /swapfile
swapon /swapfile
echo "/swapfile          swap            swap    defaults        0 0" >> /etc/fstab

echo "########## ENABLE HUGEPAGE ###############"

cat /sys/kernel/mm/transparent_hugepage/enabled
echo "transparent_hugepage=never" >> /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

### SELINUX and security

echo "########## MODIFY SELINUX ###############"

sed -i  '/^SELINUX=/ s/SELINUX=.*/SELINUX=permissive/' /etc/selinux/config
cat /etc/selinux/config | grep SELINUX

echo "vm.nr_hugepages=4096" >> /etc/sysctl.conf

## set the symlink for RHEL8
cd /boot
ln -s /usr/lib/modules/4.18.0-193.19.1.el8_2.x86_64/symvers.gz symvers-4.18.0-193.19.1.el8_2.x86_64.gz
ln -s /usr/lib/modules/4.18.0-193.el8.x86_64/symvers.gz symvers-4.18.0-193.el8.x86_64.gz
