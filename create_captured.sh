#!/bin/bash

set -e
refseq=$1
bedfile=$2
captured=$3

#-Strip 'chr'from both refseq_file and bedfile
sed -i 's/chr//g' $refseq
sed -i 's/chr//g' $bedfile

#-Annotate bed with bedtools
bedtools intersect -loj -a $bedfile -b $refseq > $bedfile.tmp

#-This creates a file with many more columns than we want or need, let's remove those:
awk -v FS="\t" '{print $1"\t"$2"\t"$3"\t"$9"\t"$5"\t"}' $bedfile.tmp | sort | uniq > $bedfile.new

#-Create captured genes file with bedtools
awk -v FS="\t" '{ if ($4~/[A-Z]+/) print $4}' $bedfile.new | sort | uniq > $captured

#-Add the header necessary for the pipeline
sed -i '1i Gene\tRefSeq' $captured
rm *tmp
