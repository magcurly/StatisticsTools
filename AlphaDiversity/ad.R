argv <- commandArgs(T)
if(length(argv) != 3){stop("Rscript alpha-diversity.r [profile] [Mapping.txt] [out]")}
dat<-read.table(argv[1],sep="\t",head=T,row.names=1,check.names=F);
dat<-as.matrix(dat)
#cn<-gsub("X","",colnames(dat))
#cn2<-gsub("\\.","-",cn)
#colnames(dat)<-cn2
result<-matrix(ncol=ncol(dat),nrow=4)
#result[1,]<-cn2
result[1,]<-colnames(dat)
for(i in 1:ncol(dat)){
	x<-dat[dat[,i]!=0,i]
	result[2,i]<- length(x)
	x.sum<-sum(x)
#	if(x.sum !=1){stop("Sum of col !=1")}
	result[3,i]<- (-1)*sum( (x/x.sum)*log(x/x.sum) )
	result[4,i]<- 1-sum( (x/x.sum)^2 )
}
result<-t(result)
colnames(result)<-c("#Sample","#GeneNum","#Shannon-wiener-index","#Simpson-diversity-index")
write.table(result,paste(argv[3],"alpha.result",sep=""),quote = F,sep = "\t",row.names = F, col.names = T)
library("RColorBrewer")
library("grid")
#if(length(argv) != 3){stop("Rscript alpha.R [profile] [grouping] [output prefix]")}
dat <- data.frame(result[,2:3])
#data <- as.matrix(data)
groups <- read.table(argv[2],header=F,check.names=F)
groups <- data.frame(groups)
groups2 <- as.factor(groups[,2])
#adj1 <- (max(dat[,1])-min(dat[,1]))*0.1
#adj2 <- (max(dat[,2])-min(dat[,2]))*0.1
col_pool <- brewer.pal(nlevels(groups2),"Set1")
#sort(as.numeric(groups2))

#drawing alpha boxplot
pdf(paste(argv[3],"Alpha_barplot.pdf",sep=""),width=6,height=5)
par(mai=c(1.75,0.8,0.75,0.5))
#plot(dat,pch=20,cex=1,col=col_pool[sort(as.numeric(groups2))],xlim=c(min(dat[,1])-adj1,max(dat[,1]+adj1)),ylim=c(min(dat[,2])-adj2,max(dat[,2])+adj2),xlab="Shannon-Wiener-Index",ylab="Simpson-Diversity-Index",bty="o",main="Alpha Index Plot"
boxplot(as.numeric(result[,3])~groups2,pch = 1,xlab = '',ylab = 'shannon',font=2,cex=1.2,las=2,cex.lab=1.2,col=col_pool,main="Shannon Index")

#text(dat,data[,1],pos=c(1,3),cex=0.8)
#legend(par("usr")[2],par("usr")[4],cex=1,x.intersp=0.4,pt.cex=1,unique(groups2),pch=20,col=col_pool,text.font=2,ncol=1,xpd=TRUE,bty="o")
dev.off()
