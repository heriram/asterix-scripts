#!/bin/bash

echo "----------------------------"
echo "Restarting AsterixDB"

/bin/bash stop.sh

/bin/bash start.sh

echo "----------------------------"
echo "AsterixDB restarted!"
