#!/usr/bin/env Rscript
library(gplots)
library(fastcluster)
library(RColorBrewer)
library(pheatmap)
palette <- colorRampPalette(c('white','darkgreen'))(4)
breaks <- c(0,0.1,5,10,24)
dat <- data.matrix(read.table("../dat/photosense_rep.tsv",sep="\t",row.names=1,header=T))
taxonlistID <- read.delim("../../Appendix/dat/taxonlistID",comment.char="#",header=F)
colnames(taxonlistID) <- c("Abbr","Class2","Class1","TaxID","FullName","IsolateVersion","Website")
ann_row <- data.frame("Taxa"=taxonlistID$Class1)

rownames(ann_row) <- taxonlistID$FullName
rownames(dat) <- taxonlistID$FullName[na.omit(match(rownames(dat),taxonlistID$Abbr))]
names <- rownames(dat)

png('photosenseHeatmap.png',width=2000,height=2000,res=300)
pheatmap(dat,cluster_cols=F,cluster_rows=F,col=palette,breaks=breaks,
annotation_row=ann_row,
display_numbers=T,number_format="%.0f",number_color="black",fontsize_number=8,legend=F)
dev.off()
