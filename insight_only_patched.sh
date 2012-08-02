#!/bin/sh

# Install some packages
/usr/bin/apt-get install tofrodos nasm kate bless kdbg ktechlab kile konsole build-essential xorg-dev libncurses5-dev libpthread-stubs0-dev libpthread-stubs0 libx11-dev libncurses-dev

# If insight isn't installed, then install it
if [ ! -e /usr/local/bin/insight ]
then 	# Make sure we are in the correct directory
	cd /usr/local/src

	# Only download the file once.
	if [ ! -e /usr/local/src/insight-6.8-1-gl.tar.gz ]
	then
		/usr/bin/wget http://www.tech.dmu.ac.uk/~glapworth/src/insight/insight-6.8-1-gl.tar.gz -O /usr/local/src/insight-6.8-1-gl.tar.gz
	fi

	# If download failed, try local tarball if available.
	file /usr/local/src/insight-6.8-1-gl.tar.gz | grep 'gzip compressed data' >/dev/null 2>&1
	if [ $? -ne 0 ]
	then
		cd -
		if [ -e insight-6.8-1-gl.tar.gz ]
		then
			cp -f insight-6.8-1-gl.tar.gz /usr/local/src/
			cd /usr/local/src
		fi
	fi

	# Only extract the program once
	if [ ! -d /usr/local/src/insight-6.8-1 ]
	then
		/bin/tar -xvzf /usr/local/src/insight-6.8-1-gl.tar.gz
	fi

	sed 's/-Werror//g' /usr/local/src/insight-6.8-1/bfd/Makefile > /usr/local/src/insight-6.8-1/bfd/Makefile.tmp
	mv -f /usr/local/src/insight-6.8-1/bfd/Makefile.tmp /usr/local/src/insight-6.8-1/bfd/Makefile

	sed 's/-Werror//g' /usr/local/src/insight-6.8-1/opcodes/Makefile > /usr/local/src/insight-6.8-1/opcodes/Makefile.tmp
	mv -f /usr/local/src/insight-6.8-1/opcodes/Makefile.tmp /usr/local/src/insight-6.8-1/opcodes/Makefile

	cd insight-6.8-1
	./configure
	make
	make install

fi
# If the insight launcher hasn't been installed, then set one up!
if [ ! -e /usr/share/applications/insight.desktop ]
then	
	echo "[Desktop Entry]" > /usr/share/applications/insight.desktop
	echo "Version=1.0" >> /usr/share/applications/insight.desktop
	echo "Encoding=UTF-8" >> /usr/share/applications/insight.desktop
	echo "Name=Insight Debugger">> /usr/share/applications/insight.desktop
	echo "Comment=GDB Style graphical debugger" >> /usr/share/applications/insight.desktop
	echo "Exec=insight" >> /usr/share/applications/insight.desktop
	echo "Icon=gnome-mnemonic.png" >> /usr/share/applications/insight.desktop
	echo "Terminal=false" >> /usr/share/applications/insight.desktop
	echo "Type=Application" >> /usr/share/applications/insight.desktop
	echo "Categories=Application;Development;" >> /usr/share/applications/insight.desktop
	
fi
