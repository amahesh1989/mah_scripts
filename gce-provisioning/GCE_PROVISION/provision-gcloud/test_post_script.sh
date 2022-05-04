#!/bin/sh

INSTALLATION_DIR=/tmp/oracle_install
SCRIPTS_BUCKET=oracle-bin-dbapoc
OS_SUBDIR=ha_provision

[ ! -d "$INSTALLATION_DIR" ] && mkdir -p "$INSTALLATION_DIR" && gsutil cp -r gs://$SCRIPTS_BUCKET/$OS_SUBDIR $INSTALLATION_DIR/

chmod -R u+x $INSTALLATION_DIR/* 

cd ${INSTALLATION_DIR}/${OS_SUBDIR}/scripts

${INSTALLATION_DIR}/${OS_SUBDIR}/scripts/run_all.sh
