#!/bin/bash

DEV_DIR=../..

if [ ! -d $DEV_DIR ]; then
  mkdir $DEV_DIR
fi

meteor build --server https://mijn.mxi.nl --debug $DEV_DIR/build
