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

# Get num of genes detected
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
v1 <- colSums(df) / 1000000
df_TPM <- t(t(df)*v1) + 1
df_trans_log <- log10(df_TPM)

data <- melt(df_trans_log)
data$Var1 <- NULL	
ggplot(data, aes(x=value, color=Var2, group = as.factor(Var2))) +
  geom_histogram(alpha = 0.15, position="identity") # + scale_x_continuous(trans='log10')


# Plot the MA plot for comparison of expression level differences between datasets

library(dplyr)
library(limma)
control_group <- df_TPM[, 1:3]
treatment_group <- df_TPM[, 4:6]
control_sums <- as.data.frame(rowSums(control_group))
treatment_sums <- as.data.frame(rowSums(treatment_group))
combined_sums <- merge(control_sums, treatment_sums, by=0, all.x=TRUE)
combined_sums2 <- combined_sums[,-1]
rownames(combined_sums2) <- combined_sums[,1]
colnames(combined_sums2) <- c("Control", "Treatment")
plotMA(as.matrix(combined_sums2))

combined_sums2 <- combined_sums2 + 0.001
combined_sums2$fc <- log2(combined_sums2$Control / combined_sums2$Treatment)
combined_sums2$avg <- log2((combined_sums2$Treatment + combined_sums2$Control) / 2)

ggplot(combined_sums2, aes(x = avg, y = fc)) + geom_point(size = 2) 

