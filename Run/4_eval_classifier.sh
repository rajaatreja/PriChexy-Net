#!/bin/bash -l
#
#SBATCH --ntasks=1
#SBATCH --time=23:59:00
#SBATCH --gres=gpu:1
#SBATCH --job-name=Eval_Classifier
#SBATCH --export=NONE
unset SLURM_EXPORT_ENV

WORKDIR="$TMPDIR/$SLURM_JOBID" 
mkdir "$WORKDIR"
cd "$WORKDIR"

for f in $WORK/CXR8_tar_gz/images/*.tar.gz; do tar xf "$f"; done

export https_proxy=http://proxy:80
module load python
source activate thesis_env

srun --mpi=pmi2 python3 $HOME/PriCheXy-Net/eval_classifier.py --config_path $HOME/PriCheXy-Net/config_files/ --config config_eval_classifier.json --images_path $WORKDIR/images/

conda deactivate
module unload python
cd; rm -r "$WORKDIR"