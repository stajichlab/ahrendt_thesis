#!/usr/bin/env Rscript
## Molecular Dynamics plots
Tpac2Z73_mdout <- read.table("../dat/Tpac2Z73_retCI_ProdSummary.EPTOT",header=T,sep="\t")
Tpac2Z73_mdout$Time <- Tpac2Z73_mdout$Time/1000
Spun00350_mdout <- read.table("../dat/Spun00350_retCI_ProdSummary.EPTOT",header=T,sep="\t")
Spun00350_mdout$Time <- Spun00350_mdout$Time/1000
Tpac2Z73_rms <- read.table("../dat/Tpac2Z73_retCI.rms",header=T,sep="\t")
Tpac2Z73_rms$Time <- Tpac2Z73_rms$Time/200
Spun00350_rms <- read.table("../dat/Spun00350_retCI.rms",header=T,sep="\t")
Spun00350_rms$Time <- Spun00350_rms$Time/200
png("TpSp_mdoutRMS.png",width=1000,height=2000)
par(mfrow=c(2,1),mar=c(6.5,7,6.5,1),mgp=c(5,1,0))
plot(Tpac2Z73_mdout,type="l",yaxs="i",xaxs="i",ylim=c(-9000,0),col="darkslateblue",
     ylab="Potential Energy",
     xlab="Time (ns)",
     cex.lab=2,cex.axis=2)
lines(Spun00350_mdout,yaxs="i",xaxs="i",col="gray55")
mtext("A", side=3, adj=0, line=1.2, cex=6, font=2)
plot(Spun00350_rms,type="l",yaxs="i",xaxs="i",xlab="Time (ns)",xlim=c(0,10),col="gray55",cex.lab=2,cex.axis=2)
lines(Tpac2Z73_rms,yaxs="i",xaxs="i",col="darkslateblue")
mtext("B", side=3, adj=0, line=1.2, cex=6, font=2)
dev.off()

## covalent docking plots
AmDock <- read.table("../dat/Amac00698_ZINC_dockSumm",header=T)
colnames(AmDock) <- paste("Am",colnames(AmDock),sep=".")
AmDock <- t(AmDock)
BdDock <- read.table("../dat/Bden04847_ZINC_dockSumm",header=T)
colnames(BdDock) <- paste("Bd",colnames(BdDock),sep=".")
BdDock <- t(BdDock)
TpDock <- read.table("../dat/Tpac2Z73_ZINC_dockSumm",header=T)
colnames(TpDock) <- paste("Tp",colnames(TpDock),sep=".")
TpDock <- t(TpDock)
all.dock <- data.frame(rbind(BdDock,AmDock,TpDock))
all.dock <- all.dock[,1:10]
all.dock$Model <- rep(c("Bd","Am","Tp"),each=87)
all.dock$Ligand <- rep(1:87,3)
library(reshape2)
stacked.dock <- melt(all.dock, id=c('Model','Ligand'))
stacked.dock <- stacked.dock[, -3] # remove the column that gives the column name of the concentration from all.data
png("dockPlot.png",width=3000,height=5000,res=300)
boxplot(value~Model + Ligand, data=stacked.dock, col=c("gray60","red","darkgreen"),horizontal=T,las=1,cex.axis=0.5,ylim=c(-12,0))
dev.off()
