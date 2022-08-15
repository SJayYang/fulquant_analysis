# Make annotation file for DESeq2
args = commandArgs(trailingOnly=TRUE)
folder = args[1]

generate_annotation_file <- function(folder) {
	file_names <- list.files(folder, pattern = "\\.fastq.gz$")
	file_names1 <- file_names[1:3]
	file_names2 <- file_names[4:6]
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
	coldata$condition <- factor(coldata$condition)
	coldata$type <- factor(coldata$type)
	return(coldata)
}

fastq_data <- file.path(folder, "fastq/demultiplexed")
coldata <- generate_annotation_file(fastq_data)
outputfolder = file.path(folder, "combined/tx_annot")
saveRDS(coldata, file = file.path(outputfolder, "annotColData.rds"))