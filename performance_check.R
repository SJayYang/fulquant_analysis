gtf.file = "/home/yangs/FulQuant/hg38.98_ERCC_SIRV/SIRV3_ERCC_Homo_sapiens.GRCh38.98.gtf"
gtf.gr = rtracklayer::import(gtf.file) # creates a GRanges object
gtf.df = as.data.frame(gtf.gr)
genes = unique(gtf.df[ ,"transcript_name"])
write.table(genes, file="gene_ID.gene_name.txt", row.names = FALSE, quote=FALSE, col.names = FALSE)
