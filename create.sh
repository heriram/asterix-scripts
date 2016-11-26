#!/bin/bash

# READ VARIABLES
source asterix.config

echo "----------creating----------"

echo "Configure managix"
$MANAGIX configure

echo "Validate managix"
$MANAGIX validate

echo "Creating new cluster"
$MANAGIX create -n $INSTANCE_NAME -c $CLUSTER_CONFIG

echo "----------created-----------"
