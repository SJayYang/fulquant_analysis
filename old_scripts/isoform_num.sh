# Runt his after replicateFig1.R

original_genome_file=/home/yangs/FulQuant/hg38.98_ERCC_SIRV/SIRV3_ERCC_Homo_sapiens.GRCh38.98.gtf
sequins_genome_file=/home/yangs/FulQuant/genome/rnasequin_annotation_2.4.gtf
output_folder=/home/yangs/fulquant_test_data/combined/tx_annot
transcript_file=$output_folder/out.gtf
python gtf_read_lengths.py $transcript_file | cut -f1 -d "-" | tr -d '"' | uniq -c | sed -e 's/^[[:space:]]*//'  > $output_folder/isoform_num_transcripts.txt
python gtf_read_lengths.py $original_genome_file | sed -e 's/^[[:space:]]*//' > $output_folder/isoform_num_genome.txt
python gtf_read_lengths.py $sequins_genome_file | sed -e 's/^[[:space:]]*//' > $output_folder/isoform_num_sequins.txt
# cut -f1 -d "-" $output_folder/lengths.txt | tr -d '"' | uniq -c | sed -e 's/^[[:space:]]*//' | cut -f1 -d " " > lengths_num.txt