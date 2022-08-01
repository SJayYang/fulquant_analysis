suppressMessages(library(GenomicFeatures))
original_genome_file="/home/yangs/FulQuant/hg38.98_ERCC_SIRV/SIRV3_ERCC_Homo_sapiens.GRCh38.98.gtf"
sequins_genome_file="/home/yangs/FulQuant/genome/rnasequin_annotation_2.4.gtf"
transcript_bed_file="/home/yangs/matrices_data/Dopa_motor_m/tx_annot/tx_human.rda"
TxDb <- makeTxDbFromGFF(original_genome_file, format="gtf")
hg38_lengths <- transcriptLengths(TxDb)
TxDb <- makeTxDbFromGFF(sequins_genome_file, format="gtf")
sequins_lengths <- transcriptLengths(TxDb)
load(transcript_bed_file)
TxDb <- makeTxDbFromGRanges(finalTx)
transcript_lengths <- transcriptLengths(TxDb)
output_file="/home/yangs/matrices_data/lengths.rda"
save(hg38_lengths, sequins_lengths, transcript_lengths, file = output_file)

