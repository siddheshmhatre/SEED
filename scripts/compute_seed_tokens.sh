#!/bin/bash -x

#SBATCH --account=cstdl
#SBATCH --nodes=1
#SBATCH --output=logs/out.%j
#SBATCH --error=error_logs/err.%j
#SBATCH --time=01:15:00
#SBATCH --gres=gpu:4
#SBATCH --partition=booster
#SBATCH --cpus-per-task=96

export CUDA_VISIBLE_DEVICES=0,1,2,3 # ensures GPU_IDs are available with correct indicies

# Args
START_SHARD="00000"
echo START_SHARD=$START_SHARD

END_SHARD="00013"
echo END_SHARD=$END_SHARD

PATHS="/p/scratch/ccstdl/nakamura2/en_wiki_img2dataset/{$START_SHARD..$END_SHARD}.tar"
echo PATHS=$PATHS

OUTPUT_DIR="/p/fastdata/mmlaion/seed_tokens_en_wiki_img2dataset_siddhesh/"
echo OUTPUT_PATH=$OUTPUT_DIR

NUM_WORKERS=8
echo NUM_WORKERS=$NUM_WORKERS

NUM_GPUS=4
echo NUM_GPUS=$NUM_GPUS

BATCH_SIZE=2048
echo BATCH_SIZE=$BATCH_SIZE

DATASET="wiki"
echo DATASET=$DATASET

# Args
module load Stages/2024 GCC/11.3.0  OpenMPI/4.1.4
ml git

source /p/project/ccstdl/gupta6/miniconda3/bin/activate
conda activate seed

#srun --cpu-bind=v --accel-bind=gn 
python -u seed_tokens.py -p $PATHS \
						-o $OUTPUT_DIR \
						-nw $NUM_WORKERS \
						-ng $NUM_GPUS \
						-bs $BATCH_SIZE \
						-ds $DATASET

# python -u : produce output immediately, no buffer caching
#srun --cpu-bind=v --accel-bind=gn  python -u dummy_script.py
