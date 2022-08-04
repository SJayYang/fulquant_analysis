suppressMessages(library(dplyr))
suppressMessages(library(DESeq2))
args = commandArgs(trailingOnly=TRUE)
folder = args[1]
folder <- "/home/yangs/full_ONT_data/ONT/NGS4416/RDA_files"
file_names <- list.files(folder)

matrices <- lapply(file_names, function(file) {
	exp <- readRDS(file = file.path(folder, file))
	exp <- as.data.frame.array(exp)
})

# combined <- merge(matrices[[1]], matrices[[2]], by = 'row.names', all = 'true')
combined2 <- do.call(merge, c(matrices, by = 'row.names', all = 'true'))
combined3 <- combined2[,-1]
rownames(combined3) <- combined2[,1]
saveRDS(combined3, file = file.path(folder, "combined_matrix.rds"))

cts <- readRDS(file = file.path(folder, "combined_matrix.rds"))

colData <- readRDS(file = file.path(folder, "annotColData.rds"))
cts <- na.omit(cts)

dds <- DESeqDataSetFromMatrix(countData = cts, colData = colData, design = ~ condition)

dds <- DESeq(dds)
res <- results(dds)
res