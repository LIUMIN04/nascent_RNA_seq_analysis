#require homerTools, BBMAP, cutadapt, STAR, bedtools

#for pNET,3'CB and GRO
#1.trim 70bp of 3'end
homerTools trim -3 70 $1.R1.fastq.gz
homerTools trim -3 70 $1.R2.fastq.gz
mv $1.R1.fastq.gz.trimmed $1.R1.trim.fq
mv $1.R2.fastq.gz.trimmed $1.R2.trim.fq

#2.remove PCR duplication
clumpify.sh in=$1.R1.trim.fq in2=$1.R2.trim.fq out=$1.R1.rmdup.fq out2=$1.R2.rmdup.fq dedupe addcount subs=0
cutadapt -j 8 -a TGGAATTCTCGGGTG -A GATCGTCGGACTGTA -z -O 5 -e 0.1 -m 20 -q 20 -o $1.clean.R1.fq.gz -p $1.clean.R2.fq.gz $1.R1.rmdup.fq $1.R2.rmdup.fq

#3. filtering sequences mapping to rRNA

STAR --genomeDir  /public/genome/arabidopsis/tair10/STAR-rRNA/ --readFilesCommand zcat --readFilesIn $1.clean.R1.fq.gz $1.clean.R2.fq.gz --runThreadN 16 --clip3pNbases 4 --clip5pNbases 4 --outFileNamePrefix ./$1.rRNA --outReadsUnmapped Fastx
mv $1.rRNAUnmapped.out.mate1 $1.rRNA.R1.fq
mv $1.rRNAUnmapped.out.mate2 $1.rRNA.R2.fq

#4. mapping to genome
STAR --genomeDir /public/genome/arabidopsis/tair10/star-index/ --runThreadN 8 --clip3pNbases 4 --clip5pNbases 4 --readFilesIn $1.rRNA.R1.fq $1.rRNA.R2.fq --outFileNamePrefix ./$1. --outSAMtype BAM Unsorted --outFilterMismatchNmax 2 --outFilterMultimapNmax 1

#5. 
samtools sort -@  16 -n $1.bam > $1.sortbyname.bam
bamToBed -i $1.sortbyname.bam -bedpe -mate1 > $1.sortbyname.bedpe

#for pNET and 3'CB
awk '{if($9=="+"){print $1,$6-1,$6,"onebase",1,"+"}else{print $1,$5,$5+1,"onebase",1,"-"}}' OFS="\t" $1.sortbyname.bedpe | sort -k1,1 -k2,2n > $1.onebase.bed

#for GRO
awk '{if($9=="+"){print $1,$2,$2+1,"onebase",1,"+"}else{print $1,$3-1,$3,"onebase",1,"-"}}' OFS="\t" $1.sortbyname.bedpe | sort -k1,1 -k2,2n > $1.onebase.bed

#filtering reads mapped on snoRNA, snRNA, tRNA
subtractBed -a $1.onebase.bed -b  ~/genome/araport11/araport.ncRNA100.nuclear.bed -s | grep -v Chr[CM] > $1.final.bed


#for CB
#1.
cutadapt -j 8 -a TGGAATTCTCGGGTG -A GATCGTCGGACTGTA -z -O 5 -e 0.1 -m 20 -q 20 -o $1.clean.R1.fq.gz -p $1.clean.R2.fq.gz $1.R1.fastq.gz $1.R2.fastq.gz

#2. filtering sequences mapping to rRNA
STAR --genomeDir  /public/genome/arabidopsis/tair10/STAR-rRNA/ --readFilesCommand zcat --readFilesIn $1.clean.R1.fq.gz $1.clean.R2.fq.gz --runThreadN 16 --clip3pNbases 4 --clip5pNbases 4 --outFileNamePrefix ./$1.rRNA --outReadsUnmapped Fastx
mv $1.rRNAUnmapped.out.mate1 $1.rRNA.R1.fq
mv $1.rRNAUnmapped.out.mate2 $1.rRNA.R2.fq

#3. mapping to genome
STAR --genomeDir /public/genome/arabidopsis/tair10/star-index/ --runThreadN 8 --clip3pNbases 4 --clip5pNbases 4 --readFilesIn $1.rRNA.R1.fq $1.rRNA.R2.fq --outFileNamePrefix ./$1. --outSAMtype BAM Unsorted --outFilterMismatchNmax 2 --outFilterMultimapNmax 1




#for Nuc and total
#1.
cutadapt -j 8 -a TGGAATTCTCGGGTG -A GATCGTCGGACTGTA -z -O 5 -e 0.1 -m 20 -q 20 -o $1.clean.R1.fq.gz -p $1.clean.R2.fq.gz $1.R1.fastq.gz $1.R2.fastq.gz

#2. mapping to genome
STAR --genomeDir /public/genome/arabidopsis/tair10/star-index/ --runThreadN 8 --clip3pNbases 4 --clip5pNbases 4 --readFilesIn $1.clean.R1.fq $1.clean.R2.fq --outFileNamePrefix ./$1. --outSAMtype BAM Unsorted --outFilterMismatchNmax 2 --outFilterMultimapNmax 1

