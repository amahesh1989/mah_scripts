
#!/bin/sh

echo "########## DOWNLOAD ORACLE ZIP FILES - RDMBS,GRID,PATCHES AND OPATCH ###############"

ORACLE_BINARY_BUCKET=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/ORACLE_BINARY_BUCKET -H "Metadata-Flavor: Google")
GRID_FILE=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/GRID_FILE -H "Metadata-Flavor: Google")
RDBMS_FILE=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/RDBMS_FILE -H "Metadata-Flavor: Google")
DBCA_TEMPLATES=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/DBCA_TEMPLATES -H "Metadata-Flavor: Google")


if [[ $ORACLE_BINARY_BUCKET == *"Error 404"* ]] 
then 
  echo "ORACLE_BINARY_BUCKET Metadata not found"
  exit 1
fi

if [[ $GRID_FILE == *"Error 404"* ]] 
then 
  echo "GRID_FILE Metadata not found"
  exit 1
fi

if [[ $RDBMS_FILE == *"Error 404"* ]] 
then 
  echo "RDBMS_FILE Metadata not found"
  exit 1
fi

if [[ $DBCA_TEMPLATES == *"Error 404"* ]]
then
  echo "DBCA_TEMPLATES Metadata not found"
  exit 1
fi


ORACLE_SOFTWARE_DIR=/u01/app/oracle_software
TEMPLATE_DIR=/u01/app/oracle/admin/common/templates/

gsutil cp gs://$ORACLE_BINARY_BUCKET/$RDBMS_FILE $ORACLE_SOFTWARE_DIR/
gsutil cp gs://$ORACLE_BINARY_BUCKET/$GRID_FILE $ORACLE_SOFTWARE_DIR/



## Download oracle patch
ORACLE_PATCH=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/ORACLE_PATCH -H "Metadata-Flavor: Google")

gsutil cp gs://$ORACLE_BINARY_BUCKET/$ORACLE_PATCH $ORACLE_SOFTWARE_DIR/

## Download OPatch
OPATCH_PATCH=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/OPATCH_PATCH -H "Metadata-Flavor: Google")
gsutil cp gs://$ORACLE_BINARY_BUCKET/$OPATCH_PATCH $ORACLE_SOFTWARE_DIR/

chown -R oracle:oinstall $ORACLE_SOFTWARE_DIR/
chmod -R ug+rw $ORACLE_SOFTWARE_DIR/

mkdir -p $TEMPLATE_DIR
gsutil cp gs://$ORACLE_BINARY_BUCKET/$DBCA_TEMPLATES $TEMPLATE_DIR
cd $TEMPLATE_DIR
unzip ./$DBCA_TEMPLATES
chown -R oracle:oinstall $TEMPLATE_DIR

