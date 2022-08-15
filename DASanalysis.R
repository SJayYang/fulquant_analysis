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
DASAnalysisResults_named <- readRDS("~/fulquant_dir_downloaded/fulquant_test_data/tx_annot/DASAnalysisResults_named.rds")
tables <- DASAnalysisResults_named
tables <- tables[tables$pvalue < 0.001, ]
detected <- read.table(file = "~/Downloads/fig5.txt", sep = "\t")
both <- tables[tables$transcript_name %in% detected$V1, ]