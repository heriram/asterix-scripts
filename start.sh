#!/bin/bash

# READ VARIABLES
source asterix.config

echo "----------------------------"
echo "Starting AsterixDB"

echo "Start existing cluster"
$MANAGIX start -n $INSTANCE_NAME

echo "Done!"
