# Siebel Open Variable Analyzer

Tool originally created by Timur Vafin for searching in Siebel repository for variables, which are not nullified.
Siebel garbage collector won't free memory for such objects, thus such variables are causing potential memory leaks.

##Siebel OVA utility performs following function

1. Analyzes eScript variables that has been opened but not closed ("null" are not assigned to variable) in the script
2. Searches for objects that has been opened using the following functions such as GetAssocBusComp, GetPicklistBusComp, this.BusObject, ActiveBusObject, GetBusObject, GetService, NewPropertySet but not nullified
3. Skips eScript comments in code
4. Takes under consideration multiple variables assignments like : var1 = var2 = var3 = <Something>

##Why this fork is created?
1. There is no any possibility to download original tool
2. Added Unix support
3. Improved variable filtering
4. Other minor fixes

## Prerequisites
1. Perl version 5.0 or higher
2. Oracle DB client
3. Oracle environment variables set, i.e. TNS_NAMES and ORACLE_HOME for user profile

## How to use it?
1. Create directory on your local PC

  ```sh
  mkdir ~/SiebelOVAnalyzer
  ```
2. Clone repository

  ```sh
  cd ~/SiebelOVAnalyzer
  git clone
  ```
3. Modify oracle database credentials in run.sh or run.bat file.

  ```sh
  LOGIN=SIEBEL/SIEBEL@SIEDEV
  ```
4. Run script

  ```sh
  ./run.sh
  ```
5. out.csv file contains findings
