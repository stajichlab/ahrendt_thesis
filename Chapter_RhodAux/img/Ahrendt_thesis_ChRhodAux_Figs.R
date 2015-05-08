#!/usr/bin/env Rscript
library(gplots)
library(fastcluster)
library(RColorBrewer)
library(pheatmap)
palette <- colorRampPalette(c('white','darkgreen'))(2)
dat <- data.matrix(read.table("../dat/photosense_repBin.tsv",sep="\t",row.names=1,header=T))
taxonlistID <- read.delim("../../Appendix/dat/taxonlistID",comment.char="#")
ann_row <- data.frame("Taxa"=taxonlistID$Class1)
rownames(ann_row) <- taxonlistID$Abbr
png('photosenseHeatmap.png')
pheatmap(dat,cluster_cols=F,cluster_rows=F,col=palette,annotation_row=ann_row)
dev.off()
