
#!/bin/sh

echo "########## UNZIP THE FILES ###############"

unzip -q ${SWLIB}/V982068-01.zip -d ${GRID_HOME}

##Unzip the patch
unzip -o -q ${SWLIB}/p31305339_190000_Linux-x86-64.zip -d ${GRID_HOME}
## Unzip the Opatch update
unzip -o -q ${SWLIB}/p6880880_190000_Linux-x86-64.zip -d ${GRID_HOME}

