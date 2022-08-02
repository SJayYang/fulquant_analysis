genome_folder=/home/yangs/fulquant_test_data/combined/tx_annot
genome_file=$genome_folder/out.gtf
python gtf_read_lengths.py $genome_file | sed -e 's/^[[:space:]]*//' > $genome_folder/isoform_num.txt
# cut -f1 -d "-" $genome_folder/lengths.txt | tr -d '"' | uniq -c | sed -e 's/^[[:space:]]*//' | cut -f1 -d " " > lengths_num.txt