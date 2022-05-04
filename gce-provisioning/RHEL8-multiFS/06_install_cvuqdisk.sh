
#!/bin/sh

echo "########## INSTALL CVUQDISK PREREQUISITES ###############"

cd /u01/app/oragrid/product/cv/rpm/
rpm -qi cvuqdisk

 CVUQDISK_GRP=oinstall; export CVUQDISK_GRP
 rpm -iv cvuqdisk-*.rpm




