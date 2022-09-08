args = commandArgs(trailingOnly=TRUE)
folder = args[1]

load(file.path(folder, "combined/tx_annot", "clusters_quant.rda"))
# Return the merged table of the reference transcriptome and the output countMatrix from FulQuant
merge_tables <- function(mat, save_file) {
	# Get the tables from the reference and the countMatrix
	load('~/FulQuant/genome/tx.rda')	
	tx$clname <- gsub("chr", "", tx$clname)
	tx$clname <- gsub("SIRV", "SIRVomeERCCome", tx$clname)
	refTranscripts_df = as.data.frame(tx)
	
	countMatrix_df = as.data.frame(mat)
	countMatrix_df$clname = rownames(mat)
	mergedCountRef_df <- merge(refTranscripts_df, countMatrix_df, by = "clname", all = TRUE)

	num_samples <- length(colnames(countMatrix_df)) - 1 
	print(folder)
	lapply(seq(1:num_samples), function(x) {
		tp_entries <- mergedCountRef_df[!is.na(mergedCountRef_df$nannot) & !is.na(mergedCountRef_df[[39]]), ]
		tp_val <- dim(tp_entries[tp_entries[[33 + x]] > 0,])[1]
		full_vals <- dim(refTranscripts_df)[1]
		print(colnames(countMatrix_df)[x])
		print("sensitivity")
		print(tp_val / full_vals)

		fp_val <- dim(mergedCountRef_df[!is.na(mergedCountRef_df[[33 + x]]) & is.na(mergedCountRef_df$nannot), ])[1]
		print("precision")
		print(tp_val / (tp_val + fp_val))
		})
 
	save(countMatrix_df, refTranscripts_df, mergedCountRef_df, file = save_file)
	write.table(mergedCountRef_df, file.path(folder, 'combined_annot.csv'), sep = '\t')
	return(mergedCountRef_df)
}

merged_table <- merge_tables(runCountMat, file.path(folder, "dataframes_transcripts.rda"))

graph_count_distributions <- function(merged_table, sample_num) {
	transcripts <- merged_table[!is.na(merged_table[[1]]), ]
	has_transcript <- transcripts[!is.na(transcripts$nannot), ]
	has_transcript <- has_transcript[, (ncol(has_transcript)- sample_num +1):ncol(has_transcript)]
	NA_vals <- transcripts[is.na(transcripts$nannot), ]
	NA_vals <- NA_vals[, (ncol(NA_vals)- sample_num +1):ncol(NA_vals)]

	NA_vals_sum <- as.data.frame(rowSums(NA_vals)) 
	colnames(NA_vals_sum) = "count"
	has_transcript_sum <- as.data.frame(rowSums(has_transcript))
	colnames(has_transcript_sum) = "count"
	NA_vals_vector <- NA_vals_sum$count
	has_transcript_vector <- has_transcript_sum$count
	length(has_transcript_vector) <- length(NA_vals_vector)

	df <- data.frame(unannotated = NA_vals_vector, annotated = has_transcript_vector)
	df <- log(df, 2)
	library(reshape2)
	data <- melt(df)
	# geom_histogram, bins=100 
	ggplot(data, aes(value, color=variable)) +
	stat_ecdf(geom = "point") + ggtitle("Cumulative expression distributions of annotated and unannotated transcripts") +
	xlab("Log2 transformed counts") + theme(plot.title = element_text(size = 12))
 
}