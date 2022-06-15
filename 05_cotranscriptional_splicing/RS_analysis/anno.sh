awk '$6=="+"' $1 > $1.plus.bed
awk '$6=="-"' $1 > $1.minus.bed
awk '{if($2==$10 && $3==$11){$15="eq";print $0}
          else if($2<$10 && $3>$11){$15="contain";print $0}
          else if($2>$10 && $3<$11){$15="partial";print $0}
          else if($2<$10 && $3<$11){$15="left_over";print $0}
          else if($2>$10 && $3>$11){$15="right_over";print $0}
          else if($2==$10 && $3<$11){$15="A3SS_small";print $0}
          else if($2==$10 && $3>$11){$15="A3SS_large";print $0}
          else if($3==$11 && $2>$10){$15="A5SS_small";print $0}
          else if($3==$11 $$ $2<$10){$15="A5SS_large";print $0}
          }' OFS="\t" $1.plus.bed > $1.plus.anno


awk '{if($2==$10 && $3==$11){$15="eq";print $0}
          else if($2<$10 && $3>$11){$15="contain";print $0}
          else if($2>$10 && $3<$11){$15="partial";print $0}
          else if($2<$10 && $3<$11){$15="right_over";print $0}
          else if($2>$10 && $3>$11){$15="left_over";print $0}
          else if($2==$10 && $3<$11){$15="A5SS_small";print $0}
          else if($2==$10 && $3>$11){$15="A5SS_large";print $0}
          else if($3==$11 && $2>$10){$15="A3SS_small";print $0}
          else if($3==$11 $$ $2<$10){$15="A3SS_large";print $0}
          i}' OFS="\t" $1.minus.bed > $1.minus.anno
