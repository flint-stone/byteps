#!/bin/bash
set -x

export DMLC_NUM_WORKER=$1
export DMLC_ROLE=server
export DMLC_NUM_SERVER=$2
export DMLC_PS_ROOT_URI=$3
export DMLC_PS_ROOT_PORT=$4
export OUTPUT=$5

bpslaunch > $OUTPUT 2>&1 &
