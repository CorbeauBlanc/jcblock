#!/bin/bash
cd /home/pi/jcblock
echo "Waiting for initialization..." | tee -a jcblock.log
sleep 30
echo "Starting jcblockAT..." | tee -a jcblock.log
./jcblockAT | tee -a jcblock.log
echo "Unexpected termination of jcblockAT" | tee -a jcblock.log