#!/bin/bash
#SBATCH --job-name=FORGE
#SBATCH --time=00:03:00
#SBATCH --output /home/bsc03/bsc03353/FORGE-WRITE-experiments/FORGE-%j-slurm.out
#SBATCH --error /home/bsc03/bsc03353/FORGE-WRITE-experiments/FORGE-%j-slurm.err
#SBATCH --nodes=10
#SBATCH --qos=bsc_cs

#################################################################################################################

module load gcc/8.1.0
module unload impi
module load openmpi/4.0.2_UCX
module load gcc/8.1.0
module load gsl/2.4

#################################################################################################################

export OMPI_MCA_btl='^vader,openib,self,sm'
export PSM2_DEVICES='self,hfi,shm'

EXPERIMENT_ID="3017"
EXPERIMENT_NUMBER_PROCESSES=386
EXPERIMENT_NUMBER_FORWARDERS=2
EXPERIMENT_NUMBER_CLIENTS=8
EXPERIMENT_CONFIGURATION=/home/bsc03/bsc03353/forge/experiments/forge.mn4.006-3017.json

EXPERIMENT_LOG=${HOME}/FORGE-WRITE-experiments/FORGE-${EXPERIMENT_ID}-${SLURM_JOBID}

BASE=/home/bsc03/bsc03353/forge
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
     --display-map \
     --np ${EXPERIMENT_NUMBER_PROCESSES:?} \
     ${FORGE} ${EXPERIMENT_CONFIGURATION:?} ${EXPERIMENT_LOG}

rm /gpfs/scratch/bsc03/bsc03353/forge.mn4.006-3017*
