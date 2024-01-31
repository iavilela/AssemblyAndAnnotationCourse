#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4000M
#SBATCH --job-name=fastqc
#SBATCH --output=/data/users/ivilela/assembly_annotation_course/output_fastqc_%j.o
#SBATCH --error=/data/users/ivilela/assembly_annotation_course/error_fastqc_%j.e
#SBATCH --partition=pall

# load modules
module load UHTS/Quality_control/fastqc/0.11.9
module load UHTS/Analysis/MultiQC/1.8

# Store current path
cwd=$(pwd)

# Move to data directory of user
cd /data/users/${USER}/assembly_annotation_course

# Create directory for output files
mkdir ./fastqc

# Perform fastqc                                                         
fastqc -o ./fastqc ./participant_5/Illumina/*.fastq.gz
fastqc -o ./fastqc ./participant_5/pacbio/*.fastq.gz
fastqc -o ./fastqc ./participant_5/RNAseq/*.fastq.gz

# Move to original directory
cd $cwd
