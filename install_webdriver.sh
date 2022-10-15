#!/bin/bash

function dem {
	echo "	Downloading file..."
	curl --silent -L $1 --output $2
	echo "	Uncompressing..."
	file_term=$(echo $2 | grep -P -o '[.].*')
	if [ $file_term == '.tar.gz' ]; then
		driver_file=$(tar xfv $2 -C $(echo $2 | grep -P -o '.+?(?=\/)'))
	fi
	if [ $file_term == '.zip' ]; then
		driver_file=$(echo $2 | sed "s/\/tmp\///g" | sed "s/$file_term//g")
		unzip -qq $2 -d $(echo $2 | grep -P -o '.+?(?=\/)')
	fi
	echo "	Moving to '/usr/bin/'..."
	mv /tmp/$driver_file /usr/bin/$driver_file
	rm -rf $2
	echo "	Done!"
}

echo "Select a WebDriver to install/update: "
echo "	1) Firefox Geckodriver"
echo "	2) ChromeDriver"
echo "	3) All"
echo "	4) Exit"
echo -n "	> "
read target

if [ $target -ge 4 ]; then
 	 exit
fi

architecture=$(uname -m | grep -P '[^_]*$' -o)

if [ $target == 1 ] || [ $target == 3 ]; then
	echo "Installing Firefox Geckodriver."
	firefox_version=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/mozilla/geckodriver/releases/latest | grep -P '[^tag/]*$' -o)
	firefox_download=https://github.com/mozilla/geckodriver/releases/download/$firefox_version/geckodriver-$firefox_version-linux$architecture.tar.gz
	dem $firefox_download /tmp/geckodriver.tar.gz
	echo "Installation finished."
	echo ""
fi

if [ $target == 2 ] || [ $target == 3 ]; then
	echo "Installing ChromeDriver."
	chrome_scrap=$(curl https://chromedriver.chromium.org/downloads 2>&1 | grep -P '(?<=please download ChromeDriver ).*$' -o | sort | uniq | tr "\n" " ")
	IFS=' ' read -ra chrome_versions <<< $chrome_scrap
	echo "	Select a ChromeDriver version: "
	i=0
	for element in "${chrome_versions[@]}"
	do
		i=$((i+1))
		echo "		$i) $element"
	done
	echo -n "		> "
	read selection
	selection=$((selection-1))
	chrome_download=https://chromedriver.storage.googleapis.com/${chrome_versions[selection]}/chromedriver_linux$architecture.zip
	dem $chrome_download /tmp/chromedriver.zip
	echo "Installation finished."
	echo ""
fi
