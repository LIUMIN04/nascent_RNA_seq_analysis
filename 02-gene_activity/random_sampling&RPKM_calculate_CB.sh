#bam文件按名称排列测序深度与活跃基因
samtools view -H CB-C.combined.bam > CB-C.combined.bam.head
samtools view -@16 -f 0x40 CB-C.combined.byname.bam > CB-C.combined.byname.R1.sam
samtools view -@16 -f 0x80 CB-C.combined.byname.bam > CB-C.combined.byname.R2.sam

get_seeded_random()
{
  seed="$1"
  openssl enc -aes-256-ctr -pass pass:"$seed" -nosalt \
    </dev/zero 2>/dev/null
}
for i in {1..100}
   do
   shuf -n $2 --random-source=<(get_seeded_random $i) $1.byname.R1.sam > ./temp/$1.byname.${2/000000/}M.R1.sam$i
   shuf -n $2 --random-source=<(get_seeded_random $i) $1.byname.R2.sam > ./temp/$1.byname.${2/000000/}M.R2.sam$i
   cat $1.bam.head ./temp/$1.byname.${2/000000/}M.R1.sam$i ./temp/$1.byname.${2/000000/}M.R2.sam$i | samtools view -@16 -bh | samtools sort -@16 > ./temp/$1.${2/000000/}M.bam$i
   rm ./temp/$1.byname.${2/000000/}M.R1.sam$i ./temp/$1.byname.${2/000000/}M.R2.sam$i
   done
/software/subread-1.6.5-Linux-x86_64/bin/featureCounts -T 16 -t exon -g gene_id -p -s 2 -a ../../annotation/Araport11_GFF3_genes_transposons.201606.gtf -o ./random_count/$1.${2/000000/}M.count ./temp/*bam*
rm ./temp/*
