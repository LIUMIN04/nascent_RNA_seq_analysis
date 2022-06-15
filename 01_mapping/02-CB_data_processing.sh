#1.
cutadapt -j 8 -a TGGAATTCTCGGGTG -A GATCGTCGGACTGTA -z -O 5 -e 0.1 -m 20 -q 20 -o $1.clean.R1.fq.gz -p $1.clean.R2.fq.gz $1.R1.fastq.gz $1.R2.fastq.gz

#2. filtering sequences mapping to rRNA
STAR --genomeDir  /public/genome/arabidopsis/tair10/STAR-rRNA/ --readFilesCommand zcat --readFilesIn $1.clean.R1.fq.gz $1.clean.R2.fq.gz --runThreadN 16 --clip3pNbases 4 --clip5pNbases 4 --outFileNamePrefix ./$1.rRNA --outReadsUnmapped Fastx
mv $1.rRNAUnmapped.out.mate1 $1.rRNA.R1.fq
mv $1.rRNAUnmapped.out.mate2 $1.rRNA.R2.fq

#3. mapping to genome
STAR --genomeDir /public/genome/arabidopsis/tair10/star-index/ --runThreadN 8 --clip3pNbases 4 --clip5pNbases 4 --readFilesIn $1.rRNA.R1.fq $1.rRNA.R2.fq --outFileNamePrefix ./$1. --outSAMtype BAM Unsorted --outFilterMismatchNmax 2 --outFilterMultimapNmax 1
