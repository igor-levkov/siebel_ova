@echo off
SET SELF=%~dp0
SET TEMP=%SELF%\tmp

@rem set ORACLE_HOME=C:\Administration\SiebelOVAnalyzer\oraclnt
@rem set TNS_ADMIN=C:\Administration\SiebelOVAnalyzer
set LOGIN=SIEBEL/SIEBEL@SIEDEV
echo Downloading eScripts from Oracle Database...
sqlplus -S %LOGIN% @%SELF%\getlst.sql $TEMP\
echo Analysing eScripts for open variables...
set TERM=dumb
perl %SELF%\parselst.pl %TEMP%