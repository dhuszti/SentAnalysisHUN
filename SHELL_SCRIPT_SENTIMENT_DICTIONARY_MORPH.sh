#!/bin/bash
# Szótárra lefuttatva a morfológiai elemzés
 cat /home/hd/onlab2/sentiment_dictionaries/hu_neg_sentdict.txt | ocamorph --aff Downloads/morphdb.hu/morphdb_hu.aff --dic Downloads/morphdb.hu/morphdb_hu.dic | sed '/>/d' | sed '/UNKNOWN/d' | awk '!arr[$1]++' RS=" " | sed '/^$/d' | sort -u > /home/hd/onlab2/sentiment_dictionaries/hu_neg_morph.txt

 cat /home/hd/onlab2/sentiment_dictionaries/hu_pos_sentdict.txt | ocamorph --aff Downloads/morphdb.hu/morphdb_hu.aff --dic Downloads/morphdb.hu/morphdb_hu.dic | sed '/>/d' | sed '/UNKNOWN/d' | awk '!arr[$1]++' RS=" " | sed '/^$/d' | sort -u > /home/hd/onlab2/sentiment_dictionaries/hu_pos_morph.txt

 
 
