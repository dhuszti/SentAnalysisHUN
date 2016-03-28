#!/bin/sh

# You must run this shell script as a root privilege user with following command
# sudo ./install.sh

# Basic packages to install
apt-get update
apt-get --assume-yes install build-essential
apt-get --assume-yes install cvs

# Packages for HunMorph tool
apt-get --assume-yes install ocaml
apt-get --assume-yes install texinfo
apt-get --assume-yes install ocaml-findlib
apt-get --assume-yes install texlive

# Packages for SzegedNER
apt-get update
apt-get --assume-yesinstall default-jre
apt-get --assume-yesinstall default-jdk

# Packages for HunPos
apt-get --assume-yes install --reinstall libc6-i386
dpkg-reconfigure dash



# Creating basic directory 
cd home
mkdir NLPtools
cd NLPtools

# Install Hunmorph
mkdir HunMorph
cd HunMorph
cvs -d :pserver:anonymous:anonymous@cvs.mokk.bme.hu:/local/cvs co ocamorph
wget ftp://ftp.mokk.bme.hu/Tool/Hunmorph/Resources/Morphdb.hu/morphdb-hu-20060525.tgz
tar -xvzf morphdb-hu-20060525.tgz
rm morphdb-hu-20060525.tgz
cd ocamorph
make
echo " " >> ~/.bashrc
echo "# Ocamorph for HunMorph NLP tool" >> ~/.bashrc
echo "PATH=/home/osboxes/NLPtools/HunMorph/ocamorph/adm" >> ~/.bashrc
cd ..
cd ..

# Install Huntoken
mkdir HunToken
cd HunToken
wget https://www.dropbox.com/s/ay97uxk98oaihtj/huntoken-1.6.tar.gz
tar -xvzf huntoken-1.6.tar.gz
rm huntoken-1.6.tar.gz
cd huntoken-1.6
make
make install
cd ..
cd ..

# Install SzegedNER
mkdir SzegedNER
cd SzegedNER
wget http://rgai.inf.u-szeged.hu/project/nlp/research/NER/ner.jar
cd ..

# To test it use: java -Xmx3G -jar ner.jar -mode predicate -input input.txt -output output.txt

# Install HunPos
mkdir hunpos
cd hunpos
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/hunpos/hu_szeged_kr.model.gz
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/hunpos/hunpos-1.0-linux.tgz
// if ágba hogy windows, osx, vagy linux
tar -xvzf hunpos-1.0-linux.tgz
rm hunpos-1.0-linux.tgz
gzip -d hu_szeged_kr.model.gz
cd ..

# Install typoing for Hungarian language
mkdir typo
cd typo
wget https://www.dropbox.com/s/l8d50ksjk1rqvva/ekezo.tar.gz
wget https://www.dropbox.com/s/ayglzjnx5aeqxh8/p2iso
tar -xvzf ekezo.tar.gz
rm ekezo.tar.gz
cd ..

# Download project files from GitHub
wget https://github.com/dhuszti/SentAnalysisHUN/archive/master.zip
