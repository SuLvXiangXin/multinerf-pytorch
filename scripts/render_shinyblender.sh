#!/bin/bash

SCENE=toaster
EXPERIMENT=360_v2/"$SCENE"
DATA_ROOT=/SSD_DISK/datasets/refnerf
DATA_DIR="$DATA_ROOT"/"$SCENE"

accelerate launch render.py --gin_configs=configs/blender_refnerf.gin \
  --gin_bindings="Config.data_dir = '${DATA_DIR}'" \
  --gin_bindings="Config.exp_name = '${EXPERIMENT}'" \
  --gin_bindings="Config.render_path = True" \
  --gin_bindings="Config.render_path_frames = 120" \
  --gin_bindings="Config.render_dir = '${CHECKPOINT_DIR}/render/'" \
  --gin_bindings="Config.render_video_fps = 60"