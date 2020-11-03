#!/bin/bash
set -x
SLAVE_FILE=slaves
SSH="ssh -o StrictHostKeyChecking=no"
SCP="scp -o StrictHostKeyChecking=no"

while read -u 3 -r SLAVE
do
	$SSH $SLAVE $1
done 3< $SLAVE_FILE
