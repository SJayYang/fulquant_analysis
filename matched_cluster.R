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
	countMatrix_df$clname = rownames(mat)
	mergedCountRefMatrix_df <- merge(refTranscripts_df, countMatrix_df, by = "clname", all = TRUE)
	print("True positive: Matched cluster and values are existent")
	tp_entries <- mergedCountRefMatrix_df[!is.na(mergedCountRefMatrix_df$nannot) & !is.na(mergedCountRefMatrix_df[[39]]), ]
	tp_val <- dim(tp_entries[tp_entries[[39]] > 0,])[1]
	full_vals <- dim(refTranscripts_df)[1]
	print(folder)
	print("sensitivity")
	print(tp_val)
	print("total")
	print(full_vals)
	fp_val <- dim(mergedCountRefMatrix_df[!is.na(mergedCountRefMatrix_df[[39]]) & is.na(mergedCountRefMatrix_df$nannot), ])[1]
	print("precision")
	print(tp_val)
	print(tp_val + fp_val)

	save(countMatrix_df, refTranscripts_df, mergedCountRefMatrix_df, file = save_file)
	write.table(mergedCountRefMatrix_df, file.path(folder, 'combined_annot.csv'), sep = '\t')
}

merge_tables(runCountMat, file.path(folder, "dataframes_transcripts.rda"))

