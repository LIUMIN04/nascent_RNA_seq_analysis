for i in *bed;
   do coverageBed -a /home/liumin/genome/tair10/metaplot/gene1kb.TSS.200bin.bed -b $i -s > ${i/bed/}TSS.count
      coverageBed -a /home/liumin/genome/tair10/metaplot/gene1kb.PAS.200bin.bed -b $i -s > ${i/bed/}PAS.count
      a=`wc -l $i | cut -f 1 -d " " `
      awk 'BEGIN{s=1000000000/'"$a"'}{print $4,$5,$7*s/$9}' OFS="\t" ${i/bed/}TSS.count | sort -k1,1 -k2,2n > ${i/bed/}TSS.norm.txt
      awk 'BEGIN{s=1000000000/'"$a"'}{print $4,$5,$7*s/$9}' OFS="\t" ${i/bed/}PAS.count | sort -k1,1 -k2,2n > ${i/bed/}PAS.norm.txt
    done

Rscript toMatrix.r
