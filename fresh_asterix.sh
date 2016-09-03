#!/bin/bash
sudo mkdir -p ~/logs
LOG_OUTPUT="tee | `echo ~/logs/fresh_asterix.log`"
CONSOLE_OUTPUT="tee"

# VARIABLES
OUTPUT=$LOG_OUTPUT # set to LOG_OUTPUT to save to file
INSTANCE_NAME="test"
FEED_NAME="feeds"
LIB_NAME="testlib"
LIB_PATH="asterixdb/asterixdb/asterix-external-data/target/testlib-zip-binary-assembly.zip"

echo "----------------------------" | $OUTPUT
date | $OUTPUT
echo "Installing a fresh AsterixDB" | $OUTPUT

echo "Stop existing cluster" | $OUTPUT
~/managix/bin/managix stop -n $INSTANCE_NAME

echo "Delete existing cluster" | $OUTPUT
~/managix/bin/managix delete -n $INSTANCE_NAME

echo "Kill Java-processes" | $OUTPUT
kill `jps | egrep '(CDriver|NCService)' | awk '{print $1}'`

echo "Pull latest master" | $OUTPUT
UPDATE=`git -C ~/asterixdb pull`
echo $UPDATE

if echo "$UPDATE" | grep -iq "Already up-to-date." ;then
	echo "Repository already up-to-date" | $OUTPUT
	REBUILD='n'
else
	echo -n "Repository updated, re-build asterix? (y/n)? "
	read REBUILD
fi

if echo "$REBUILD" | grep -iq "^y" ;then
	echo "Rebuild" | $OUTPUT
	sudo mvn -f ~/asterixdb/pom.xml clean package -DskipTests
else
	echo "Skipping rebuilding" | $OUTPUT
fi

echo "Clean managix directory" | $OUTPUT
sudo rm -rf ~/managix && mkdir ~/managix

echo "Copy installer" | $OUTPUT
cp ~/asterixdb/asterixdb/asterix-installer/target/asterix-installer-*-binary-assembly.zip ~/managix/

echo "Unzip installer" | $OUTPUT
unzip ~/managix/asterix-installer-*-binary-assembly.zip -d ~/managix/

echo "Configure managix" | $OUTPUT
~/managix/bin/managix configure

echo "Validate managix" | $OUTPUT
~/managix/bin/managix validate

echo "Create new cluster" | $OUTPUT
~/managix/bin/managix create -n $INSTANCE_NAME -c ~/managix/clusters/local/local.xml

echo "Stopping cluster" | $OUTPUT
~/managix/bin/managix stop -n $INSTANCE_NAME

echo "Kill Java-processes" | $OUTPUT
kill `jps | egrep '(CDriver|NCService)' | awk '{print $1}'`

echo "Installing library" | $OUTPUT
~/managix/bin/managix install -n $INSTANCE_NAME -d $FEED_NAME -l $LIB_NAME -p $LIB_PATH

echo "Starting cluster" | $OUTPUT
~/managix/bin/managix start -n $INSTANCE_NAME

echo "Done!" | $OUTPUT
