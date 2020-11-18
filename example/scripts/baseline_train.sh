#!/bin/bash
set -x

SSH="ssh -o StrictHostKeyChecking=no"
SCRIPT_PATH="/mydata/lexu/byteps/example/scripts"
DMLC_NUM_WORKER=4
#DMLC_ROLE=scheduler
DMLC_NUM_SERVER=1
DMLC_PS_ROOT_URI="10.10.1.1"
DMLC_PS_ROOT_PORT="12345"

SLAVE_FILE=slaves
SCRIPT="${SCRIPT_PATH}/benchmark_baseline.py"
MODEL="resnet50"
NUM_ITERS=200
EPOCH=2
BATCH_SIZE=128 #560
DATASET="/mnt/tiny-imagenet-200"

NUM_GPU_PER_NODE=1

OUTPUT_FILE="/mnt/baseline-scheduler-${MODEL}.log"
#./bps_scheduler.sh $DMLC_NUM_WORKER $DMLC_NUM_SERVER $DMLC_PS_ROOT_URI $DMLC_PS_ROOT_PORT $OUTPUT_FILE

OUTPUT_FILE="/mnt/baseline-server-${MODEL}.log"
#./bps_server.sh $DMLC_NUM_WORKER $DMLC_NUM_SERVER $DMLC_PS_ROOT_URI $DMLC_PS_ROOT_PORT $OUTPUT_FILE

id=0
nc=0
ckip=0
while read -u 3 -r SLAVE
do

	OUTPUT_FILE="/mnt/baseline-worker-BS${BATCH_SIZE}-${MODEL}-${SLAVE}"
	#for (( id=0; id<$NUM_GPU_PER_NODE; id++ ))
	#do
	        id=0
		echo $id
		WORKER_ID=$id
		RANK=$(( nc * NUM_GPU_PER_NODE  + id))
		command="$SCRIPT_PATH/baseline_worker.sh $WORKER_ID $DMLC_NUM_WORKER $DMLC_NUM_SERVER $DMLC_PS_ROOT_URI $DMLC_PS_ROOT_PORT $RANK $SCRIPT $MODEL $NUM_ITERS $BATCH_SIZE $EPOCH $OUTPUT_FILE $DATASET $ckip"
		$SSH $SLAVE $command
		#id=$((id+1))
	#done
	nc=$((nc+1))
	ckip=$((ckip+1))
	sleep 2
done 3< $SLAVE_FILE
