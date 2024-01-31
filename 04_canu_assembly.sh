#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=4GB
#SBATCH --time=01:00:00
#SBATCH --job-name=fastqc
#SBATCH --output=/data/users/ivilela/assembly_annotation_course/output_fastqc_%j.o
#SBATCH --error=/data/users/ivilela/assembly_annotation_course/error_fastqc_%j.e
#SBATCH --partition=pall

# load modules
module load UHTS/Assembler/canu/2.1.1

# Store current path
cwd=$(pwd)

# Move to data directory of user
cd /data/users/${USER}/assembly_annotation_course

# Execute flye assembly
canu \
-p pacbioCanuAssmebly -d pacbioCanu \
-pacbio ./participant_5/pacbio/*.fastq.gz \
genomeSize=135m \
maxThreads=16 maxMemory=64 \
gridEngineResourceOption="--cpus-per-task=THREADS --mem-per-cpu=MEMORY --time=2-00:00:00"

# Move to original directory
cd $cwd

