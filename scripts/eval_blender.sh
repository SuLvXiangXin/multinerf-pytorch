#!/bin/bash

SCENE=ficus
EXPERIMENT=blender/"$SCENE"
DATA_ROOT=/SSD_DISK/datasets/nerf_synthetic
DATA_DIR="$DATA_ROOT"/"$SCENE"

accelerate launch eval.py --gin_configs=configs/blender_256.gin \
  --gin_bindings="Config.data_dir = '${DATA_DIR}'" \
  --gin_bindings="Config.exp_name = '${EXPERIMENT}'"