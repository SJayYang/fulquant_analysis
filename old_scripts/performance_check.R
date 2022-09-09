
# This script writes the transcript names from the reference genome
folder = "/home/yangs/FulQuant/hg38.98_ERCC_SIRV"
gtf.file = file.path(folder, "SIRV3_ERCC_Homo_sapiens.GRCh38.98.gtf")
gtf.gr = rtracklayer::import(gtf.file) # creates a GRanges object
gtf.df = as.data.frame(gtf.gr)
genes = unique(gtf.df[ ,"transcript_name"])
write.table(genes, file=file.path(folder, "transcript_name_list.txt"), row.names = FALSE, quote=FALSE, col.names = FALSE)
