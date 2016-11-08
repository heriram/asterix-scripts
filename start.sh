#!/bin/bash

# READ VARIABLES
source asterix.config

echo "----------starting----------"

echo "Start existing cluster"
$MANAGIX start -n $INSTANCE_NAME

echo "----------started-----------"
