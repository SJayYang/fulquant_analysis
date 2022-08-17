# Function that takes in reference transcriptome, and renames rownames based
# on transcript_ID
rename_matrix <- function(matrix) {
	load('~/FulQuant/genome/tx.rda')
	# transcripts <- rownames(runCountMat)
	# SIRV_names <- transcripts[grepl("SIRVomeERCCome", transcripts)]
	tx$clname <- gsub("chr", "", tx$clname)
	tx$clname <- gsub("SIRV", "SIRVomeERCCome", tx$clname)
	filtered <- tx[tx$clname %in% rownames(matrix)]
	# filtered <- tx[tx$clname %in% SIRV_names]
	# filtered <- tx[grepl("SIRV", tx$transcript_id)]
	filtered <- filtered[, c('clname', 'gene_id', 'gene_name', 'transcript_id', 'transcript_name')]
	matched <- match(rownames(matrix), filtered$clname)
	gr <- as.data.frame(matrix)
	gr$transcript_name <- filtered$transcript_name[matched]
	gr$gene_id <- filtered$gene_id[matched]
	return(as.data.frame(gr))
}

# Rename the entire countMatrix
load('clusters_quant.rda')
gr <- rename_matrix(runCountMat)

NA_vals <- gr[is.na(gr$transcript_name), ]
has_transcript <- gr[!is.na(gr$transcript_name), ]
saveRDS(gr, file = "countMatrixNames.rds")

# Rename the files detected through DESEQ2
tables <- readRDS('DASAnalysisResults.rds')
tables <- rename_matrix(tables)
saveRDS(tables, "DASAnalysisResults_named.rds")