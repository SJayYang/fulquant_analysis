# Rscript performance_check.R
genome_folder=/home/yangs/FulQuant/hg38.98_ERCC_SIRV
gene_list=$genome_folder/gene_ID.gene_name.txt
output_folder=/home/yangs/ONT_comparisons/Dopa_Motor_m/combined/tx_annot
bed_file=$output_folder/tx_human_final.bed.gz
zcat $bed_file | cut -f4 | sort -u > $output_folder/gene_list.txt
sort -u $gene_list > $genome_folder/sorted_transcriptID.txt
join $output_folder/gene_list.txt $genome_folder/sorted_transcriptID.txt > $output_folder/combined.txt
