#!/bin/bash

#SBATCH --job-name=sumoe_01
#SBATCH --partition=GPU-shared
#SBATCH -N 1
#SBATCH --ntasks=5
#SBATCH --gpus=v100-32:1
#SBATCH --time=04:00:00
# #SBATCH --array=0
#SBATCH --array=1-5
#SBATCH --account=med230001p

# Set some environment variables
ROOT="/ocean/projects/med230001p/clane2/code/columnformers"
cd $ROOT

# Set up python environment
source .venv/bin/activate

# Setup wandb
source .env
wandb login

JOB="sumoe_01"
NAMES=(
    "01_baseline"
    "02_ratio-2"
    "03_ratio-1"
    "04_ratio-2_rank-2"
    "05_ratio-1_rank-2"
    "06_ratio-1_rank-4"
)

NAME="${NAMES[SLURM_ARRAY_TASK_ID]}"
CONFIG="jobs/${JOB}/configs/${NAME}.yaml"
FULL_NAME="${JOB}/${NAME}"

python columnformers/train.py $CONFIG --name $FULL_NAME
