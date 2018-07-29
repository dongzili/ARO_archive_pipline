#!/bin/bash -l
#SBATCH -t 72:00:00
#SBATCH -p archivelong 
#SBATCH -N 1
#SBATCH --mail-type=ALL
/scinet/niagara/bin/ish hindex
