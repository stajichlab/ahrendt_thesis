#!/usr/bin/env Rscript
library(gplots)
library(fastcluster)
library(RColorBrewer)
library(pheatmap)
palette <- colorRampPalette(c('white','darkgreen'))(2)
dat <- data.matrix(read.table("../dat/flagProfile_repBin_trimmed.tsv", sep="\t",row.names=1,header=T))
taxonlistID <- read.delim("../dat/taxonlistID",comment.char="#")
ann_col <- data.frame("Taxa"=taxonlistID$Class1)
rownames(ann_col) <- taxonlistID$Abbr
categories <- data.frame(t(read.delim("../dat/flagProfile_Categories.tsv",row.names=1)))
ann_row <- data.frame("Cat"=categories$Category)
rownames(ann_row) <- rownames(categories)
png('flagDataHeatmap.png',width=1000,height=1000)
pheatmap(dat,cluster_cols=FALSE,cluster_rows=TRUE,col=palette,clustering_method="complete",
         annotation_col=ann_col,
         annotation_row=ann_row,
         legend=F,show_rownames=F)
dev.off()
