# Script to plot the spike in controls expression levels
load('clusters_quant.rda')
load('~/FulQuant/genome/tx.rda')
transcripts <- rownames(runCountMat)
SIRV_names <- transcripts[grepl("SIRVomeERCCome", transcripts)]
tx$clname <- gsub("chr", "", tx$clname)
tx$clname <- gsub("SIRV", "SIRVomeERCCome", tx$clname)
filtered <- tx[tx$clname %in% rownames(runCountMat)]
filtered <- filtered[, c('clname', 'gene_id', 'gene_name', 'transcript_id', 'transcript_name')]
df <- as.data.frame(runCountMat)
v1 <- colSums(df) / 1000000
df_TPM <- t(t(df)*v1) + 1
df_TPM <- as.data.frame(df_TPM)
matched <- match(rownames(df_TPM), filtered$clname)
df_TPM$transcript_name <- filtered$transcript_name[matched]
df_TPM$gene_id <- filtered$gene_id[matched]
SIRV_vals <- df_TPM[grepl("SIRV", df_TPM$transcript_name), ]
SIRV_vals$transcript_name <- NULL
SIRV_vals$gene_id <- NULL
saveRDS(SIRV_vals, "SIRV_spike_in.rds")

library(ggplot2)
library(reshape2)
SIRV_spike_in <- readRDS("SIRV_spike_in.rds")
data <- melt(SIRV_spike_in)
ggplot(data, aes(y=value, fill=variable)) + geom_boxplot(alpha = 0.15, show.legend = FALSE) + scale_y_continuous(trans='log2') + ylab("Log 10 expression") + ggtitle("SIRV expression distribution (diff dopa vs diff motor)") + theme(axis.title.x=element_blank(),
                                                                                                                                                                                                                             axis.text.x=element_blank(),
                                                                                                                                                                                                                             axis.ticks.x=element_blank())