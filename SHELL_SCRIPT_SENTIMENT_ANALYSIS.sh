#!/bin/bash

# Hunpos
cat SA_bemenet.txt | ./Downloads/huntoken-1.6/bin/huntoken | ./xmlparser.py | sed ':a;N;$!ba;s/\n\n/\n/g' | /home/hd/Desktop/hunpos-1.0-linux/hunpos-tag /usr/local/bin/hu_szeged_kr.model > hunpos_SA.txt

# Hunmorph
cat SA_bemenet.txt | ./Downloads/huntoken-1.6/bin/huntoken | ./xmlparser.py | sed ':a;N;$!ba;s/\n\n/\n/g' | ocamorph --bin morphdb_hu.bin > hunmorph_SA.txt

# Morph decision
python /home/hd/morph_decision.py --posfile /home/hd/hunpos_SA.txt --morphfile /home/hd/hunmorph_SA.txt --ofile /home/hd/morph_ki_SA.txt

rm hunpos_SA.txt
rm hunmorph_SA.txt

