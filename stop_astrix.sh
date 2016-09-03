#!/bin/bash

echo "----------------------------"
echo "Stopping AsterixDB"

echo "Stop existing cluster"
~/managix/bin/managix stop -n test

echo "Kill Java-processes"
kill `jps | egrep '(CDriver|NCService)' | awk '{print $1}'`

echo "Done!"
