#!/usr/bin/env zsh

# The reference is GCA_013166975.1_ASM1316697v1_genomic.fna
# Three directories data/ out/ ref/

# Assumtions
# botwie2 (I've generated a mamba env)
# ref and out dir

# INPUTS
FORWARD="$1" # either fq.gz or fq
BACKWARD="$2" # either fq.gz or fq
REFERENCE="$3" # fasta

# OUTPUT name with out extension
# path/file without extension
OUT="$4"

# Globals
REF_ALIAS="ref/ecoli"
CORES="4"

VARSCAN_BIN='/home/ebecerra/4-env/bin-source/varscan-2.4.5/VarScan.v2.4.5.jar'

# bowtie2-build "${REFERENCE}" "${REF_ALIAS}"

# align using bwtie2
bowtie2 -p $CORES -x"$REF_ALIAS" -1 "$FORWARD" -2 "$BACKWARD" -S "${OUT}.sam"

# convert sam to bam
samtools view -S -b "${OUT}.sam" >| "${OUT}.bam"

# sort bam
samtools sort "${OUT}.bam" -o "${OUT}.s.bam"

# index bam
samtools index "${OUT}.s.bam" -o "${OUT}.s.bai"

# create mpileup file
samtools mpileup -f "$REFERENCE" "${OUT}.s.bam" -o "${OUT}.mpileup"

# create tsv file with variants
java -jar "$VARSCAN_BIN" pileup2snp "${OUT}.mpileup" --min-var-freq 0.1  --p-value 0.01 >| "${OUT}.tsv"
