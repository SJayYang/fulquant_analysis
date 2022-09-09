#!/bin/bash
# NOTE : Quote it else use array to avoid problems #
FILES="*.bam"
for f in $FILES
do
  echo "Processing $f file..."
  samtools view -c $f
done

FILES="*.fastq.gz"
for f in $FILES
do
  echo "Processing $f file..."
  zcat $f | wc -l
done