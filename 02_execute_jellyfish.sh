#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=10G
#SBATCH --job-name=fastqc
#SBATCH --output=/data/users/ivilela/assembly_annotation_course/output_fastqc_%j.o
#SBATCH --error=/data/users/ivilela/assembly_annotation_course/error_fastqc_%j.e
#SBATCH --partition=pall

# load modules
module load UHTS/Analysis/jellyfish/2.3.0

# Store current path
cwd=$(pwd)

# Move to data directory of user
cd /data/users/${USER}/assembly_annotation_course

# Create directory for output files
mkdir ./jellyfish

# Perform Jellyfish                                                         
jellyfish count \
-m 21 -s 5G -t 4 -C \
-o ./jellyfish/IlluminaReads.jf \
<(zcat ./participant_5/Illumina/*.fastq.gz) \

jellyfish count \
-m 21 -s 5G -t 4 -C \
-o ./jellyfish/PacbioReads.jf \
<(zcat ./participant_5/pacbio/*.fastq.gz) \

jellyfish count \
-m 21 -s 5G -t 4 -C \
-o ./jellyfish/RNAseqReads.jf \
<(zcat ./participant_5/RNAseq/*.fastq.gz) \

# Create histrograms
jellyfish histo -t 4 ./jellyfish/IlluminaReads.jf > IlluminaReads.histo
jellyfish histo -t 4 ./jellyfish/PacbioReads.jf > PacbioReads.histo
jellyfish histo -t 4 ./jellyfish/RNAseqReads.jf > RNAseqReads.histo

# Move to original directory
cd $cwd
