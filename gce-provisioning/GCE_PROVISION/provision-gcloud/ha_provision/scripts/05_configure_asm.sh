echo "Creating ASM instance"

${ORACLE_HOME}/bin/asmca -silent -configureASM -sysAsmPassword I3ThdSPg -asmsnmpPassword I3ThdSPg -param diagnostic_dest=${ORACLE_BASE} -param audit_file_dest=${ORACLE_BASE}/admin/+ASM/adump  -param processes=512 -param memory_target=512M -diskString 'AFD:*','/dev/sd*' -diskGroupName REG_DATA01 -diskList AFD:REGDATA01* -redundancy EXTERNAL -compatible.asm 19.0.0.0.0 -compatible.rdbms 19.0.0.0.0

chmod 6751 $ORACLE_HOME/bin/oracle

echo "Creating Diskgroups"

asmca -silent -createDiskGroup -diskGroupName RECO01 -disk 'AFD:RECO01*' -redundancy EXTERNAL

asmca -silent -createDiskGroup -diskGroupName REDOLOG01 -disk 'AFD:REDOLOG01*' -redundancy EXTERNAL

asmca -silent -createDiskGroup -diskGroupName REDOLOG02 -disk 'AFD:REDOLOG02*' -redundancy EXTERNAL

asmca -silent -createDiskGroup -diskGroupName TEMP01 -disk 'AFD:TEMP01*' -redundancy EXTERNAL
