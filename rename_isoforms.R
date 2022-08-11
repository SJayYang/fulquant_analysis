load('clusters_quant.rda')
load('~/FulQuant/genome/tx.rda')
transcripts <- rownames(runCountMat)
SIRV_names <- transcripts[grepl("SIRVomeERCCome", transcripts)]
tx$clname <- gsub("chr", "", tx$clname)
tx$clname <- gsub("SIRV", "SIRVomeERCCome", tx$clname)
filtered <- tx[tx$clname %in% rownames(runCountMat)]
# filtered <- tx[tx$clname %in% SIRV_names]
# filtered <- tx[grepl("SIRV", tx$transcript_id)]
filtered <- filtered[, c('clname', 'gene_id', 'gene_name', 'transcript_id', 'transcript_name')]
matched <- match(rownames(runCountMat), filtered$clname)
gr <- as.data.frame(runCountMat)
gr$transcript_name <- filtered$transcript_name[matched]
gr$gene_id <- filtered$gene_id[matched]

NA_vals <- gr[is.na(gr$transcript_name), ]
has_transcript <- gr[!is.na(gr$transcript_name), ]
saveRDS(gr, file = "countMatrixNames.rds")
write.table(gr, file = "countMatrixNames.txt", sep = "\t")