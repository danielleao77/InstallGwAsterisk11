#/bin/bash


clear


echo Instalando Epel Release
sleep 1
echo
yum install epel-release -y
clear
echo
echo
echo Atualizando...
sleep 1
echo
yum upgrade -y
clear

echo Instalando instalando pacotes
sleep 1
echo
yum install make svn openssl-devel ncurses-devel  newt-devel libxml2-devel kernel-devel gcc gcc-c++ sqlite-devel libuuid-devel mlocate vim htop wget net-tools arp-scan dstat -y && updatedb
clear

#echo Baixando o LIS da Microsoft
#cd /tmp/

#wget https://download.microsoft.com/download/6/8/F/68FE11B8-FAA4-4F8D-8C7D-74DA7F2CFC8C/lis-rpms-4.3.5.x86_64.tar.gz

#tar -xzvf lis-rpms-4.3.5.x86_64.tar.gz

#cd LISISO/

#echo Instalando o LIS da Microsoft
#./install.sh
#clear

cd
echo
echo
echo Instalando o SNGREP
touch /etc/yum.repos.d/irontec.repo

cat <<EOF > /etc/yum.repos.d/irontec.repo
[irontec]
name=Irontec RPMs repository
baseurl=http://packages.irontec.com/centos/\$releasever/\$basearch/
EOF

rpm --import http://packages.irontec.com/public.key

yum install sngrep -y
clear
echo
echo
echo Instalando o ASTERISK
cd /usr/local/src/

wget http://downloads.asterisk.org/pub/telephony/asterisk/old-releases/asterisk-11.25.3.tar.gz

tar -xvzf asterisk-11.25.3.tar.gz

cd asterisk-11.25.3

contrib/scripts/install_prereq install

contrib/scripts/get_mp3_source.sh

./configure --libdir=/usr/lib64 --without-dahdi --without-pri --with-pjproject-bundled

make

make install

make samples

make config

make install-logrotate

systemctl start asterisk

systemctl enable asterisk

cd ../

wget http://asterisk.hosting.lv/bin/codec_g729-ast110-gcc4-glibc-x86_64-core2-sse4.so

mv codec_g729-ast110-gcc4-glibc-x86_64-core2-sse4.so /usr/lib64/asterisk/modules/codec_g729.so

asterisk -x 'module load codec_g729.so'

sed -i s/\;verbose/verbose/g /etc/asterisk/asterisk.conf
