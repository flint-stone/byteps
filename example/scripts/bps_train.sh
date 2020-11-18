#!/bin/bash
set -x

SSH="ssh -o StrictHostKeyChecking=no"
SCRIPT_PATH="/mydata/lexu/byteps/example/scripts"
DMLC_NUM_WORKER=4
#DMLC_ROLE=scheduler
DMLC_NUM_SERVER=4
DMLC_PS_ROOT_URI="10.10.1.1"
DMLC_PS_ROOT_PORT="12345"
EPOCH=2
SLAVE_FILE=slaves
SCRIPT="${SCRIPT_PATH}/benchmark_byteps.py"
MODEL="resnet50" #"roberta"
NUM_ITERS=200
BATCH_SIZE=128 #560
DATASET="/mnt/tiny-imagenet-200"


while read -u 3 -r SLAVE
do
	#SLAVE="localhost"
	OUTPUT_FILE="/mnt/bps-scheduler-${MODEL}.log"
	command="export BYTEPS_SERVER_ENGINE_THREAD=10 && $SCRIPT_PATH/bps_scheduler.sh $DMLC_NUM_WORKER $DMLC_NUM_SERVER $DMLC_PS_ROOT_URI $DMLC_PS_ROOT_PORT $OUTPUT_FILE"
	$SSH $SLAVE $command

	OUTPUT_FILE="/mnt/bps-server-${MODEL}.log"
	command="export BYTEPS_SERVER_ENGINE_THREAD=10 && $SCRIPT_PATH/bps_server.sh $DMLC_NUM_WORKER $DMLC_NUM_SERVER $DMLC_PS_ROOT_URI $DMLC_PS_ROOT_PORT $OUTPUT_FILE"
	$SSH $SLAVE $command
done 3< $SLAVE_FILE
sleep 2
id=0
while read -u 3 -r SLAVE
do

	OUTPUT_FILE="/mnt/bps-worker-${MODEL}-BS${BATCH_SIZE}-${SLAVE}"
	WORKER_ID=$id
	command="$SCRIPT_PATH/bps_worker.sh $WORKER_ID $DMLC_NUM_WORKER $DMLC_NUM_SERVER $DMLC_PS_ROOT_URI $DMLC_PS_ROOT_PORT $SCRIPT $MODEL $NUM_ITERS $BATCH_SIZE $EPOCH $OUTPUT_FILE $DATASET"
	$SSH $SLAVE $command
	id=$((id+1))
	sleep 2
done 3< $SLAVE_FILE
