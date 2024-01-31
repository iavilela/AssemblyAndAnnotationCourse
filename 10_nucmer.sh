#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=16G
#SBATCH --time=02:00:00
#SBATCH --job-name=nucmer_mummer
#SBATCH --output=/data/users/ivilela/assembly_annotation_course/output_mummer_flye_%j.o
#SBATCH --error=/data/users/ivilela/assembly_annotation_course/error_mummer_flye_%j.e
#SBATCH --partition=pall

#set variable for directory paths
dir=/data/users/ivilela/assembly_annotation_course
ref_file=/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa

#load the mummer module
module add UHTS/Analysis/mummer/4.0.0beta1
export PATH=/software/bin:$PATH

# Store current directory in variable
cwd=$(pwd)

reffile=/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
refdir=/data/courses/assembly-annotation-course/references

# Move to data directory of user
cd /data/users/${USER}/assembly_annotation_course

# Create directory for nucmer output
mkdir ./nucmer

#NUCmer
# flye vs reference
nucmer --prefix /data/users/ivilela/assembly_annotation_course/nucmer/nucmer_flye_vs_ref -b 1000 -c 1000 ${reffile} /data/users/ivilela/assembly_annotation_course/flye/assembly.fasta

# canu vs reference
nucmer --prefix /data/users/ivilela/assembly_annotation_course/nucmer/nucmer_canu_vs_ref -b 1000 -c 1000 ${reffile} /data/users/ivilela/assembly_annotation_course/pacbioCanu/pacbioCanuAssmebly.contigs.fasta

# flye vs canu
nucmer --prefix /data/users/ivilela/assembly_annotation_course/nucmer/nucmer_flye_vs_canu -b 1000 -c 1000 /data/users/ivilela/assembly_annotation_course/pacbioCanu/pacbioCanuAssmebly.contigs.fasta /data/users/ivilela/assembly_annotation_course/flye/assembly.fasta

# Create directory for mummer output
mkdir ./mummer

#execute mummerplot
# Flye vs reference
mummerplot -R ${reffile} -Q /data/users/ivilela/assembly_annotation_course/flye/assembly.fasta --filter -t png --large --fat --layout --prefix ./mummer/mummerplot_flye_vs_ref ./nucmer/nucmer_flye_vs_ref.delta

# Canu vs reference
mummerplot -R ${reffile} -Q /data/users/ivilela/assembly_annotation_course/pacbioCanu/pacbioCanuAssmebly.contigs.fasta --filter -t png --large --fat --layout --prefix ./mummer/mummerplot_canu_vs_ref ./nucmer/nucmer_canu_vs_ref.delta

# Flye vs Canu
mummerplot -R /data/users/ivilela/assembly_annotation_course/pacbioCanu/pacbioCanuAssmebly.contigs.fasta -Q /data/users/ivilela/assembly_annotation_course/flye/assembly.fasta --filter -t png --large --fat --layout --prefix ./mummer/mummerplot_flye_vs_canu ./nucmer/nucmer_flye_vs_canu.delta

# Reset current directory
cd $cwd
