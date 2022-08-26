# File to generate the tx.rda file for downstream analsysis (Steps 9, 10, 11, 12)
library(rtracklayer)
## look at the features of gtf of sequin for transcripts
## in principle works for all gtf files

# Code given from author
infolder = "."

gtfFile = file.path(infolder, "gencode.v21.annotation.SIRV3_ERCC.gtf")
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

# generate the cluster IDs based off of the reference exon blocks
generate_clnames <- function(tx) { 
	# Get the list of exon blocks
	mclapply(seq(length(tx)), function(transcript) {
		gr <- tx[transcript, ]
		chr_name <- as.character(seqnames(gr))

		lapply(gaps(gr$blocks), function(intron_blocks) {
			cl = ""
			if (length(intron_blocks) == 0) {
				start_site_string = paste(chr_name, start(ranges(gr)), sep = "_")
				end_site_string = paste(chr_name, end(ranges(gr)), sep = "_")
				cluster_string = paste(start_site_string, end_site_string, sep = "-")
				cl = paste(cl, cluster_string, sep = ";")
			}
			else {
				for (i in seq(length(intron_blocks))) {
					start_site = start(intron_blocks) + start(ranges(gr))
					start_site_moved = start_site[i] - 2
					end_site = end(intron_blocks) + start(ranges(gr))
					end_site_moved = end_site[i]
					start_site_string = paste(chr_name, start_site_moved, sep = "_")
					end_site_string = paste(chr_name, end_site_moved, sep = "_")
					cluster_string = paste(start_site_string, end_site_string, sep = "-")
					cl = paste(cl, cluster_string, sep = ";")
				}
			}
			substring(cl, 2)
		})

	})
}