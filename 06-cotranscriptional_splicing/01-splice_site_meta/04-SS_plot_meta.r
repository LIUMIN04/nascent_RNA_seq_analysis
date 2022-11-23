require(ggplot2)
require(dplyr)
require(cowplot)

metaplot<-function(a){
  i=floor(length(a[,1])*0.01)           
  j=ceiling(length(a[,1])*0.99)         
  a.sort=apply(a,2,sort)                
  a.trim=a.sort[i:j,]                  
  a.mean=apply(a.trim,2,mean)        
  a.se=apply(a.trim,2,sd)/sqrt(length(a.trim[,1]))  
  a.d=data.frame(x=seq(1,100,1),mean=a.mean,se=a.se)   
}



setwd("PATH")

SS<-function(x,y){
  n5<-read.table(x)
  n5<-metaplot(n5)
  n5$type="5'SS"

  n3<-read.table(y)
  n3<-metaplot(n3)
  n3$type="3'SS"

  n53<-rbind(n5,n3)

  n53$type<-factor(n53$type,levels=unique(n53$type))
  p<-ggplot(n53,aes(x,mean))+
    geom_linerange(aes(x,ymin=mean-se,ymax=mean+se),colour="grey")+
    geom_bar(stat = "identity",fill="blue",width=1)+ylim(c(0,max(n53$mean)+0.03))+
    geom_hline(yintercept=0,colour="grey",linetype="dashed")+
    geom_vline(xintercept = 50,colour="grey",linetype="dashed")+
    labs(y = "Reads density")+guides(size=guide_legend())+
    theme(panel.grid.minor=element_blank(),panel.background=element_blank(), panel.border=element_rect(fill=NA))+
    facet_grid(~type)
  return(p)
}




pnet<-SS("pNET_pure.5SS.matrix.txt","pNET_pure.3SS.matrix.txt")
gro<-SS("GRO_pure.5SS.matrix.txt","GRO_pure.3SS.matrix.txt")
CB3<-SS("3CB.5SS.matrix.txt","3CB.3SS.matrix.txt")
chrn<-SS("chrNET.5SS.matrix.txt","chrNET.3SS.matrix.txt")
cruN<-SS("pNET_crude.5SS.matrix.txt","pNET_crude.3SS.matrix.txt")
cruG<-SS("GRO_crude.5SS.matrix.txt","GRO_crude.3SS.matrix.txt")
pp<-plot_grid(pnet,gro,CB3,chrn,cruN,cruG,ncol=2,byrow=F)
save_plot("EI_IE.pdf",pp)
