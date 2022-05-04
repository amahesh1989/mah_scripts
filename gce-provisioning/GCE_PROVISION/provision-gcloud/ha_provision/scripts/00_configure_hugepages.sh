
echo "########## CLOUD LOGGINGAGENT INSTALL"

hst=`hostname`

curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
bash add-logging-agent-repo.sh
yum install -y google-fluentd
yum install -y google-fluentd-catch-all-config
cat <<EOF >> /etc/google-fluentd/config.d/${hst}.conf
<source>
  @type tail
  format none
  path /tmp/oracle_install/ha_provision/scripts/oracle_has_configure
  pos_file /var/lib/google-fluentd/pos/${hst}.pos
  read_from_head true
  tag ${hst}
</source> 
EOF
systemctl restart google-fluentd


mem=`cat /proc/meminfo |grep MemTotal |awk '{print $2}'`

echo "$mem/2048*0.75" |bc |awk -F"." '{print "vm.nr_hugepages="$1}' >> /etc/sysctl.conf

echo "Configuring Hugepages"

touch /tmp/hp_setup_complete
grubby --set-default /boot/vmlinuz-`uname -r`

for kernel in $(ls vmlinuz-*.x86_64 | sed 's/vmlinuz-//g')
do
   ln -s /usr/lib/modules/${kernel}/symvers.gz symvers-${kernel}.gz
done	  

reboot
