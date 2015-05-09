#!/usr/bin/env Rscript
library(gplots)
library(fastcluster)
library(RColorBrewer)
library(pheatmap)
palette <- colorRampPalette(c('white','darkgreen'))(2)
dat <- data.matrix(read.table("../dat/flagProfile_binary.tsv", sep="\t",row.names=1,header=T))
dat <- dat[,-1]
taxonlistID <- read.delim("../dat/taxonlistID",comment.char="#")
ann_col <- data.frame("Taxa"=taxonlistID$Class1)
rownames(ann_col) <- taxonlistID$Abbr
png('flagDataHeatmap.png')
pheatmap(dat,cluster_cols=TRUE,cluster_rows=TRUE,col=palette,clustering_method="complete",annotation_col=ann_col,legend=F)
dev.off()
