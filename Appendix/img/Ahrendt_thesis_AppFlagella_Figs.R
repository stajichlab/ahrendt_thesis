#!/usr/bin/env Rscript
library(gplots)
library(fastcluster)
library(RColorBrewer)
library(pheatmap)
palette <- colorRampPalette(c('white','darkgreen'))(2)
dat <- data.matrix(read.table("../dat/flagProfile_binary_shortlist.tsv", sep="\t",row.names=1,header=T))
taxonlistID <- read.delim("../dat/taxonlistID",comment.char="#")
colnames(taxonlistID) <- c("Abbr","Class2","Class1","TaxID","FullName","IsolateVersion","Website")
ann_col <- data.frame("Taxa"=taxonlistID$Class1)
rownames(ann_col) <- taxonlistID$Abbr
categories <- data.frame(t(read.delim("../dat/flagProfile_Categories.tsv",row.names=1)))
ann_row <- data.frame("Cat"=categories$Category)
rownames(ann_row) <- rownames(categories)
png('flagDataHeatmap2.png',width=1500,height=1500,res=300)
pheatmap(t(dat),cluster_cols=FALSE,cluster_rows=FALSE,col=palette,clustering_method="complete",
         annotation_col=ann_row,
         annotation_row=ann_col,
         cellheight=10,
         cellwidth=10,
         legend=F,show_rownames=T)
dev.off()
