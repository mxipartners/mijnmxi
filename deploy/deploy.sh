#!/bin/bash

DEV_DIR=..
DEV_USER=deploy
DEPLOY_FILE=$DEV_DIR/build/mijnmxi.tar.gz
KEY_FILE=$HOME/.mijn.mxi.nl.key_rsa
RESET_DB=

# Test for presence of key file
if [ ! -f $KEY_FILE ]; then
	echo "Key file is missing. Please contact the administrator"
	exit 1
fi

# Test for presence of deploy file
if [ ! -f $DEPLOY_FILE ]; then
	echo "Deploy file is missing. Please build it first using \"./build.sh\""
	exit 1
fi

# Show warning if deploy file is old
if [ "$(( $(date +"%s") - $(stat -f "%m" $DEPLOY_FILE) ))" -gt "7200" ]; then
	echo "Warning the deployment file is older than 2 hours"
	read -p "Press [Enter] key to deploy (or CTRL-C to abort)..."
fi

# Sanity check for remote deployment script
if [ ! -f ./server_deploy.sh ]; then
	echo "The server deployment file \"server_deployment.sh\" is missing. Please contact the administrator"
	exit 1
fi

# Test whether database should be reset
for i in "$@" ; do
	if [ "$i" == "--reset" ]; then
		RESET_DB="--reset"
		break
	fi
done

scp -i $KEY_FILE $DEV_DIR/build/mijnmxi.tar.gz $DEV_USER@mijn.mxi.nl:./work
scp -i $KEY_FILE ./server_deploy.sh $DEV_USER@mijn.mxi.nl:./work
ssh -i $KEY_FILE -t $DEV_USER@mijn.mxi.nl "cd work; chmod u+x ./server_deploy.sh; sudo ./server_deploy.sh $RESET_DB mijnmxi.tar.gz"
