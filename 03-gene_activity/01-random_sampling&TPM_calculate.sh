#for pNET, GRO and 3'CB

mkdir temp

for j in {1000000,2000000,3000000,5000000,7000000,9000000,12000000,15000000,20000000}
 do
  for i in {1..100}
   do
    shuf -n $j ${sample}.bed > ./temp/${sample}.$i.bed
   done

  for i in ./temp/*bed
   do
     coverageBed -a ${PATH}/coding_transcript.genebody.bed -b $i -s > ${sample}.gb.count
   done

  for i in ./temp/*count
  do
   awk '{print $4,$7*1000/$9}' $i > ${sample}.RPK.txt
   s=`awk 'BEGIN{sum=0}{sum=sum+$2}END{print sum}' ${sample}.RPK.txt`
   awk '{print $1,$2*1000000/"'$s'"}' OFS="\t" ${sample}.RPK.txt > ${sample}.TPM.txt
  done

 for i in ./temp/*TPM.txt
  do
   cut -f 2 $i > ${i/txt/}value
  done

paste ./temp/*value > ${1/bed/}${j/000000/}M.txt

rm -f ./temp/*
done

rm -rf temp


