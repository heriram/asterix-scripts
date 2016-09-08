#!/bin/bash

echo "----------------------------"
echo "Restarting AsterixDB"

/bin/bash stop_asterix.sh

/bin/bash start_asterix.sh

echo "----------------------------"
echo "AsterixDB restarted!"
