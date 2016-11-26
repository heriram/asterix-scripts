#!/bin/bash

# READ VARIABLES
source asterix.config

echo "----------starting----------"

echo "Start existing cluster"
x="$($MANAGIX start -n $INSTANCE_NAME)"

echo $x
if [ "$x" = "ERROR: Asterix instance by name test does not exist." ] ;then
	/bin/bash create.sh
fi

echo "----------started-----------"
