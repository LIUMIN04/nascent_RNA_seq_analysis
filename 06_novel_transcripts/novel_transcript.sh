#homertools
makeTagDirectory ./novel_transcript/pNET pNET.bed -format bed -force5th
findPeaks ./new_transcript/pNET -style groseq -o pNET.txt -tssFold 5 -bodyFold 2 -minBodySize 500
grep -v "#" pNET.txt | awk '{print $2,$3,$4,$1,1,$5}' OFS="\t" > pNET.homer.bed
mergeBed -i pNET.homer.bed -s -c 5,6 -d 100 -o first,first | awk '{print $1,$2,$3,$1"_"$2"_"$3,$4,$5}' OFS="\t"  > pNET.homer.merge.bed

#stringtie
stringtie pNET.bam -G ../annotation/Araport11_GFF3_genes_transposons.201606.gff --rf -o ./pNET_stringtie/pNET_stringtie.gtf -p 16 -A pNET-gene.tab -B

awk '$3=="transcript"' pNET_stringtie.gtf | awk '{print $1,$4-1,$5,$7}' OFS="\t" | awk '{print $1,$2,$3,$1"_"$2"_"$3,1,$4}' OFS="\t" | awk '!a[$0]++' > pNET_stringtie.bed
sort -k1,1 -k2,2n pNET_stringtie.bed > pNET_stringtie.sort.bed
mergeBed -i pNET_stringtie.sort.bed -s -c 4,5,6 -o first,first,first > pNET_stringtie.merge.bed


#merge transcripts detected by homerTools and stringtie
cat pNET.homer.strand.bed pNET_stringtie.merge.bed | sort -k1,1 -k2,2n | mergeBed -i - -s -d 50 -c 4,5,6 -o first,first,first > pNET.homer.stringtie.merge.bed


#compared with annotation
intersectBed -a pNET.homer.stringtie.merge.bed -b ../araport11_annotation/NUCLERA.gff -wao -s > pNET.annotation.txt 
awk '$7=="."' pNET.annotation.txt | cut -f 1-6 > pNET.novel.transctipt.bed


#novel transcripts of GRO, 3'CB and CB are detected as described above.

#merge novel transcripts detected by different methods
cat 3NT.novel.transctipt.bed CB.novel.transctipt.bed GRO.novel.transctipt.bed pNET.novel.transctipt.bed | sort -k1,1 -k2,2n | clusterBed -i - -s | awk '{print $1,$2,$3,$4,$5,$6,"cluster"$7}' OFS="\t" > novel.transcript.cluster.bed
sort -k1,1 -k2,2n novel.transcript.cluster.bed | mergeBed -i - -s -c 5,6 -o first,first | awk '{print $1,$2,$3,$1"_"$2"_"$3,$4,$5}' OFS="\t" > novel.transcript.merge.bed
awk '{print $1,"novel","transcript",$2+1,$3,".",$6,".","gene_id "$4"\""}' OFS="\t" novel.transcript.merge.bed > novel.transcript.merge.gtf

#calculate the read count of novel transcript for CB, Nuc and total by featureCounts 
/software/subread-1.6.5-Linux-x86_64/bin/featureCounts -T 16 -t transcript -g gene_id -p -s 2 -a novel.transcript.merge.gtf -o CB_Nuc_total.novel.count ../bam_files/CB.sorted.bam ../bam_files/Nuc.sorted.bam ../bam_files/total.sorted.bam

#calculate the read count of novel transcripts for pNET, GRO and 3'CB
coverageBed -a novel.transcript.merge.bed -b pNET.bed -s > pNET.novel.count
coverageBed -a novel.transcript.merge.bed -b GRO.bed -s > GRO.novel.count
coverageBed -a novel.transcript.merge.bed -b 3CB.bed -s > 3CB.novel.count


