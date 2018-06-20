#!/bin/bash
installPath=~/opt


cd /tmp || exit
read -r -p "[s]table or [b]eta? [sS/bB] " choice
choice=${choice,,}    # tolower
if [[ ! "$choice" =~ ^(s|b)$ ]]; then
    exit
fi
if [[ "$choice" = "s" ]]; then
    url=https://dl.pstmn.io/download/latest/linux64
    name=Postman
elif [[ "$choice" = "b" ]]; then
    url="https://dl.pstmn.io/download/channel/canary/linux_64"
    name=PostmanCanary
fi
installDir=$installPath/$name
symlink=~/.local/bin/$name
echo "Downloading $name ..."
echo "URL: $url"
wget -c "$url" -O $name.tar.gz -q --show-progress
tar -xzf $name.tar.gz
rm $name.tar.gz

echo "Installing to $installSir"
#creates path to install dir
if [ ! -d "$installDir" ];then
    mkdir -p $installDir
else    
    rm -rf $installDir
fi
mv $name $installPath

echo "Creating symbolic link..."
if [ -L "$symlink" ];then
    rm -f $symlink
fi
ln -s $installDir/$name $symlink
if [ -f "~/.local/share/applications/$name.desktop" ];then
    rm -rf ~/.local/share/applications/$name.desktop
fi
echo "[Desktop Entry]
Encoding=UTF-8
Name=$name
Exec=$name
Icon=$installDir/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;" | tee ~/.local/share/applications/$name.desktop 2&>1;
echo "Installation completed successfully."
echo "You can now run the latest version of $name! by running the command '$name'."