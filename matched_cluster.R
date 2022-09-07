args = commandArgs(trailingOnly=TRUE)
folder = args[1]

load(file.path(folder, "clusters_quant.rda"))
# Return the merged table of the reference transcriptome and the output countMatrix from FulQuant
merge_tables <- function(mat, save_file) {
	# Get the tables from the reference and the countMatrix
	load('~/FulQuant/genome/tx.rda')	
	tx$clname <- gsub("chr", "", tx$clname)
	tx$clname <- gsub("SIRV", "SIRVomeERCCome", tx$clname)
	refTranscripts_df = as.data.frame(tx)
	
	countMatrix_df = as.data.frame(mat)
	countMatrix_df$clname = rownames(mt_gr)
	mergedCountRefMatrix_df <- merge(refTranscripts_df, countMatrix_df, by = "clname", all = TRUE)
	print("not annotated")
	print(sum(is.na(mergedCountRefMatrix_df$name)))
	print("annotated")
	print(sum(!is.na(mergedCountRefMatrix_df$name)))
	save(countMatrix_df, refTranscripts_df, mergedCountRefMatrix_df, file = save_file)
	write.table(mergedCountRefMatrix_df, file.path(folder, 'combined_annot.csv'), sep = '\t')
}

merge_tables(runCountMat, file.path(tx_annot_folder, "dataframes_transcripts.rda"))