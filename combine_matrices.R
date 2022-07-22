library(dplyr)
args = commandArgs(trailingOnly=TRUE)
folder = args[1]
folder <- "/Users/Yangs113/rda_files"
file_names <- list.files(folder)

matrices <- lapply(file_names, function(file) {
	exp <- readRDS(file = file.path(folder, file))
	exp <- as.data.frame.array(exp)
})

# combined <- merge(matrices[[1]], matrices[[2]], by = 'row.names', all = 'true')
combined2 <- do.call(merge, c(matrices, by = 'row.names', all = 'true'))
saveRDS(combined2, file = file.path(folder, "combined_matrix.rds"))
