#!/bin/bash
#SBATCH --job-name=FORGE
#SBATCH --time=00:05:00
#SBATCH --output /scratch/cenapadrjsd/jean.bez/forge-sdumont/FORGE-WRITE-experiments/FORGE-%j-slurm.out
#SBATCH --error /scratch/cenapadrjsd/jean.bez/forge-sdumont/FORGE-WRITE-experiments/FORGE-%j-slurm.err
#SBATCH --nodes=40
#SBATCH --partition=sequana_cpu

#################################################################################################################

module load sequana/current
module load openmpi/gnu/4.0.4_ucx_1.6_sequana
module load gcc/8.3_sequana

#################################################################################################################

EXPERIMENT_ID="1337"
EXPERIMENT_NUMBER_PROCESSES=392
EXPERIMENT_NUMBER_FORWARDERS=8
EXPERIMENT_NUMBER_CLIENTS=32
EXPERIMENT_CONFIGURATION=/scratch/cenapadrjsd/jean.bez/forge-sdumont/forge/experiments/forge.sdumount.001-1337.json

EXPERIMENT_LOG=${HOME}/forge-sdumont/FORGE-WRITE-experiments/FORGE-${EXPERIMENT_ID}-${SLURM_JOBID}

BASE=/scratch/cenapadrjsd/jean.bez/forge-sdumont/forge
FORGE=${BASE}/build/forge
GENERATOR=${BASE}/generate.py

mkdir ${EXPERIMENT_LOG}

#################################################################################################################

srun -l /bin/hostname | sort -n | awk '{print $2}' > ${EXPERIMENT_LOG}/nodes

head -n ${EXPERIMENT_NUMBER_FORWARDERS:?} ${EXPERIMENT_LOG}/nodes > ${EXPERIMENT_LOG}/nodes-forwarding
tail -n ${EXPERIMENT_NUMBER_CLIENTS:?} ${EXPERIMENT_LOG}/nodes > ${EXPERIMENT_LOG}/nodes-clients

python ${GENERATOR} \
     ${EXPERIMENT_NUMBER_PROCESSES:?} \
     ${EXPERIMENT_NUMBER_FORWARDERS:?} \
     ${EXPERIMENT_NUMBER_CLIENTS:?} \
     ${EXPERIMENT_LOG}/nodes-forwarding \
     ${EXPERIMENT_LOG}/nodes-clients \
     ${EXPERIMENT_LOG}/nodes

#################################################################################################################

mpirun \
     --hostfile ${EXPERIMENT_LOG}/nodes \
     --map-by node \
     --rank-by node \
     --display-map \
     --mca opal_warn_on_missing_libcuda 0  \
     --np ${EXPERIMENT_NUMBER_PROCESSES:?} \
     ${FORGE} ${EXPERIMENT_CONFIGURATION:?} ${EXPERIMENT_LOG}

rm /scratch/cenapadrjsd/jean.bez/forge-sdumont/storage/forge.sdumount.001-1337*

