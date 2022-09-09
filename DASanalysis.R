# Use DESeq2 to run differential alternative splicing analysis
suppressMessages(library(dplyr))
suppressMessages(library(DESeq2))
args = commandArgs(trailingOnly=TRUE)
folder = args[1]
tx_annot_folder = file.path(folder, "combined/tx_annot")

load(file.path(tx_annot_folder, "clusters_quant.rda"))
cts <- runCountMat

# Generate from make_annotation.R
colData <- readRDS(file = file.path(tx_annot_folder, "annotColData.rds"))
cts <- na.omit(cts)

dds <- DESeqDataSetFromMatrix(countData = cts, colData = colData, design = ~ condition)

dds <- DESeq(dds)
res <- results(dds)
save(dds, res, file = file.path(tx_annot_folder, "DASAnalysis.rda"))
saveRDS(as.data.frame(res), file = file.path(tx_annot_folder, "DASAnalysisResults.rds"))

# After naming the DAS results using rename_isoforms.R, find out which transcripts were originally detected
# Compare the padj values
DASAnalysisResults_named <- readRDS("DASAnalysisResults_named.rds")
tables <- DASAnalysisResults_named
# Fig5.txt is the file from this url. 
# https://static-content.springer.com/esm/art%3A10.1038%2Fs41467-021-24484-z/MediaObjects/41467_2021_24484_MOESM6_ESM.txt
# Supplementary Table 5 in FulQuant paper
detected <- read.table(file = "fig5.txt", sep = "\t")
header.true <- function(df) {
  names(df) <- as.character(unlist(df[1,]))
  df[-1,]
}
detected <- header.true(detected)
tables <- tables[tables$transcript_name %in% detected$transcript, ]
detected <- detected[detected$transcript %in% tables$transcript_name, ]
matched <- match(tables$transcript_name, detected$transcript)
tables$padj_orig <- detected$padj[matched]
tables$transcript_name_orig <- detected$transcript[matched]

library(ggplot2)
ggplot(tables, aes(x=padj, y=padj_orig)) +
  geom_point(size=1, shape=23) + ggtitle("Replicated DESeq2 padj values of FulQuant data isoforms") + theme(axis.text.y=element_blank(), axis.ticks.y = element_blank())
