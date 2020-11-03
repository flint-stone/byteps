#!/bin/bash
set -x

export DMLC_WORKER_ID=$1
export DMLC_NUM_WORKER=$2

export DMLC_ROLE=worker

export DMLC_NUM_SERVER=$3
export DMLC_PS_ROOT_URI=$4
export DMLC_PS_ROOT_PORT=$5

SCRIPT=$6
MODEL=$7
NUM_ITERS=$8
BATCH_SIZE=$9
EPOCH=${10}
OUTPUT_FILE=${11}
DATASET=${12}

export PATH=${PATH}:/usr/local/cuda/bin;
#OUTPUT_FILE=${OUTPUT_FILE}-benchmark
#nvprof --profile-child-processes  -o $OUTPUT_FILE-%p.nvvp 
#bpslaunch python3 $SCRIPT --model $MODEL --num-iters $NUM_ITERS --batch-size $BATCH_SIZE > ${OUTPUT_FILE}.log 2>&1 &
#bpslaunch python3 /mydata/lexu/byteps/example/scripts/train_imagenet_resnet_byteps_ddp.py -a $MODEL --dist-url "tcp://${DMLC_PS_ROOT_URI}:${DMLC_PS_ROOT_PORT}" --dist-backend 'nccl' --multiprocessing-distributed --world-size $DMLC_NUM_WORKER --batch-size $BATCH_SIZE --rank $DMLC_WORKER_ID $DATASET  > ${OUTPUT_FILE}.log 2>&1 &

#OUTPUT_FILE=${OUTPUT_FILE}-imagenet
#nvprof --profile-child-processes  -o $OUTPUT_FILE-%p.nvvp bpslaunch python3 /mydata/lexu/byteps/example/scripts/train_imagenet_resnet_byteps_ddp.py -a $MODEL --dist-url "tcp://${DMLC_PS_ROOT_URI}:${DMLC_PS_ROOT_PORT}" --dist-backend 'nccl' --multiprocessing-distributed --world-size $DMLC_NUM_WORKER --epochs $EPOCH  --batch-size $BATCH_SIZE --rank $DMLC_WORKER_ID $DATASET  > ${OUTPUT_FILE}.log 2>&1 &

#bpslaunch CUDA_LAUNCH_BLOCKING=1 python3 $SCRIPT --model $MODEL --num-iters $NUM_ITERS --batch-size $BATCH_SIZE > ${OUTPUT_FILE}.log 2>&1 &

OUTPUT_FILE=${OUTPUT_FILE}-transformer
export NCCL_DEBUG=INFO; export NCCL_SOCKET_IFNAME=$IFNAME; export PATH=$PATH:/usr/local/cuda/bin; bpslaunch python3 -m torch.distributed.launch --nproc_per_node=1 --nnodes=${DMLC_NUM_WORKER} --node_rank=${DMLC_WORKER_ID} --master_addr=${DMLC_PS_ROOT_URI} --master_port=${DMLC_PS_ROOT_PORT} ${SCRIPT}  --output_dir ${DATASET}/models/ --model_type $MODEL --mlm --config_name ${DATASET} --tokenizer_name ${DATASET} --do_train  --line_by_line --train_data_file ${DATASET}/eo.txt --learning_rate 1e-4 --num_train_epochs $EPOCH --save_total_limit 2 --save_steps 2000 --per_gpu_train_batch_size $BATCH_SIZE  --max_steps ${NUM_ITERS} --seed 42 --overwrite_output_dir > ${OUTPUT_FILE}.log 2>&1 &


