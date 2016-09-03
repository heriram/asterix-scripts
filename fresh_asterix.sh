#!/bin/bash
sudo mkdir -p ~/logs
LOG=~/logs/fresh_asterix.log

echo "----------------------------" >> $LOG
date >> $LOG
echo "Installing a fresh AsterixDB" >> $LOG

echo "Stop existing cluster" >> $LOG
~/managix/bin/managix stop -n test

echo "Delete existing cluster" >> $LOG
~/managix/bin/managix delete -n test

echo "Kill Java-processes" >> $LOG
kill `jps | egrep '(CDriver|NCService)' | awk '{print $1}'`

echo "Pull latest master" >> $LOG
UPDATE=`git -C ~/asterixdb pull`
echo $UPDATE

if echo "$UPDATE" | grep -iq "Already up-to-date." ;then
    echo "Repository already up-to-date" >> $LOG
    REBUILD='n'
else
    echo -n "Repository updated, re-build asterix? (y/n)? "
    read REBUILD
fi

if echo "$REBUILD" | grep -iq "^y" ;then
    echo "Rebuild" >> $LOG 
	sudo mvn -f ~/asterixdb/pom.xml clean package -DskipTests
else
    echo "Skipping rebuilding" >> $LOG 
fi

echo "Clean managix directory" >> $LOG
sudo rm -rf ~/managix && mkdir ~/managix

echo "Copy installer" >> $LOG
cp ~/asterixdb/asterixdb/asterix-installer/target/asterix-installer-*-binary-assembly.zip ~/managix/

echo "Unzip installer" >> $LOG
unzip ~/managix/asterix-installer-*-binary-assembly.zip -d ~/managix/

echo "Configure managix" >> $LOG
~/managix/bin/managix configure

echo "Validate managix" >> $LOG
~/managix/bin/managix validate

echo "Create new cluster" >> $LOG
~/managix/bin/managix create -n test -c ~/managix/clusters/local/local.xml

echo "Stopping cluster" >> $LOG 
~/managix/bin/managix stop -n test

echo "Kill Java-processes" >> $LOG
kill `jps | egrep '(CDriver|NCService)' | awk '{print $1}'`

echo "Installing testlib" >> $LOG 
~/managix/bin/managix install -n test -d feeds -l testlib -p asterixdb/asterixdb/asterix-external-data/target/testlib-zip-binary-assembly.zip

echo "Starting cluster" >> $LOG 
~/managix/bin/managix start -n test

echo "Done!" >> $LOG
