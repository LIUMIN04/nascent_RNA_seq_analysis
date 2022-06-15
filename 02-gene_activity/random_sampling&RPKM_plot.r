files=list.files(pattern="3NT-C.rm5SS.araport11.combined")  #read files
df=list() #creat a list to save SD of gene activity
No=matrix(NA,ncol=9,nrow=100) #creat a data frame to save mean and SD value of active gene number
i=1
while(i<=9){
data=read.table(files[i])
j=1
while(j<=100){
  No[j,i]=length(data[,j][which(data[,j]>3)]) #count number of active genes, RPKM >3
  j=j+1}
data=data[which(rowMeans(data)>3),]  #select active genes by calculate mean values of 100 replicates
#gene activity in each replicate is normalized to the maxmum value
d.max=apply(data,1,max)
data=data/(d.max)
#calculate SD for 100 replicates after normalize to the max value
d.sd=apply(data,1,sd)
df[[i]]=d.sd
i=i+1
}

No1=data.frame(Num=No[,1],lib.s="01M");No2=data.frame(Num=No[,2],lib.s="02M");No3=data.frame(Num=No[,3],lib.s="03M");No4=data.frame(Num=No[,4],lib.s="05M");No5=data.frame(Num=No[,5],lib.s="07M");
No6=data.frame(Num=No[,6],lib.s="09M");No7=data.frame(Num=No[,7],lib.s="12M");No8=data.frame(Num=No[,8],lib.s="15M");No9=data.frame(Num=No[,9],lib.s="20M")
No=rbind(No1,No2,No3,No4,No5,No6,No7,No8,No9)

df1=data.frame(sd=df[[1]],lib.s="01M");df2=data.frame(sd=df[[2]],lib.s="02M");df3=data.frame(sd=df[[3]],lib.s="03M");df4=data.frame(sd=df[[4]],lib.s="05M");df5=data.frame(sd=df[[5]],lib.s="07M");
df6=data.frame(sd=df[[6]],lib.s="09M");df7=data.frame(sd=df[[7]],lib.s="12M");df8=data.frame(sd=df[[8]],lib.s="15M");df9=data.frame(sd=df[[9]],lib.s="20M")
df=rbind(df1,df2,df3,df4,df5,df6,df7,df8,df9)

require(cowplot)
require(ggplot2)
bp1=ggplot(df,aes(lib.s,sd))+geom_boxplot()+xlab("")+ylab("SD of gene activity")
bp2=ggplot(No,aes(lib.s,Num))+geom_boxplot()+xlab("")+ylab("SD of active gene number")
pp=plot_grid(bp1, bp2, labels = c("A", "B"))
save_plot("3NT-C.3M_20M.pdf", pp,
          ncol = 2, # we're saving a grid plot of 2 columns
          nrow = 1, # and 2 rows
          # each individual subplot should have an aspect ratio of 1.3
          base_aspect_ratio = 1.3
          )
