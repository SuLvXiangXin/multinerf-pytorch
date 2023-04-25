# MultiNeRF

An pytorch reimplementation of [multinerf](https://github.com/google-research/multinerf).


## Install

```
# Clone the repo.
git clone https://https://github.com/SuLvXiangXin/zipnerf-pytorch.git
cd multi-pytorch

# Make a conda environment.
conda create --name multinerf python=3.9
conda activate multinerf

# Install requirements.
pip install -r requirements.txt
```

## Dataset
You can download several datasets below:

MipNeRF360: [mipnerf360_data](http://storage.googleapis.com/gresearch/refraw360/360_v2.zip)

RefNeRF: [refnerf_data](https://storage.googleapis.com/gresearch/refraw360/ref.zip)

RawNeRF: [raw_data](http://storage.googleapis.com/gresearch/refraw360/raw.zip)

Origin NeRF:
[nerf_llff_data](https://drive.google.com/file/d/16VnMcF1KJYxN9QId6TClMsZRahHNMW5g/view?usp=share_link)
[nerf_synthetic](https://drive.google.com/file/d/18JxhpWD-4ZmuFKLzKlAw-w5PpzZxXOcG/view?usp=share_link)
```
mkdir data
cd data

# for example mipnerf360_data
wget http://storage.googleapis.com/gresearch/refraw360/360_v2.zip
unzip 360_v2.zip
```

## Train
```
# Configure your training (DDP? fp16? ...)
# see https://huggingface.co/docs/accelerate/index for details
accelerate config

# Where your data is 
DATA_DIR=data/360_v2/bicycle
EXP_NAME=360_v2/bicycle

# Experiment will be conducted under "exp/${EXP_NAME}" folder
# "--gin_configs=configs/360.gin" can be seen as a default config 
# and you can add specific config useing --gin_bindings="..." 
accelerate launch train.py \
    --gin_configs=configs/360.gin \
    --gin_bindings="Config.data_dir = '${DATA_DIR}'" \
    --gin_bindings="Config.exp_name = '${EXP_NAME}'" \
    --gin_bindings="Config.factor = 4"

# or you can also run without accelerate (without DDP)
CUDA_VISIBLE_DEVICES=0 python train.py \
    --gin_configs=configs/360.gin \
    --gin_bindings="Config.data_dir = '${DATA_DIR}'" \
    --gin_bindings="Config.exp_name = '${EXP_NAME}'" \
      --gin_bindings="Config.factor = 4" 

# alternative you can use an example training script 
bash script/train_360.sh

# metric, render image, etc can be viewed through tensorboard
tensorboard --logdir "exp/${EXP_NAME}"

```

### Render
Rendering results can be found in the directory `exp/${EXP_NAME}/render`
```
accelerate launch render.py \
    --gin_configs=configs/360.gin \
    --gin_bindings="Config.data_dir = '${DATA_DIR}'" \
    --gin_bindings="Config.exp_name = '${EXP_NAME}'" \
    --gin_bindings="Config.render_path = True" \
    --gin_bindings="Config.render_path_frames = 480" \
    --gin_bindings="Config.render_video_fps = 60" \
    --gin_bindings="Config.factor = 4"  

# alternative you can use an example rendering script 
bash script/render_360.sh
```
## Evaluate
Evaluating results can be found in the directory `exp/${EXP_NAME}/test_preds`
```
# using the same exp_name as in training
accelerate launch eval.py \
    --gin_configs=configs/360.gin \
    --gin_bindings="Config.data_dir = '${DATA_DIR}'" \
    --gin_bindings="Config.exp_name = '${EXP_NAME}'" \
    --gin_bindings="Config.factor = 4"


# alternative you can use an example evaluating script 
bash script/eval_360.sh
```
## OutOfMemory
you can decrease the total batch size by 
adding e.g.  `--gin_bindings="Config.batch_size = 4096" `, 
or decrease the test chunk size by adding e.g.  `--gin_bindings="Config.render_chunk_size = 4096" `,
or use more GPU by configure `accelerate config` .


## Preparing custom data
More details can be found at https://github.com/google-research/multinerf
```
DATA_DIR=my_dataset_dir
bash scripts/local_colmap_and_resize.sh ${DATA_DIR}
```

## Citation
```
@misc{multinerf2022,
      title={{MultiNeRF}: {A} {Code} {Release} for {Mip-NeRF} 360, {Ref-NeRF}, and {RawNeRF}},
      author={Ben Mildenhall and Dor Verbin and Pratul P. Srinivasan and Peter Hedman and Ricardo Martin-Brualla and Jonathan T. Barron},
      year={2022},
      url={https://github.com/google-research/multinerf},
}

@Misc{accelerate,
  title =        {Accelerate: Training and inference at scale made simple, efficient and adaptable.},
  author =       {Sylvain Gugger, Lysandre Debut, Thomas Wolf, Philipp Schmid, Zachary Mueller, Sourab Mangrulkar},
  howpublished = {\url{https://github.com/huggingface/accelerate}},
  year =         {2022}
}
```

## Acknowledgements
- Thanks to [multinerf](https://github.com/google-research/multinerf) for amazing multinerf(MipNeRF360,RefNeRF,RawNeRF) implementation
- Thanks to [accelerate](https://github.com/huggingface/accelerate) for distributed training
