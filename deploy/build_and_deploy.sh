#!/bin/bash

./build.sh $*
if [ $? -eq 0 ] ; then
	./deploy.sh $*
fi
