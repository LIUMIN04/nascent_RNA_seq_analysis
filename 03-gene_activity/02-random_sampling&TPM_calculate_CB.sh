# FOR CB
#prepare files for random sampling as follows
samtools view -H CB.bam > CB.bam.head
samtools sort -@16 -n CB.bam > CB.byname.bam
samtools view -@16 -f 0x40 CB.byname.bam > CB.byname.R1.sam
samtools view -@16 -f 0x80 CB.byname.bam > CB.byname.R2.sam

#For example, if we want to random sampling 1M reads for 100 times, then run: ./random_sampling&TPM_calculate_CB.sh 1000000

mkdir temp

get_seeded_random()
{
  seed="$1"
  openssl enc -aes-256-ctr -pass pass:"$seed" -nosalt \
    </dev/zero 2>/dev/null
}
for i in {1..100}
   do
   shuf -n $1 --random-source=<(get_seeded_random $i) CB.byname.R1.sam > ./temp/CB.byname.${1/000000/}M.R1.sam$i
   shuf -n $1 --random-source=<(get_seeded_random $i) CB.byname.R2.sam > ./temp/CB.byname.${1/000000/}M.R2.sam$i
   cat CB.bam.head ./temp/CB.byname.${1/000000/}M.R1.sam$i ./temp/CB.byname.${1/000000/}M.R2.sam$i | samtools view -@16 -bh | samtools sort -@16 > ./temp/CB.${1/000000/}M.bam$i
   rm ./temp/$1.byname.${1/000000/}M.R1.sam$i ./temp/$1.byname.${1/000000/}M.R2.sam$i
   done
/software/subread-1.6.5-Linux-x86_64/bin/featureCounts -T 16 -t exon -g gene_id -p -s 2 -a coding_transcript.genebody.gtf -o CB.${1/000000/}M.count ./temp/*bam*
rm ./temp/*




