#!/bin/sh

# get OS distribution for installer
OSdistribution=$(cat /etc/*release | grep '^NAME=' | sed -e 's/NAME=//g' | sed -e 's/"//g' )
# remove white spaces
OSdistribution=${OSdistribution// /}


# --------------------------------------------------------------------
# ----- Linux packages (prereq-s) to download & install --------------
# --------------------------------------------------------------------


# installer depends on OS distibution
if [[ "$OSdistribution" == 'CentOSLinux' ]]
then
	# Basic packages to install
	yum -y groupinstall 'Development Tools'
	yum -y install cvs

	# Packages for HunMorph tool
	yum -y install ocaml
	yum -y install texinfo
	yum -y install ocaml-findlib
	yum -y install texlive

	# Packages for HunPos
	yum -y install glibc.i686
	
	# Python setuptools package for NLTK usage
	yum -y install python-setuptools
	yum -y easy_install pip
	yum -y pip install -U nltk

elif [[ "$OSdistribution" == 'Ubuntu' ]]
then
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
	apt-get --assume-yes install ia32-libs
	#dpkg-reconfigure dash
	
	# Python setuptools package for NLTK usage
	apt-get --assume-yes install python-setuptools
	apt-get --assume-yes easy_install pip
	apt-get --assume-yes pip install -U nltk

elif [[ "$OSdistribution" == 'Debian' ]]
then
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
	apt-get --assume-yes install ia32-libs
	
	# Python setuptools package for NLTK usage
	apt-get --assume-yes install python-setuptools
	apt-get --assume-yes easy_install pip
	apt-get --assume-yes pip install -U nltk

elif [[ "$OSdistribution" == 'RedHat' ]]
then
	# Basic packages to install
	yum -y groupinstall 'Development Tools'
	yum -y install cvs

	# Packages for HunMorph tool
	yum -y install ocaml
	yum -y install texinfo
	yum -y install ocaml-findlib
	yum -y install texlive

	# Packages for HunPos
	yum -y install glibc.i686
	
	# Python setuptools package for NLTK usage
	yum -y install python-setuptools
	yum -y easy_install pip
	yum -y pip install -U nltk

elif [[ "$OSdistribution" == 'NovellSUSE' ]]
then
	echo "NovellSUSE"

else
	echo "OS distribution is not supported."
fi




# -----------------------------------------------
# ----- Downloading and installing tools --------
# -----------------------------------------------

# Creating basic directory 
cd $HOME
mkdir NLPtools
cd NLPtools

# Install Hunmorph
cd $HOME/NLPtools
mkdir HunMorph
cd HunMorph
#cvs -d :pserver:anonymous:anonymous@cvs.mokk.bme.hu:/local/cvs co ocamorph
#wget ftp://ftp.mokk.bme.hu/Tool/Hunmorph/Resources/Morphdb.hu/morphdb-hu-20060525.tgz
wget https://www.dropbox.com/s/92kn9ml5f8682ld/morphdb.hu.tar.gz
wget https://www.dropbox.com/s/128zur1gz9s6vfi/ocamorph.tar.gz
tar -xvzf morphdb.hu.tar.gz
tar -xvzf ocamorph.tar.gz
rm morphdb.hu.tar.gz
rm ocamorph.tar.gz
#tar -xvzf morphdb-hu-20060525.tgz
#rm morphdb-hu-20060525.tgz
cd ocamorph
make clean
make
make install
echo " " >> ~/.bashrc
echo "# Ocamorph for HunMorph NLP tool" >> ~/.bashrc
echo "PATH=${PATH}:$HOME/NLPtools/HunMorph/ocamorph/adm" >> ~/.bashrc


# Install Huntoken
cd $HOME/NLPtools
mkdir HunToken
cd HunToken
wget https://www.dropbox.com/s/ay97uxk98oaihtj/huntoken-1.6.tar.gz
tar -xvzf huntoken-1.6.tar.gz
rm huntoken-1.6.tar.gz
cd huntoken-1.6
make
make install


# Install SzegedNER
cd $HOME/NLPtools
mkdir SzegedNER
cd SzegedNER
wget http://rgai.inf.u-szeged.hu/project/nlp/research/NER/ner.jar


# Install HunPos
cd $HOME/NLPtools
mkdir hunpos
cd hunpos
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/hunpos/hu_szeged_kr.model.gz
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/hunpos/hunpos-1.0-linux.tgz
# if ágba hogy windows, osx, vagy linux mert a letöltésnél fontos
tar -xvzf hunpos-1.0-linux.tgz
rm hunpos-1.0-linux.tgz
gzip -d hu_szeged_kr.model.gz


# Install typoing for Hungarian language
cd $HOME/NLPtools
mkdir typo
cd typo
wget https://www.dropbox.com/s/1md8b94t04fuo9l/ekezo.tar.gz
wget https://www.dropbox.com/s/zaqodnisnx31uxm/p2iso.tar.gz
tar -xvzf ekezo.tar.gz
tar -xvzf p2iso.tar.gz
rm ekezo.tar.gz
rm p2iso.tar.gz


# Download project files from GitHub
cd $HOME/NLPtools
wget https://github.com/dhuszti/SentAnalysisHUN/archive/master.zip
unzip master.zip
rm master.zip


# Set permissions to access files not only as root privilege user
chmod -R +r $HOME/NLPtools


# -----------------------------------------------
# -------------- Test NLP tools  ----------------
# -----------------------------------------------

# Test NLP tools, whether there was any installation error
cd $HOME/NLPtools
echo "Teszteljük a következő nyelvi eszközöket, Kiss Géza." >> test.txt 
# HunMorph test
echo "ablakot" | ocamorph --aff $HOME/NLPtools/HunMorph/morphdb.hu/morphdb_hu.aff --dic $HOME/NLPtools/HunMorph/morphdb.hu/morphdb_hu.dic
# HunToken test
cat $HOME/test.txt | huntoken > $HOME/test_huntoken.xml
cat test_huntoken.xml
# HunPos test
echo "ablakot" | $HOME/NLPtools/hunpos/hunpos-1.0-linux/hunpos-tag  $HOME/NLPtools/hunpos/hu_szeged_kr.model
# Typoing test
echo "teszteles" | $HOME/NLPtools/typo/ekezo/ekito.run | $HOME/NLPtools/typo/p2iso
# SzegedNER test
java -Xmx3G -jar $HOME/SzegedNER/ner.jar -mode predicate -input $HOME/test.txt -output $HOME/SzegedNER_Test.txt
rm test.txt
rm test_huntoken.xml
