#! /bin/bash
set -e
# Created by David Pereira
# inexhero@gmail.com

tput setaf 2; echo 'Welcome to Jasper Easy Install'

sudo mkdir -p /opt/jasper

cd /opt/jasper

if [ ! -f get-pip.py ]; then
    wget https://bootstrap.pypa.io/get-pip.py
fi
sudo python get-pip.py
wget -q -O - http://apt.mopidy.com/mopidy.gpg | sudo apt-key add -
sudo wget -q -O /etc/apt/sources.list.d/mopidy.list http://apt.mopidy.com/mopidy.list
sudo apt-get update
sudo apt-get upgrade --yes
sudo apt-get install aptitude git subversion autoconf libtool automake gfortran g++ vim espeak festival festvox-don flite libttspico-utils python-pymad python-dev bison libasound2-dev python-pyaudio build-essential zlib1g-dev flex libesd0-dev libsndfile1-dev libfst-tools --yes

tput setaf 2; echo 'Dependencies installed successfully!'

sudo pip install --upgrade setuptools

if [ ! -d /opt/jasper/jasper ]; then
   git clone https://github.com/jasperproject/jasper-client.git /opt/jasper/jasper
   sudo pip install -r jasper/client/requirements.txt
   chmod +x /opt/jasper/jasper/jasper.py
fi

tput setaf 2; echo 'Jasper client installed successfully!'

if [ ! -f sphinxbase-0.8.tar.gz ]; then
wget http://downloads.sourceforge.net/project/cmusphinx/sphinxbase/0.8/sphinxbase-0.8.tar.gz
fi
tar -zxvf sphinxbase-0.8.tar.gz
cd sphinxbase-0.8
./configure --enable-fixed
make -j2 #(2 core)
sudo make install -j2
cd ../

tput setaf 2; echo 'sphinx base installed successfully!'

if [ ! -f pocketsphinx-0.8.tar.gz ]; then
wget http://downloads.sourceforge.net/project/cmusphinx/pocketsphinx/0.8/pocketsphinx-0.8.tar.gz
fi
tar -zxvf pocketsphinx-0.8.tar.gz
cd pocketsphinx-0.8
./configure
make -j2 #(2 core)
sudo make install -j2
cd ../

tput setaf 2; echo 'pocketsphinx installed successfully!'

svn co https://svn.code.sf.net/p/cmusphinx/code/trunk/cmuclmtk/
cd cmuclmtk/
sudo ./autogen.sh && sudo make -j2 && sudo make install -j2
cd ../

tput setaf 2; echo 'Pocketsphinx installed successfully!'

#! /bin/bash
if [ ! -f openfst-1.4.1.tar.gz ]; then
wget http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.4.1.tar.gz
fi
if [ ! -f mitlm_0.4.1.orig.tar.gz ]; then
wget https://launchpad.net/debian/+archive/primary/+files/mitlm_0.4.1.orig.tar.gz
fi
if [ ! -f m2m-aligner-1.2.tar.gz ]; then
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/m2m-aligner/m2m-aligner-1.2.tar.gz
fi
if [ ! -f phonetisaurus_0.7.8.orig.tar.gz ]; then
wget https://launchpad.net/debian/+archive/primary/+files/phonetisaurus_0.7.8.orig.tar.gz
fi
if [ ! -f g014b2b.tgz ]; then
wget https://www.dropbox.com/s/kfht75czdwucni1/g014b2b.tgz
fi
if [ ! -f julius-4.3.1.tar.gz ]; then
wget --trust-server-names 'http://osdn.jp/frs/redir.php?m=iij&f=%2Fjulius%2F60273%2Fjulius-4.3.1.tar.gz'
fi

tput setaf 2; echo 'Openfst - mitlm - m2m-aligner - phonetisaurus - downloaded successfully!'

tar -xvf m2m-aligner-1.2.tar.gz
tar -xvf openfst-1.4.1.tar.gz
tar -xvf phonetisaurus_0.7.8.orig.tar.gz
tar -xvf mitlm_0.4.1.orig.tar.gz
tar -xvf g014b2b.tgz

cd openfst-1.4.1/
sudo ./configure --enable-compact-fsts --enable-const-fsts --enable-far --enable-lookahead-fsts --enable-pdt
sudo make install -j2 # come back after a really long time
cd ../

tput setaf 2; echo 'openfst-1.4.1 installed successfully!'

cd m2m-aligner-1.2/
sudo make -j2 
cd ../

tput setaf 2; echo 'm2m-aligner-1.2 installed successfully!'

cd mitlm-0.4.1/
sudo ./configure
sudo make install -j2 
cd ../

tput setaf 2; echo 'mitlm-0.4.1 installed successfully!'

cd phonetisaurus-0.7.8/
cd src
sudo make -j2 
cd ../../

tput setaf 2; echo 'phonetisaurus-0.7.8 installed successfully!'

sudo cp m2m-aligner-1.2/m2m-aligner /usr/local/bin/m2m-aligner

tput setaf 2; echo 'm2m-aligner-1.2 installed successfully!'

sudo cp phonetisaurus-0.7.8/phonetisaurus-g2p /usr/local/bin/phonetisaurus-g2p

tput setaf 2; echo 'phonetisaurus-0.7.8 configured successfully!'


if [ ! -f ~/.bash_profile ]; then
touch ~/.bash_profile
fi

sudo sh -c "if ! grep -q 'export LD_LIBRARY_PATH=/usr/local/lib/' ~/.bash_profile; then 
echo 'export LD_LIBRARY_PATH=/usr/local/lib/
source ~/.bashrc' >> ~/.bash_profile; fi"

sudo sh -c "if ! grep -q 'LD_LIBRARY_PATH=/usr/local/lib/' ~/.bashrc; then 
echo 'LD_LIBRARY_PATH=/usr/local/lib/
export LD_LIBRARY_PATH
PATH=$PATH:/usr/local/lib/
export PATH' >> ~/.bashrc; fi"

source ~/.bashrc
source ~/.bash_profile

sudo apt-get update
sudo apt-get dist-upgrade

cd g014b2b/
sudo ./compile-fst.sh
cd ../

tput setaf 2; echo 'g014b2b compiled successfully!'

if [ ! -d /opt/jasper/phonetisaurus ]; then
mv /opt/jasper/g014b2b /opt/jasper/phonetisaurus
fi

tput setaf 2; echo 'g014b2b configured successfully!'

tar -xvf julius-4.3.1.tar.gz

tput setaf 2; echo 'julius unzipped successfully!'

cd julius-4.3.1
sudo ./configure --enable-words-int
make -j2 
sudo make install -j2 
cd ../
tput setaf 2; echo 'julius installed successfully!'

sudo pip install --upgrade gTTS

cd jasper/client
sudo python populate.py
cd ../

sudo chmod -R 777 ~/.jasper 

sudo sh -c "if ! grep -q 'pico-tts' ~/.jasper/profile.yml; then echo 'tts_engine: pico-tts' >> ~/.jasper/profile.yml; fi"

tput setaf 2; echo 'Installation completed! Enjoy'

python /opt/jasper/jasper/jasper.py
