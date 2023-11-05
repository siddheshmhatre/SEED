#!/bin/bash -x

#SBATCH --account=cstdl
#SBATCH --nodes=1
#SBATCH --output=logs/out.%j
#SBATCH --error=error_logs/err.%j
#SBATCH --time=02:00:00
#SBATCH --gres=gpu:4
#SBATCH --partition=develbooster
#SBATCH --cpus-per-task=96

export CUDA_VISIBLE_DEVICES=0,1,2,3 # ensures GPU_IDs are available with correct indicies

# Args
START_SHARD="00120"
echo START_SHARD=$START_SHARD

END_SHARD="00159"
echo END_SHARD=$END_SHARD

PATHS="/p/fastdata/mmlaion/laion-400m/LAION-400m-webdataset/data/{$START_SHARD..$END_SHARD}.tar"
echo PATHS=$PATHS

OUTPUT_DIR="/p/fastdata/mmlaion/seed_tokens_laion_400M/"
#OUTPUT_DIR="/p/scratch/ccstdl/mhatre1/seed_tokens_laion_400M/"
echo OUTPUT_PATH=$OUTPUT_DIR

NUM_WORKERS=48
echo NUM_WORKERS=$NUM_WORKERS

NUM_GPUS=4
echo NUM_GPUS=$NUM_GPUS

BATCH_SIZE=2048
echo BATCH_SIZE=$BATCH_SIZE

# Args

source /p/scratch/ccstdl/mhatre1/miniconda3/bin/activate
conda activate myenv

srun --cpu-bind=v --accel-bind=gn python -u seed_tokens.py -p $PATHS \
						-o $OUTPUT_DIR \
						-nw $NUM_WORKERS \
						-ng $NUM_GPUS \
						-bs $BATCH_SIZE

# python -u : produce output immediately, no buffer caching
#srun --cpu-bind=v --accel-bind=gn  python -u dummy_script.py
