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
