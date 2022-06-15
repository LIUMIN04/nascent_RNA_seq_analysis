
#proximal promoter
awk '{if($6=="+"){print $1,$2-100,$2+200,$4,$5,$6}else{print $1,$3-200,$3+100,$4,$5,$6}}' OFS="\t" protein.bed > protein.promoter.300.bed
./promoter_proximal_50bin.sh protein.promoter.300

for i in 3CB-*;do coverageBed -a protein.promoter.300.shift5.50win.51.bed -b $i -s > ../pause_index/${i/bed/}pp.count;done
for i in GRO-*;do coverageBed -a protein.promoter.300.shift5.50win.51.bed -b $i -s > ../pause_index/${i/bed/}pp.count;done
for i in pNET-*;do coverageBed -a protein.promoter.300.shift5.50win.51.bed -b $i -s > ../pause_index/${i/bed/}pp.count;done

#gene body
awk '{if($6=="+"){print $1,$2+200,$3-100,$4,$5,$6}else{print $1,$2+100,$3-200,$4,$5,$6}}' OFS="\t" protein.bed > gene_body.bed
for i in 3CB-*;do coverageBed -a gene_body.bed -b $i -s > ../pause_index/${i/bed/}gb.count;done
for i in GRO-*;do coverageBed -a gene_body.bed -b $i -s > ../pause_index/${i/bed/}gb.count;done
for i in pNET-*;do coverageBed -a gene_body.bed -b $i -s > ../pause_index/${i/bed/}gb.count;done

