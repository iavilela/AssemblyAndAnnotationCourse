#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=16G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=busco
#SBATCH --output=/data/users/ivilela/assembly_annotation_course/output_busco_unpol_%j.o
#SBATCH --error=/data/users/ivilela/assembly_annotation_course/eerror_busco_%j.e
#SBATCH --partition=pall

#set directory
dir=/data/users/ivilela/assembly_annotation_course

#Use BUSCO with container
#Trinity
singularity exec \
--bind $dir \
/data/courses/assembly-annotation-course/containers2/busco_v5.1.2_cv1.sif \
busco -i ${dir}/trinity/Trinity.fasta -l brassicales_odb10 -o trinityBusco --out_path ${dir}/busco \
-m transcriptome --cpu 4 -f

#Flye unpolished 
singularity exec \
--bind $dir \
/data/courses/assembly-annotation-course/containers2/busco_v5.1.2_cv1.sif \
busco -i ${dir}/flye/assembly.fasta -l brassicales_odb10 -o flyeUnpolishedBusco \
--out_path ${dir}/busco -m genome --cpu 4 -f

#Canu unpolished 
singularity exec \
--bind $dir \
/data/courses/assembly-annotation-course/containers2/busco_v5.1.2_cv1.sif \
busco -i ${dir}/pacbioCanu/pacbioCanuAssmebly.contigs.fasta -l brassicales_odb10 -o canuUnpolishedBusco \
--out_path ${dir}/busco -m genome --cpu 4 -f

#Flye polished 
singularity exec \
--bind $dir \
/data/courses/assembly-annotation-course/containers2/busco_v5.1.2_cv1.sif \
busco -i ${dir}/bowtie/pilonFlye.fasta -l brassicales_odb10 -o flyePolishedBusco \
--out_path ${dir}/busco -m genome --cpu 4 -f

#Canu polished 
singularity exec \
--bind $dir \
/data/courses/assembly-annotation-course/containers2/busco_v5.1.2_cv1.sif \
busco -i ${dir}/bowtie/pilonCanu.fasta -l brassicales_odb10 -o canuPolishedBusco \
--out_path ${dir}/busco -m genome --cpu 4 -f

