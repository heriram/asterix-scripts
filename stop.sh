#!/bin/bash

# READ VARIABLES
source asterix.config

echo "----------------------------"
echo "Stopping AsterixDB"

echo "Stop existing cluster"
$MANAGIX stop -n $INSTANCE_NAME

echo "Kill Java-processes"
kill `jps | egrep '(CDriver|NCService)' | awk '{print $1}'`

echo "Done!"
