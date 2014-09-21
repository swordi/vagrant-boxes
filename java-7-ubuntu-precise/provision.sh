#!/usr/bin/env bash

if ! type "java" > /dev/null 2>&1; then
	echo "Installing Java 7"	

	sudo apt-get update
	sudo apt-get -y -q install curl vim git python-software-properties

	sudo add-apt-repository ppa:webupd8team/java
	sudo echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
	sudo echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections

	sudo apt-get update
	sudo apt-get -y -q install oracle-java7-installer

	sudo apt-get autoremove
	sudo apt-get clean

	rm -rf /usr/share/doc
	rm -rf /usr/src/vboxguest*
	rm -rf /usr/src/virtualbox-ose-guest*
	find /var/cache -type f -exec rm -rf {} \;
	rm -rf /usr/share/locale/{af,am,ar,as,ast,az,bal,be,bg,bn,bn_IN,br,bs,byn,ca,cr,cs,csb,cy,da,de,de_AT,dz,el,en_AU,en_CA,eo,es,et,et_EE,eu,fa,fi,fo,fr,fur,ga,gez,gl,gu,haw,he,hi,hr,hu,hy,id,is,it,ja,ka,kk,km,kn,ko,kok,ku,ky,lg,lt,lv,mg,mi,mk,ml,mn,mr,ms,mt,nb,ne,nl,nn,no,nso,oc,or,pa,pl,ps,pt,pt_BR,qu,ro,ru,rw,si,sk,sl,so,sq,sr,sr*latin,sv,sw,ta,te,th,ti,tig,tk,tl,tr,tt,ur,urd,ve,vi,wa,wal,wo,xh,zh,zh_HK,zh_CN,zh_TW,zu}	

	rm -f /home/vagrant/*.sh

	dd if=/dev/zero of=/EMPTY bs=1M
	rm -f /EMPTY
else
	echo "Java is already installed"	
fi