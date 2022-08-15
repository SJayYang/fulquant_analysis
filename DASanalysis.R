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
save(res, file = file.path(tx_annot_folder, "DASAnalysisResults.rds"))