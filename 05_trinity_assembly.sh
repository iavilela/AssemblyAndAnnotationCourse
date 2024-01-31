#!/usr/bin/env bash

#SBATCH --time=1-00:00:00
#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --job-name=trinity
#SBATCH --output=/data/users/ivilela/assembly_annotation_course/output_fastqc_%j.o
#SBATCH --error=/data/users/ivilela/assembly_annotation_course/error_fastqc_%j.e
#SBATCH --partition=pall

# load modules
module load UHTS/Assembler/trinityrnaseq/2.5.1

# Store current path
cwd=$(pwd)

# Move to data directory of user
cd /data/users/${USER}/assembly_annotation_course

# Create directory for flye results
mkdir ./trinity

Trinity --seqType fq --left ./participant_5/RNAseq/*_1.fastq.gz \
--right ./participant_5/RNAseq/*_2.fastq.gz --SS_lib_type RF \
--CPU 12 --max_memory 48G --output ./trinity

# Move to original directory
cd $cwd
