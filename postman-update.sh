#!/bin/bash
if [ "$(id -u)" != "0" ]; then
    /bin/echo -e "sudo me, please :)\naka: need root" 1>&2
   exit 1
fi

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
echo "Downloading $name ..."
echo "URL: $url"
wget -c "$url" -O $name.tar.gz -q --show-progress
tar -xzf $name.tar.gz
echo "Changing ownership of files to root ..."
chown -R root:root $name

# rm $name.tar.gz
echo "Installing to opt..."
if [ -d "/opt/$name" ];then
    sudo rm -rf /opt/$name
fi
sudo mv $name /opt/$name
echo "Creating symbolic link..."
if [ -L "/usr/bin/$name" ];then
    sudo rm -f /usr/bin/$name
fi
sudo ln -s /opt/$name/$name /usr/bin/$name
if [ -f "/usr/share/applications/$name.desktop" ];then
    sudo rm -rf /usr/share/applications/$name.desktop
fi
echo "[Desktop Entry]
Encoding=UTF-8
Name=$name
Exec=$name
Icon=/opt/$name/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;" > /usr/share/applications/$name.desktop
echo "Installation completed successfully."
echo "You can now run the latest version of $name! by running the command '$name'."