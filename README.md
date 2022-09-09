Important output file in FulQuant

Within combined/tx_annot, look at clusters_quant.rda (this contains the runCountMat and sampleCountMat) for expression data
Most of the scripts use this output file as their input

Descriptions of scripts: 

1. DASAnalysis.R - contains the script for DESeq2 analysis, as well as script for recreating the padj value scatterplot graph. Run the rename_isiforms.R script beforehand, as well as make_DESeq2_annotation.R

2. generateTxRdaTranscriptome.R - contains initial script that author had sent over to me to recreate the tx.rda file. Also contains the script created by me (generate_clnames) to repliace the clnames column in the tx.rda file

3. matched_cluster.R - script contains function that creates a merged table between the tx.rda tx object and the runCountMat file returned by fulQuant. Also contains a function that creates a culmulative expression distribution graph. 

4. rename_isoforms.R - the original matching script that is replaced by matched_cluster. Will make matrices that are named. 

5. SOP.sh - script that tells you how to make conda environment.

6. transcript_length_analysis.R - script that analyzes difference in transcript lengths between the reference, sequins, and the transcripts discovered by FulQUant. Also analyses different number of isoforms detected for each gene in each group. Run isoform_num.sh beforehand 

7. make_DESeq2_annotation.R - make the annotation file for DESeq2 differential testing, described in their website

8. spike_in_analysis.R - script to 