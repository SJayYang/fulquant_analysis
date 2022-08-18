library(rtracklayer)
## look at the features of gtf of sequin for transcripts
## in principle works for all gtf files

infolder = "."

gtfFile = file.path(infolder, "SIRV3_ERCC_Homo_sapiens.GRCh38.98.gtf")
gtf = import(gtfFile)

tx = gtf[gtf$type == "exon"]
mytx = gtf[gtf$type == "transcript"]

tx = asBED(split(tx,factor(tx$transcript_id, mytx$transcript_id)))

stopifnot(identical(mytx$transcript_id, tx$name))

mcols(tx)  = cbind(mcols(tx), mcols(mytx))

sequinTx = tx
sequinGenes = gtf[gtf$type == "gene"]

outfolder = "."
save(sequinTx, sequinGenes, file=file.path(outfolder,"sequinTx.rda"))