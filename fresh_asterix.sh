#!/bin/bash

# READ VARIABLES
source asterix.config

echo "----------------------------"
date
echo "Installing a fresh AsterixDB"

echo "Stop existing cluster"
~/managix/bin/managix stop -n $INSTANCE_NAME

echo "Delete existing cluster"
~/managix/bin/managix delete -n $INSTANCE_NAME

echo "Kill Java-processes"
kill `jps | egrep '(CDriver|NCService)' | awk '{print $1}'`

if [ ! -d `echo ~/asterixdb` ]; then
	echo "Clone into repository"
	git clone git@github.com:apache/asterixdb.git ~/asterixdb
fi

echo "Pull latest master"
UPDATE=`git -C ~/asterixdb pull`
echo $UPDATE

if echo "$UPDATE" | grep -iq "Already up-to-date." ;then
	echo "Repository already up-to-date"
	REBUILD='n'
else
	echo -n "Repository updated, re-build asterix? (y/n)? "
	read REBUILD
fi

if echo "$REBUILD" | grep -iq "^y" ;then
	echo "Rebuild"
	mvn -f ~/asterixdb/pom.xml clean package -DskipTests
else
	echo "Skipping rebuilding"
fi

echo "Clean managix directory"
rm -rf ~/managix && mkdir ~/managix

echo "Copy installer"
cp ~/asterixdb/asterixdb/asterix-installer/target/asterix-installer-*-binary-assembly.zip ~/managix/

echo "Unzip installer"
unzip ~/managix/asterix-installer-*-binary-assembly.zip -d ~/managix/

echo "Configure managix"
~/managix/bin/managix configure

echo "Validate managix"
~/managix/bin/managix validate

echo "Create new cluster"
~/managix/bin/managix create -n $INSTANCE_NAME -c ~/managix/clusters/local/local.xml

echo "Stopping cluster"
~/managix/bin/managix stop -n $INSTANCE_NAME

echo "Kill Java-processes"
kill `jps | egrep '(CDriver|NCService)' | awk '{print $1}'`

echo "Installing library"
~/managix/bin/managix install -n $INSTANCE_NAME -d $FEED_NAME -l $LIB_NAME -p $LIB_PATH

echo "Starting cluster"
~/managix/bin/managix start -n $INSTANCE_NAME

echo "Done!"
