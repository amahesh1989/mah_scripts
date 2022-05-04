#!/bin/sh
echo " ALTER SYSTEM SET processes=1500 scope=spfile;
ALTER SYSTEM SET memory_target=2048M scope=spfile;
alter system set asm_diskgroups='REDOLOG01','REDOLOG02','REG_DATA01','TEMP01','RECO01','GRID' scope=both;
alter system set asm_diskstring='/dev/oracleasm/*','AFD:*' scope=both;
alter diskgroup all mount;
alter system set local_listener='(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=<hostname>)(PORT=1725)))' scope=both;
" | sqlplus -s / as sysasm
