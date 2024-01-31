#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=16G
#SBATCH --time=01:00:00
#SBATCH --job-name=quast
#SBATCH --output=/data/users/ivilela/assembly_annotation_course/output_flye_quast_unpol_noref_%j.o
#SBATCH --error=/data/users/ivilela/assembly_annotation_course/error_flye_quast_unpol_noref_%j.e
#SBATCH --partition=pall

# Define paths
dir=/data/users/ivilela/assembly_annotation_course
datadir=/data/courses/assembly-annotation-course

# Create output directory
mkdir ./quast

# Use QUAST
# Flye, unpolished, without reference:
singularity exec \
--bind $dir \
/data/courses/assembly-annotation-course/containers/quast_5.1.0rc1.sif \
quast.py ${dir}/flye/assembly.fasta --eukaryote --large \
--est-ref-size 135000000 --threads 4 --labels quast_flye_unpol_noref \
-o ${dir}/quast/flye_unpol_noref

# Canu, unpolished, without reference
singularity exec \
--bind $dir \
/data/courses/assembly-annotation-course/containers/quast_5.1.0rc1.sif \
quast.py ${dir}/pacbioCanu/pacbioCanuAssmebly.contigs.fasta --eukaryote --large \
--est-ref-size 135000000 --threads 4 --labels quast_canu_unpol_noref \
-o ${dir}/quast/canu_unpol_noref

# Flye polished, without reference
singularity exec \
--bind $dir \
/data/courses/assembly-annotation-course/containers/quast_5.1.0rc1.sif \
quast.py ${dir}/bowtie/pilonFlye.fasta --eukaryote --large \
--est-ref-size 135000000 --threads 4 --labels quast_flye_pol_noref \
-o ${dir}/quast/flye_pol_noref

# Canu polished, without reference
singularity exec \
--bind $dir \
/data/courses/assembly-annotation-course/containers/quast_5.1.0rc1.sif \
quast.py ${dir}/bowtie/pilonCanu.fasta --eukaryote --large \
--est-ref-size 135000000 --threads 4 --labels quast_canu_pol_noref \
-o ${dir}/quast/canu_pol_noref

# Flye, unpolished, with reference
singularity exec \
--bind $dir \
--bind $datadir \
/data/courses/assembly-annotation-course/containers/quast_5.1.0rc1.sif \
quast.py ${dir}/flye/assembly.fasta --eukaryote --large \
--est-ref-size 135000000 --threads 4 --labels quast_flye_unpol_ref \
-r ${datadir}/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz \
-g /data/courses/assembly-annotation-course/references/TAIR10_GFF3_genes.gff \
-o ${dir}/quast/flye_unpol_ref

# Canu, unpolished, with reference
singularity exec \
--bind $dir \
--bind $datadir \
/data/courses/assembly-annotation-course/containers/quast_5.1.0rc1.sif \
quast.py ${dir}/pacbioCanu/pacbioCanuAssmebly.contigs.fasta \
--est-ref-size 135000000 --threads 4 --labels quast_flye_unpol_ref \
-r ${datadir}/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz \
-g /data/courses/assembly-annotation-course/references/TAIR10_GFF3_genes.gff \
-o ${dir}/quast/canu_unpol_ref

# Flye, polished, with reference
singularity exec \
--bind $dir \
--bind $datadir \
/data/courses/assembly-annotation-course/containers/quast_5.1.0rc1.sif \
quast.py ${dir}/bowtie/pilonFlye.fasta \
--est-ref-size 135000000 --threads 4 --labels quast_flye_pol_ref \
-r ${datadir}/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz \
-g /data/courses/assembly-annotation-course/references/TAIR10_GFF3_genes.gff \
-o ${dir}/quast/flye_pol_ref

# Canu, polished, with reference
singularity exec \
--bind $dir \
--bind $datadir \
/data/courses/assembly-annotation-course/containers/quast_5.1.0rc1.sif \
quast.py ${dir}/bowtie/pilonCanu.fasta \
--est-ref-size 135000000 --threads 4 --labels quast_canu_pol_ref \
-r ${datadir}/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz \
-g /data/courses/assembly-annotation-course/references/TAIR10_GFF3_genes.gff \
-o ${dir}/quast/canu_pol_ref
