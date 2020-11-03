#!/bin/bash
set -x
SLAVE_FILE=slaves
SSH="ssh -o StrictHostKeyChecking=no"
SCP="scp -o StrictHostKeyChecking=no"

while read -u 3 -r SLAVE
do
#	$SCP -r $1 $SLAVE:$2
	$SCP -r $SLAVE:$1 $2
done 3< $SLAVE_FILE
