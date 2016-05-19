#!/bin/bash

RESET_DB=

if [ "$1" == "--reset" ]; then
	RESET_DB=TRUE
	shift
fi

if [ "$1" == "" ]; then
	echo "No meteor application (gzipped tarball of bundle) specified"
	exit 1
fi

if [ ! -f "$1" ]; then
	echo "File $1 does not exist"
	exit 1
fi

if [ "${1%.tgz}" == "$1" ]; then
	if [ "${1%.tar.gz}" == "$1" ]; then
		echo "File should be gzipped tarball (end in .tgz or .tar.gz)"
		exit 1
	else
		APP_NAME="${1%.tar.gz}"
	fi
else
	APP_NAME="${1%.tgz}"
fi

echo "Stopping $APP_NAME"
service "$APP_NAME" stop
if [ "$?" != "0" ]; then
	echo "Failed to stop service $APP_NAME"
	echo "Continuing anyway"
fi

if [ "$RESET_DB" != "" ]; then
	echo "Removing database content"
	cat <<EOF | mongo
use $APP_NAME
db.dropDatabase()
EOF
fi

BUNDLE_DIR="/usr/share/meteor/bundles/$APP_NAME"
BUNDLE_DIR_OLD="${BUNDLE_DIR}.old"
if [ -d "$BUNDLE_DIR_OLD" ]; then
	echo "Removing 'old' bundle"
	rm -rf "$BUNDLE_DIR_OLD"
fi
if [ -d "$BUNDLE_DIR" ]; then
	echo "Moving bundle to $BUNDLE_DIR_OLD"
	mv "$BUNDLE_DIR" "$BUNDLE_DIR_OLD"
fi

echo "Extracting $1 to meteor bundles"
mkdir "$BUNDLE_DIR"
tar xvzf "$1" -C "$BUNDLE_DIR"


echo "Building local packages"
cd "$BUNDLE_DIR/bundle/programs/server"
echo "HACK FOR bcrypt from MacOS X"
rm -rf npm/node_modules/meteor/npm-bcrypt
npm install
if [ "$?" != "0" ]; then
	echo "Failed to install local packages"
	exit 1
fi
npm install bcrypt
if [ "$?" != "0" ]; then
	echo "Failed to install local packages bcrypt (HACK)"
	exit 1
fi

echo "Starting $APP_NAME"
service "$APP_NAME" start
if [ "$?" != "0" ]; then
	echo "Failed to start service $APP_NAME"
	exit 1
fi

#echo "Cleaning up old bundle remains"
#rm -rf "$BUNDLE_DIR_OLD"
