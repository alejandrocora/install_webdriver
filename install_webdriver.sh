#!/bin/bash

echo "Select a WebDriver to install/update: "
echo "	1) Firefox"
echo "	2) Chrome"
echo "	3) All"
echo "	4) Exit"
echo -n "> "
read target

if [ $target -ge 4 ]; then
 	 exit
fi

version=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/mozilla/geckodriver/releases/latest | grep -P '[^tag/]*$' -o)
architecture=$(uname -m | grep -P '[^_]*$'  -o)

if [ $target == 1 ] || [ $target == 3 ]; then
	echo "	Installing Firefox geckodriver."
	firefox_download=https://github.com/mozilla/geckodriver/releases/download/$version/geckodriver-$version-linux$architecture.tar.gz
	echo "	Downloading file..."
	curl -L $firefox_download --output /tmp/geckodriver.tar.gz
	echo "	Uncompressing..."
	tar xf /tmp/geckodriver.tar.gz -C /tmp/
	echo "	Moving to '/usr/bin/'..."
	mv /tmp/geckodriver /usr/bin/geckodriver
	rm -rf /tmp/geckodriver.tar.gz
fi

# if [ $target == 2 ] || [ $target == 3 ]; then
# else
# fi

echo "	Installation finished."
