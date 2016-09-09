# asterix-scripts
A collection of scripts to automate processes regarding the development of AsterixDB

## Description

### asterix.config
Set parameters used by the scripts

| Parameter | Description |
|-----------|-------------|
| INSTANCE_NAME | Name of the AsterixDB instance |
| DATAVERSE | Name of the Dataverse which the the library will be installed to | 
| LIB_NAME | Name of the library to be installed |
| LIB_PATH | Path to the library to be installed |

### update.sh
Pulls the latest changes on AsterixDB, rebuilds the project and restarts the instance

Run with parameter **rebuild** to force rebuilding, else it checks for changes and promts you to choose rebuild if repository is updated.
eg. `./update.sh rebuild`

### stop.sh
Stops running instance and kills related processes

### start.sh
Spins up the AsterixDB instance

### restart.sh
Runs `stop.sh` and `start.sh` in sequence
