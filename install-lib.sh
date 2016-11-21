#!/bin/bash

# READ VARIABLES
source asterix.config

echo "----------------------------"
date
echo "Installing library"

# Stop Asterix
/bin/bash stop.sh

echo "Uninstall existing library"
$MANAGIX uninstall -n $INSTANCE_NAME -d $DATAVERSE -l $LIB_NAME

echo "Packaging library"
mvn -f $LIB_DIR/pom.xml clean package -DskipTests

echo "Installing library"
$MANAGIX install -n $INSTANCE_NAME -d $DATAVERSE -l $LIB_NAME -p $LIB_PATH

# Start Asterix
/bin/bash start.sh

echo "Library installed!"
echo "----------------------------"
