require(ggplot2)
require(cowplot)
metaplot<-function(a){
  i=floor(length(a[,1])*0.01) 
  j=ceiling(length(a[,1])*0.99)
  a.sort=apply(a,2,sort)
  a.trim=a.sort[i:j,]
  a.mean=apply(a.trim,2,mean)
  a.se=apply(a.trim,2,sd)/sqrt(length(a.trim[,1]))
  a.d=data.frame(x=seq(-995,995,10),mean=a.mean,se=a.se)
}

#USE GRO as an example
gc1<-read.table("GRO.TSS.matrix.txt")
gc1<-metaplot(gc1)
gc1$position="TSS"

gc2<-read.table("GRO.PAS.matrix.txt")
gc2$gene<-rownames(gc2)
gc2<-metaplot(gc2)
gc2$position="PAS"


gro<-rbind(gc1,gc2)
gro$position<-factor(gro$position,levels = unique(gro$position))
p<-ggplot(gro,aes(x,mean))+
  geom_linerange(aes(x,ymin=mean-se,ymax=mean+se),colour="grey",size=1)+
  geom_line(size=1)+
  geom_hline(yintercept=0,colour="black",linetype="dashed")+
  geom_vline(xintercept = 0,colour="black",linetype="dashed")+
  labs(y = "Read density")+guides(size=guide_legend())+
  theme(panel.grid.minor=element_blank(),panel.background=element_blank(), panel.border=element_rect(fill=NA))+
  facet_grid(~position)
pp<-plot_grid(p)
save_plot("GRO.META.pdf",pp)
