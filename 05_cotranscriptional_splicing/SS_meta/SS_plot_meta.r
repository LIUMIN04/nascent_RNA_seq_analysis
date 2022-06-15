require(dplyr)
require(ggplot2)

meta_ratio<-function(a){
  a$sum=apply(a,1,sum)
  a.r=a[,1:100]/(a$sum+1)
  a.mean=apply(a.r,2,mean)   
  a.se=apply(a.r,2,sd)/sqrt(length(a.r[,1])) 
  a.d=data.frame(x=seq(1,100,1),mean=a.mean,se=a.se) 
}


#use GRO as an example
active<-read.csv("F:/01-transcriptome_methods/gene_activity/TECH.active.mean.RPKM.csv") %>% dplyr::select(gene)

n5<-read.table("GRO.combined.5SS.matrix.txt")
gene=data.frame(gene=substr(rownames(n5),1,9))
n5$gene=gene$gene
n5<-merge(active,n5)[,2:101]
n5<-meta_ratio(n5)
n5$type="control"


n3<-read.table("GRO.combined.3SS.matrix.txt")
gene=data.frame(gene=substr(rownames(n3),1,9))
n3$gene=gene$gene
n3<-merge(active,n3)[,2:101]
n3<-meta_ratio(n3)
n3$type="heat"


n53<-rbind(n5,n3)

ggplot(n53,aes(x,mean))+
  geom_linerange(aes(x,ymin=mean-se,ymax=mean+se),colour="grey")+
  geom_bar(stat = "identity",fill="blue",width=1)+
  geom_hline(yintercept=0,colour="grey",linetype="dashed")+
  geom_vline(xintercept = 50,colour="grey",linetype="dashed")+
  labs(y = "Reads density")+guides(size=guide_legend())+
  theme(panel.grid.minor=element_blank(),panel.background=element_blank(), panel.border=element_rect(fill=NA))+
  facet_grid(~type)
