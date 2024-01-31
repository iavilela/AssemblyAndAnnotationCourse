#!/usr/bin/env bash

#SBATCH --time=3-00:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=12G
#SBATCH --job-name=polishAssemblies
#SBATCH --output=/data/users/ivilela/assembly_annotation_course/output_bowtie_%j.o
#SBATCH --error=/data/users/ivilela/assembly_annotation_course/error_bowtie__%j.e
#SBATCH --partition=pall

# load modules
module add UHTS/Aligner/bowtie2/2.3.4.1
module load UHTS/Analysis/samtools/1.10
module load Development/java/11.0.6

# Store current directory in variable
cwd=$(pwd)

# Move to data directory of user
cd /data/users/${USER}/assembly_annotation_course

# Create directory for polished files
mkdir ./bowtie
cd ./bowtie

# Build bowtie index files
bowtie2-build --threads 4 -f ../flye/assembly.fasta ./flye_index
bowtie2-build --threads 4 -f ../pacbioCanu/pacbioCanuAssmebly.contigs.fasta ./canu_index

# Apply bowtie
bowtie2 -p 4 -x ./flye_index -1 ../participant_5/Illumina/ERR3624574_1.fastq.gz -2 ../participant_5/Illumina/ERR3624574_2.fastq.gz \
-q --sensitive-local -S flye_polish.sam
bowtie2 -p 4 -x ./canu_index -1 ../participant_5/Illumina/ERR3624574_1.fastq.gz -2 ../participant_5/Illumina/ERR3624574_2.fastq.gz \
-q --sensitive-local -S canu_polish.sam

#convert to the samfile to bamfile
samtools sort -T $SCRATCH -@ $SLURM_CPUS_PER_TASK flye_polish.sam -o flye_sorted.sam
samtools sort -T $SCRATCH -@ $SLURM_CPUS_PER_TASK canu_polish.sam -o canu_sorted.sam

samtools view -bS flye_sorted.sam -o flye_polish.bam
samtools view -bS canu_sorted.sam -o canu_polish.bam

samtools index flye_polish.bam
samtools index canu_polish.bam

#run pilon
cd ../

java -Xmx45g -jar /mnt/software/UHTS/Analysis/pilon/1.22/bin/pilon-1.22.jar \
--genome ./flye/assembly.fasta \
--bam ./bowtie/flye_polish.bam --outdir ./bowtie --output pilonFlye

java -Xmx45g -jar /mnt/software/UHTS/Analysis/pilon/1.22/bin/pilon-1.22.jar \
--genome ./pacbioCanu/pacbioCanuAssmebly.contigs.fasta \
--bam ./bowtie/canu_polish.bam --outdir ./bowtie --output pilonCanu

# Move to original directory
cd $cwd
