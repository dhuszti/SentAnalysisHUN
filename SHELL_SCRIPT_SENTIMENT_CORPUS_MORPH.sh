#!/bin/bash

# Hunpos
cat /home/hd/onlab2/sentiment_corpus/OpinHuBank_20130106.csv | cut -f2 -d$'\t' | sed 's/^"//' | sed 's/"$//'  | ./Downloads/huntoken-1.6/bin/huntoken | ./xmlparser.py | sed ':a;N;$!ba;s/\n\n/\n/g' | /home/hd/Desktop/hunpos-1.0-linux/hunpos-tag /usr/local/bin/hu_szeged_kr.model > hunpos_ki.txt

#cat /home/hd/onlab2/sentiment_corpus/OpinHuBank_20130106.csv | cut -f2 -d$'\t' | sed 's/^"//' | sed 's/"$//' | head -10 | ./Downloads/huntoken-1.6/bin/huntoken | ./xmlparser.py | sed ':a;N;$!ba;s/\n\n/\n/g' | /home/hd/Desktop/hunpos-1.0-linux/hunpos-tag /usr/local/bin/hu_szeged_kr.model > hunpos_ki.txt

# Hunmorph
cat /home/hd/onlab2/sentiment_corpus/OpinHuBank_20130106.csv| cut -f2 -d$'\t' | sed 's/^"//' | sed 's/"$//'  | ./Downloads/huntoken-1.6/bin/huntoken | ./xmlparser.py | sed ':a;N;$!ba;s/\n\n/\n/g' | ocamorph --bin morphdb_hu.bin > hunmorph_ki.txt

#cat /home/hd/onlab2/sentiment_corpus/OpinHuBank_20130106.csv| cut -f2 -d$'\t' | sed 's/^"//' | sed 's/"$//' | head -10 | ./Downloads/huntoken-1.6/bin/huntoken | ./xmlparser.py | sed ':a;N;$!ba;s/\n\n/\n/g' | ocamorph --aff Downloads/morphdb.hu/morphdb_hu.aff --dic Downloads/morphdb.hu/morphdb_hu.dic > hunmorph_ki.txt

# Unite Hunpos & Hunmorph
python /home/hd/morph_decision.py --posfile /home/hd/hunpos_ki.txt --morphfile /home/hd/hunmorph_ki.txt --ofile /home/hd/morph_ki.txt

# Delete files
rm hunpos_ki.txt
rm hunmorph_ki.txt
