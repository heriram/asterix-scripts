#!/bin/bash
# Run with rebuild to force build: ./fresh_asterix.sh rebuild
# READ VARIABLES
source asterix.config

# Override MANAGIX
MANAGIX=~/managix/bin/managix

echo "----------------------------"
date
echo "Installing a fresh AsterixDB"

echo "Stop existing cluster"
$MANAGIX stop -n $INSTANCE_NAME

echo "Delete existing cluster"
$MANAGIX delete -n $INSTANCE_NAME

echo "Kill Java-processes"
kill `jps | egrep '(CDriver|NCService)' | awk '{print $1}'`

if [ ! -d `echo ~/asterixdb` ]; then
	echo "Clone into repository"
	git clone git@github.com:apache/asterixdb.git ~/asterixdb
fi

echo "Pull latest master"
UPDATE=`git -C ~/asterixdb pull`
echo $UPDATE

if [ "$1" = "rebuild" ] ;then
	REBUILD='y'
else
	if [ "$UPDATE" = "Already up-to-date." ] ;then
		echo "Repository already up-to-date"
		REBUILD='n'
	else
		echo -n "Repository updated, re-build asterix? (y/n)? "
		read REBUILD
	fi
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
$MANAGIX configure

echo "Validate managix"
$MANAGIX validate

echo "Create new cluster"
$MANAGIX create -n $INSTANCE_NAME -c ~/managix/clusters/local/local.xml

echo "Stopping cluster"
$MANAGIX stop -n $INSTANCE_NAME

echo "Kill Java-processes"
kill `jps | egrep '(CDriver|NCService)' | awk '{print $1}'`

echo "Installing library"
$MANAGIX install -n $INSTANCE_NAME -d $DATAVERSE -l $LIB_NAME -p $LIB_PATH

echo "Starting cluster"
$MANAGIX start -n $INSTANCE_NAME

echo "Done!"
