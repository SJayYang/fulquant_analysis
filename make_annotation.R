generate_annotation_file <- function(folder1, folder2) {
	file_names1 <- list.files(folder1)
	file_names2 <- list.files(folder2)
	file_names1 <- lapply(file_names1, function(name) {
		tools::file_path_sans_ext(tools::file_path_sans_ext(name))
	})
	file_names2 <- lapply(file_names2, function(name) {
		tools::file_path_sans_ext(tools::file_path_sans_ext(name))
	})
	coldata1 <- data.frame(matrix(ncol = 2, nrow = length(file_names1)))
	colnames(coldata1) <- c('condition', 'type')
	rownames(coldata1) <- file_names1
	coldata1$condition <- "control"
	coldata1$type <- "paired-end"
	coldata2 <- data.frame(matrix(ncol = 2, nrow = length(file_names2)))
	colnames(coldata2) <- c('condition', 'type')
	rownames(coldata2) <- file_names2
	coldata2$condition <- "treatment"
	coldata2$type <- "paired-end"
	coldata <- rbind(coldata1, coldata2)
	return(coldata)
}

folder1 = "/home/yangs/full_ONT_data/ONT/NGS4416/R8143/fastq/demultiplexed"
folder2 = "/home/yangs/full_ONT_data/ONT/NGS4416/R8144/fastq/demultiplexed"

coldata <- generate_annotation_file(folder1, folder2)
print(coldata)