#!/bin/bash

#Download the appropriate Genes file from UCSC Table Browser:

set -e
refseq=$1

#-RefSeq Table
#-Select fields
#-Get output
#-Reorder columns (chr,strand,start,stop,gene) -> (chr,start,stop,gene,strand)

awk -v FS="\t" '{print $1"\t"$3"\t"$4"\t"$5"\t"$2"\t"}' $refseq > ${refseq}.tmp

#-Remove header of refseq file

sed "1d" $refseq.tmp > $refseq
