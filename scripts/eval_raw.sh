#!/bin/bash

SCENE=nightstreet
EXPERIMENT=raw/"$SCENE"
DATA_ROOT=/SSD_DISK/datasets/rawnerf/scenes
DATA_DIR="$DATA_ROOT"/"$SCENE"

accelerate launch eval.py --gin_configs=configs/llff_raw.gin \
  --gin_bindings="Config.data_dir = '${DATA_DIR}'" \
  --gin_bindings="Config.exp_name = '${EXPERIMENT}'"