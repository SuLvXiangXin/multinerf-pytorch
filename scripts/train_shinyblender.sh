#!/bin/bash

SCENE=toaster
EXPERIMENT=shinyblender/"$SCENE"
DATA_ROOT=/SSD_DISK/datasets/refnerf
DATA_DIR="$DATA_ROOT"/"$SCENE"

rm exp/"$EXPERIMENT"/*
accelerate launch train.py --gin_configs=configs/blender_refnerf.gin \
  --gin_bindings="Config.data_dir = '${DATA_DIR}'" \
  --gin_bindings="Config.exp_name = '${EXPERIMENT}'"