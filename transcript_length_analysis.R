suppressMessages(library(GenomicFeatures))
original_genome_file="/home/yangs/FulQuant/hg38.98_ERCC_SIRV/SIRV3_ERCC_Homo_sapiens.GRCh38.98.gtf"
sequins_genome_file="/home/yangs/FulQuant/genome/rnasequin_annotation_2.4.gtf"
transcript_genome_file="/home/yangs/matrices_data/Dopa_motor_m/tx_annot/out.gtf"
TxDb <- makeTxDbFromGFF(original_genome_file, format="gtf")
hg38_lengths <- transcriptLengths(TxDb)
TxDb <- makeTxDbFromGFF(sequins_genome_file, format="gtf")
sequins_lengths <- transcriptLengths(TxDb)
## To make GTF file for transcript, run 
# bedToGenePred in.bed /dev/stdout | genePredToGtf file /dev/stdin out.gtf
TxDb <- makeTxDbFromGFF(transcript_genome_file)
transcript_lengths <- transcriptLengths(TxDb)
output_file="/home/yangs/matrices_data/lengths.rda"
save(hg38_lengths, sequins_lengths, transcript_lengths, file = output_file)

load('~/lengths.rda')

library(ggplot2)
library(reshape2)

sequins_lengths_vector <- sequins_lengths$tx_len
transcript_lengths_vector <- transcript_lengths$tx_len
length(sequins_lengths_vector) <- length(hg38_lengths$tx_len)
length(transcript_lengths_vector) <- length(hg38_lengths$tx_len)
df <- data.frame(genome = hg38_lengths$tx_len, sequins = sequins_lengths_vector, transcripts = transcript_lengths_vector)
data <- melt(df)

ggplot(data, aes(x=value, fill=variable)) +
  geom_density(alpha=.25) + scale_x_continuous(trans='log2', limits = c(64, 16384))

# Repliace number of isoforms per gene 
genome_isoforms="~/isoform_num_genome.txt"
transcripts_isoforms="~/isoform_num_transcripts.txt"
sequins_isoforms="~/isoform_num_sequins.txt"
genome_isoforms_table <- read.table(genome_isoforms)
transcripts_isoforms_table <- read.table(transcripts_isoforms)
sequins_isoforms_table <- read.table(sequins_isoforms)
genome_isoforms_vector <- genome_isoforms_table$V2
sequins_isoforms_vector <- sequins_isoforms_table$V2
transcripts_isoforms_vector <- transcripts_isoforms_table$V1
length(sequins_isoforms_vector) <- length(genome_isoforms_vector)
length(transcripts_isoforms_vector) <- length(genome_isoforms_vector)
df <- data.frame(genome = genome_isoforms_vector, sequins = sequins_isoforms_vector, transcripts = transcripts_isoforms_vector)
data <- melt(df)
ggplot(data, aes(x=value, fill=variable)) +
  geom_density(alpha=.15) + scale_x_continuous(trans='log2', limits = c(1, 32)) 
