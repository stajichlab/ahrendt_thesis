#!/usr/bin/env Rscript

library(GSEABase)
GOIDs <- as.vector(readLines("Clat_GOIds"))
Collection <- GOCollection(GOIDs)
slim <- getOBOCollection("GOSlim_aspergillus.obo")
GOSlim_BP <- goSlim(Collection, slim, "BP")
write.table(GOSlim_BP,file="Clat_BP_GOSlim_aspergillus.obo.tsv",quote=F,sep="\t")
BP_sorted <- GOSlim_BP[with(GOSlim_BP, order(Count)), ]
if(length(which(GOSlim_BP$Count == 0)) != 0) {
  BP_sorted <- BP_sorted[-which(BP_sorted$Count == 0),]
}
GOSlim_MF <- goSlim(Collection, slim, "MF")
write.table(GOSlim_MF,file="Clat_MF_GOSlim_aspergillus.obo.tsv",quote=F,sep="\t")
MF_sorted <- GOSlim_MF[with(GOSlim_MF, order(Count)), ]
if(length(which(GOSlim_MF$Count == 0)) != 0) {
  MF_sorted <- MF_sorted[-which(MF_sorted$Count == 0),]
}
GOSlim_CC <- goSlim(Collection, slim, "CC")
write.table(GOSlim_CC,file="Clat_CC_GOSlim_aspergillus.obo.tsv",quote=F,sep="\t")
CC_sorted <- GOSlim_CC[with(GOSlim_CC, order(Count)), ]
if(length(which(GOSlim_CC$Count == 0)) != 0) {
  CC_sorted <- CC_sorted[-which(CC_sorted$Count == 0),]
}
data <- c(log10(BP_sorted$Count),log10(CC_sorted$Count),log10(MF_sorted$Count))
left_labels <- c(as.vector(BP_sorted$Term),as.vector(CC_sorted$Term),as.vector(MF_sorted$Term))
right_labels <- c(BP_sorted$Count,CC_sorted$Count,MF_sorted$Count)
ymax <- sum(length(BP_sorted$Count),length(CC_sorted$Count),length(MF_sorted$Count))
colors <- c(rep("cornflowerblue",length(BP_sorted$Count)),rep("red",length(CC_sorted$Count)),rep("darkolivegreen1",length(MF_sorted$Count))) 

pdf("test2.pdf",width=15,height=30)
bplot <- barplot(width=0.8,ylim=c(0,ymax),xlim=c(0,4),data,horiz=TRUE,beside=FALSE,col=colors,yaxt="n")
axis(2,at=bplot,labels=left_labels,cex.axis=1,las=2,tick=FALSE)
axis(4,at=bplot,labels=right_labels,cex.axis=1,las=2,tick=FALSE)
dev.off()
