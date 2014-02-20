#!/bin/bash
BED_FILE=$1;

#BEDFILE is formatted as this:
# chrom start stop gene strand

#Removed the ^M , in place (-i)
sed -i "s/\r//g" $BED_FILE

#Then to keep Agilent's strand specific details:

awk -v FS="\t" '{print $1"\t"$2"\t"$3"\t"$5"\t"$4}' $BED_FILE > $BED_FILE.tmp

#Here's the commands I used to make the intervals file for BROCA v6 (looks funny because I had to add the strand info into the fourth column). The intervals files MUST contain: Chr Start Stop Strand TargetName
#Also if we're using our .bam files, which have been aligned to the no-chr GATK fasta file, we have to strip the chr from the bed file.

sed -i 's/chr//' $BED_FILE.tmp

cat /home/genetics/Genomes/gatk-bundle/human_g1k_v37.header $BED_FILE.tmp >$BED_FILE.Picard.bed
