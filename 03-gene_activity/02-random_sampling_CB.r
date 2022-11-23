
A=list.files(pattern="count.txt")
#TPM
i=1
df=list() #creat a list to save SD of gene activity
No=matrix(NA,ncol=9,nrow=100) #creat a data frame to save mean and SD value of active gene number
while(i<=length(A)){
data=read.table(A[i],head=T)
count<-data[,7:106]
rpk<-count/data$Length
tpm<-t(t(rpk)/colSums(rpk) * 1000000)

j=1
while(j<=100){
  No[j,i]=length(tpm[,j][which(tpm[,j]>2)]) #count number of active genes
  j=j+1}
tpm=tpm[which(rowMeans(tpm)>2),]  #select active genes by calculate mean values of 100 replicates
#gene activity in each replicate is normalized to the maxmum value
d.max=apply(tpm,1,max)
tpm=tpm/(d.max)
#calculate SD for 100 replicates after normalize to the max value
d.sd=apply(tpm,1,sd)
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
bp2=ggplot(No,aes(lib.s,Num))+geom_boxplot()+xlab("")+ylab("Number of active gene number")
pp=plot_grid(bp2, bp1)
save_plot("CB.randome.pdf", pp)



