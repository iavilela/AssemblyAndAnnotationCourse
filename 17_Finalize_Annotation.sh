#!/usr/bin/env bash

#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --time=02:00:00
#SBATCH --job-name=FinalizeAnnotation
#SBATCH --output=/data/users/ivilela/assembly_annotation_course/output_FinalizeAnnotation_%j.o
#SBATCH --error=/data/users/ivilela/assembly_annotation_course/error_FinalizeAnnotation_%j.e
#SBATCH --partition=pall

# Load modules
module add Blast/ncbi-blast/2.10.1+
module load SequenceAnalysis/GenePrediction/maker/2.31.9

# Export Statements
export TMPDIR=$SCRATCH

# Decalre variables
base=pilonFlye

# Move to directory with maker output
cd /data/users/ivilela/assembly_annotation_course/annotation/${base}.maker.output

# Generate gff and fasta files
gff3_merge -d ${base}_master_datastore_index.log -o ${base}.all.maker.gff
gff3_merge -d ${base}_master_datastore_index.log -n -o ${base}.all.maker.noseq.gff
fasta_merge -d ${base}_master_datastore_index.log -o ${base}

# Rename MAKER genes
protein=${base}.all.maker.proteins.fasta
transcript=${base}.all.maker.transcripts.fasta
gff=${base}.all.maker.noseq.gff
prefix=${base}_

cp $gff ${gff}.renamed.gff
cp $protein ${protein}.renamed.fasta
cp $transcript ${transcript}.renamed.fasta

maker_map_ids --prefix $prefix --justify 7 ${gff}.renamed.gff > ${base}.id.map
map_gff_ids ${base}.id.map ${gff}.renamed.gff
map_fasta_ids ${base}.id.map ${protein}.renamed.fasta
map_fasta_ids ${base}.id.map ${transcript}.renamed.fasta
