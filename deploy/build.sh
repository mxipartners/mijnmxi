#!/bin/bash

DEV_DIR=../..

if [ ! -d $DEV_DIR ]; then
  mkdir $DEV_DIR
fi

meteor build --server mijn.mxi.nl $DEV_DIR/build
