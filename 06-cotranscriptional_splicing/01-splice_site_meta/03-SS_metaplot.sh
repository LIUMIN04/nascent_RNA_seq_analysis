for i in *bed;
   do coverageBed -a ~/PATH/EI100.bin.bed -b $i -s > ${i/bed/}5SS.count
      coverageBed -a ~/PATH/IE100.bin.bed -b $i -s > ${i/bed/}3SS.count
      a=`wc -l $i | cut -f 1 -d " " `
      awk 'BEGIN{s=1000000000/'"$a"'}{print $4,$5,$7*s/$9}' OFS="\t" ${i/bed/}5SS.count | sort -k1,1 -k2,2n > ${i/bed/}5SS.norm.txt
      awk 'BEGIN{s=1000000000/'"$a"'}{print $4,$5,$7*s/$9}' OFS="\t" ${i/bed/}3SS.count | sort -k1,1 -k2,2n > ${i/bed/}3SS.norm.txt
    done

Rscript SS_toMatrix.r
