#!/bin/bash
export CAPSTONE_PATH=`pwd`
sudo docker run -v $CAPSTONE_PATH/lus:/lus kind2/kind2:dev  --compile true /lus/simple.lus
sudo chown $USER -R lus/simple.lus.out/
