
#!/bin/sh

echo "########## GENERATE A TEMPORARY FS FOR GRID ###############"

echo "tmpfs           /dev/shm        tmpfs   size=16g         0 0" >> /etc/fstab
mount -a
