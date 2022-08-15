# Use DESeq2 to run differential alternative splicing analysis
suppressMessages(library(dplyr))
suppressMessages(library(DESeq2))
args = commandArgs(trailingOnly=TRUE)
folder = args[1]

load(file.path(folder, "clusters_quant.rda"))
cts <- runCountMat

# Generate from make_annotation.R
colData <- readRDS(file = file.path(folder, "annotColData.rds"))
cts <- na.omit(cts)

dds <- DESeqDataSetFromMatrix(countData = cts, colData = colData, design = ~ condition)

dds <- DESeq(dds)
res <- results(dds)
saveRDS(res, file.path(folder, "DASAnalysisResults.rds"))