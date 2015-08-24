#!/bin/bash

## RENAME FOR YOUR JOB
#PBS -N dsale-compile-OpenFOAM

## REQUEST NUMBER OF CPUS AND NODES
#PBS -l nodes=1:ppn=16,feature=intel

## WALLTIME DEFAULTS TO ONE HOUR - ALWAYS SPECIFY FOR LONGER JOBS
#PBS -l walltime=5:00:00

## Put the output from jobs into the below directory
#PBS -o /gscratch/stf/dsale/job_output/logs

## Put both the stderr and stdout into a single file
#PBS -j oe

## Send email when the job is aborted, begins, and terminates
#PBS -m abe -M sale.danny@gmail.com

## Specify the working directory for this job
#PBS -d /gscratch/stf/dsale/OpenFOAM/OpenFOAM-2.4.x

## Load the appropriate environment modules (modern versions of OpenFOAM require a newer version of GCC compilers that are not yet available on Hyak, so must resort to using the intel compilers)
module load icc_15.0.3-impi_5.0.3
module load cmake_3.2.3

## Debugging information
echo "**********************************************"
# Total Number of processors (cores) to be used by the job
HYAK_NPE=$(wc -l < $PBS_NODEFILE)
# Number of nodes used
HYAK_NNODES=$(uniq $PBS_NODEFILE | wc -l )
echo "**** Job Debugging Information ****"
echo "This job will run on $HYAK_NPE total CPUs on $HYAK_NNODES different nodes"
echo ""
echo "Node:CPUs Used"
uniq -c $PBS_NODEFILE | awk '{print $2 ":" $1}'
echo "SHARED LIBRARY CHECK"
echo "ENVIRONMENT VARIABLES"
set
echo "I ran my job on:"
cat $PBS_NODEFILE
echo "**********************************************"
## End Debugging information


### Specify the app to run here                           ###
# EDIT FOR YOUR JOB
#

cd OpenFOAM-2.4.x
export WM_NCOMPPROCS=16

## for Intel MPI
export export MPI_ROOT=$I_MPI_ROOT

# this loads the OpenFOAM environmental variables
source /gscratch/stf/dsale/OpenFOAM/OpenFOAM-2.4.x/etc/bashrc

# this starts compiling everything, and keeps a log file
./Allwmake 2>&1 | tee log.Hyak-compile-OpenFOAM

echo '====  FINISHED COMPILING OPENFOAM  ====='

