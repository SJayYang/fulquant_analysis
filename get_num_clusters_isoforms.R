## Get num of isoforms prefiltering
load('all.clustered.rda')
clustered <- subset(myreads, myreads$rcluster != "unclustered")
exp_names <- sort(unique(sapply(strsplit(clustered$name,":"), '[', 1)))
for (i in 1:length(exp_names)) {
	x <- subset(clustered, grepl(exp_names[[i]], clustered$name))
	print(length(unique(x$rcluster)))
}

### Get num of isoforms after filtering
load('clusters_quant.rda')
colSums(runCountMat != 0)

# Get num of genes 
runCount <- readRDS("clusters_quant_runCount.rds")
load('tx_human.rda')
filtered <- finalTx[finalTx$all_cl %in% rownames(runCount)]
filtered <- filtered[, c('all_cl', 'associated_gene')]
final_num <- unlist(lapply(seq(1:length(colnames(runCount))), function(id) {
	just_1 <- as.data.frame(runCount[, id])
	colnames(just_1) <- "expression"
	just1_nonzero <- subset(just_1, just_1$expression != 0)
	cl_names <- unique(rownames(just1_nonzero))
	length(filtered[filtered$all_cl %in% cl_names]$associated_gene)
}))

print(final_num)


# Plot the isoform expression levels distribution for each sample
library(ggplot2)
library(reshape2)
df <- readRDS("clusters_quant_runCount.rds")
data <- melt(df)
data$Var1 <- NULL	
ggplot(data, aes(x=value, color=Var2, group = as.factor(data$Var2))) +
  geom_histogram(alpha = 0.15, position="identity") + scale_x_continuous(trans='log10')

