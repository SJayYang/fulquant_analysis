runCount <- readRDS("clusters_quant_runCount.rds")
load('txCluster.rda')
transcripts <- rownames(runCountMat)
SIRV_names <- transcripts[grepl("SIRVomeERCCome", transcripts)]
SIRV_transcripts <- runCount[SIRV_names, ]
consensusCluster <- thisTxCluster$consensus
clnames_clusters <- consensusCluster[195755:length(consensusCluster), ]$clname
reordered <- SIRV_transcripts[clnames_clusters,]

# Think about matching the sequence ranges to the original GTF file, getting the name from the original GTF file and then renaming the R rownames
