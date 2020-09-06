#!/bin/bash
#SBATCH --job-name=FORGE
#SBATCH --time=00:03:00
#SBATCH --output /home/bsc03/bsc03353/FORGE-experiments-madbench/FORGE-%j-slurm.out
#SBATCH --error /home/bsc03/bsc03353/FORGE-experiments-madbench/FORGE-%j-slurm.err
#SBATCH --nodes=16
#SBATCH --qos=bsc_cs

#################################################################################################################

module load gcc/8.1.0
module unload impi
module load openmpi/4.0.2
module load gcc/8.1.0
module load gsl/2.4

#################################################################################################################

export OMPI_MCA_btl='^vader,openib,self,sm'

EXPERIMENT_ID="560"
EXPERIMENT_NUMBER_PROCESSES=768
EXPERIMENT_NUMBER_FORWARDERS=0
EXPERIMENT_NUMBER_CLIENTS=16
EXPERIMENT_CONFIGURATION=/home/bsc03/bsc03353/forge/experiments/forge.mn4.004-560.json

EXPERIMENT_LOG=${HOME}/FORGE-experiments-madbench/FORGE-${EXPERIMENT_ID}-${SLURM_JOBID}

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

srun -r ${EXPERIMENT_NUMBER_FORWARDERS:?} \
     -N ${EXPERIMENT_NUMBER_CLIENTS:?} \
     -n ${EXPERIMENT_NUMBER_PROCESSES:?} \
     -m cyclic \
     --export=ALL  \
     -v \
     /bin/bash -c "${FORGE} ${EXPERIMENT_CONFIGURATION:?} ${EXPERIMENT_LOG}"

#################################################################################################################

#rm /gpfs/scratch/bsc03/bsc03353/forge.mn4.004-560*
