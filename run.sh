#!/bin/bash
SELF="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEMP=/tmp

#ORACLE_HOME=C:\Administration\SiebelOVAnalyzer\oraclnt
#TNS_ADMIN=C:\Administration\SiebelOVAnalyzer
LOGIN=SIEBEL/SIEBEL@SIEDEV
echo Downloading eScripts from Oracle Database...
sqlplus -S $LOGIN @$SELF/getlst.sql $TEMP/
echo Analysing eScripts for open variables...
TERM=dumb
perl $SELF/parselst.pl $TEMP