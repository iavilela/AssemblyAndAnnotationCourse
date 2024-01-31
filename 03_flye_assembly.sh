#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --job-name=flyeAssembly
#SBATCH --output=/data/users/ivilela/assembly_annotation_course/output_fastqc_%j.o
#SBATCH --error=/data/users/ivilela/assembly_annotation_course/error_fastqc_%j.e
#SBATCH --partition=pall

# load modules
module load UHTS/Assembler/flye/2.8.3

# Store current path
cwd=$(pwd)

# Move to data directory of user
cd /data/users/${USER}/assembly_annotation_course

# Create directory for flye results
mkdir ./flye

# Execute flye assembly
flye --pacbio-raw ./participant_5/pacbio/*.fastq.gz --out-dir ./flye --threads 4

# Move to original directory
cd $cwd

