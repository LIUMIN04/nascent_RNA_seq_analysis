#pausing fisher's exact test
files<-list.files(pattern="PP_GB.READS.csv")
i=1
while(i<=length(files)){
  data<-read.csv(files[i],head=T)  
  data<-mutate(data,pp.u=round((pp.reads+gb.reads)*pp.length/(pp.length+gb.length)),
               gb.u=round((pp.reads+gb.reads)*gb.length/(pp.length+gb.length)))
  data<-select(data,gene,pp.reads,gb.reads,pp.u,gb.u)
  
  a<-1
  b<-length(data[,1])
  
  while(a<=b){
    x<-c(data[a,2],data[a,3],data[a,4],data[a,5])
    dim(x)<-c(2,2)
    data$pvalue[a]<-fisher.test(x)$p.value
    a=a+1
    }
  
  data$qvalue<-p.adjust(data$pvalue,method="BH",n=b)
  f.name<-gsub("csv","test.csv",files[i])
  
  write.csv(data,f.name,row.names = F)
  
  i=i+1
}
