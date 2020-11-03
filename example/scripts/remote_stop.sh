#!/bin/bash
set -x
SLAVE_FILE=slaves
SSH="ssh -o StrictHostKeyChecking=no"
SCP="scp -o StrictHostKeyChecking=no"

while read -u 3 -r SLAVE
do
	$SSH $SLAVE "pkill -9 nvidia-smi"
	$SSH $SLAVE "pkill -9 python3"
done 3< $SLAVE_FILE
