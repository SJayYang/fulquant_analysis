#!/usr/bin/env bash
# Run this before
# Rscript performance_check.R
genome_folder=/home/yangs/FulQuant/hg38.98_ERCC_SIRV
genome_transcript_list=$genome_folder/transcript_name_list.txt
comparison=$1
output_folder=/home/yangs/ONT_comparisons/${comparison}/combined/tx_annot
bed_file=$output_folder/tx_human_final.bed.gz
detectedGenesList=$output_folder/detectedTranscript.txt
zcat $bed_file | cut -f4 | sort -u > $detectedGenesList
sort -u $genome_transcript_list > $genome_folder/sorted_transcriptID.txt
join $detectedGenesList $genome_folder/sorted_transcriptID.txt > $output_folder/combined.txt
numTranscriptsSharedWRef=$(wc -l < ${output_folder}/combined.txt | xargs)
echo "TP: Number of isoforms detected from reference: ${numTranscriptsSharedWRef}"
numTranscriptInRef=$(wc -l < $genome_transcript_list | xargs)
echo "TP + FN: Number of isoforms in reference: ${numTranscriptInRef} "
numTranscriptDetected=$(wc -l < $detectedGenesList | xargs)
echo "TP + FP: Number of isoforms detected total ${numTranscriptDetected}"
