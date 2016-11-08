#!/bin/bash

echo "----------------------------"
date
echo "Restarting AsterixDB"

/bin/bash stop.sh

/bin/bash start.sh

echo "AsterixDB restarted!"
echo "----------------------------"
