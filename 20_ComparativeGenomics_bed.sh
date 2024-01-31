#!/usr/bin/env bash

#SBATCH --partition=pall
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=20:00:00
#SBATCH --job-name=bed
#SBATCH --output=/data/users/ivilela/assembly_annotation_course/8_1_bed_%j.o
#SBATCH --error=/data/users/ivilela/assembly_annotation_course/8_1_bed_%j.e

# Load modules
module add UHTS/Analysis/SeqKit/0.13.2

# Define directories
COURSE_DIR=/data/users/ivilela/assembly_annotation_course
INPUT_DIR=/data/courses/assembly-annotation-course/CDS_annotation/Genespace
OUTPUT_DIR=${COURSE_DIR}/comparative_genomics
mkdir ${OUTPUT_DIR}
BED_DIR=${OUTPUT_DIR}/bed
mkdir ${BED_DIR}
PEPTIDE_DIR=${OUTPUT_DIR}/peptide
mkdir ${PEPTIDE_DIR}
GFF=${COURSE_DIR}/annotation/pilonFlye.maker.output/pilonFlye.all.maker.noseq.gff.renamed.gff
FASTA=${COURSE_DIR}/annotation/pilonFlye.maker.output/pilonFlye.all.maker.proteins.fasta.renamed.fasta

OUT_CONTIGS=${OUTPUT_DIR}/longest_contigs.txt
OUT_GENEID=${OUTPUT_DIR}/gene_IDs.txt
OUT_BED=${BED_DIR}/Ler_5.bed
OUT_PEPTIDE=${PEPTIDE_DIR}/Ler_5.fa


# Filter the gff
cat ${GFF} | awk '$3=="contig"' | sort -t $'\t' -k5 -n -r | head -n 10 > ${OUT_CONTIGS}
#Create bed file
cat ${GFF} | awk '$3=="mRNA"' | cut -f 1,4,5,9 | sed 's/ID=//' | sed 's/;.\+//' | grep -w -f <(cut -f1 ${OUT_CONTIGS}) > ${OUT_BED}
#Get the gene IDs
cut -f4 ${OUT_BED} > ${OUT_GENEID}
#Create fasta file
cat ${FASTA} | seqkit grep -r -f ${OUT_GENEID} | seqkit seq -i > ${OUT_PEPTIDE}


# Copy the reference files to the directory for genespace
cp /data/courses/assembly-annotation-course/CDS_annotation/Genespace/TAIR10.bed ${BED_DIR}
cp /data/courses/assembly-annotation-course/CDS_annotation/Genespace/TAIR10.fa ${BED_DIR}

# Copy all other bed and fasta files from the genespace folder
cp /data/courses/assembly-annotation-course/CDS_annotation/Genespace/*.bed ${BED_DIR}
cp /data/courses/assembly-annotation-course/CDS_annotation/Genespace/*.fa ${PEPTIDE_DIR}

# Remove other LER accession
rm ${BED_DIR}/Ler_3*
rm ${PEPTIDE_DIR}/Ler_3*
