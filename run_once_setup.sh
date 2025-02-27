#!/bin/bash
sudo pacman -Syu
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd ..
yay --editmenu --save

echo MAKEFLAGS="-j$(nproc)" | sudo tee -a /etc/environment /etc/makepkg.conf

# TODO chezmoi templating
if [ -f "/etc/wsl.conf" ]; then
    IS_WSL=1
else
    IS_WSL=0
fi

install() {
    yay -S --noconfirm --needed $*
    echo "Installed $*" >> ~/install.log
}

install_native() {
    if [ $IS_WSL -eq 1 ]; then
       echo "Did not install $*" >> ~/install.log
       return 0;
    fi

    install $*
    return 0
}

if [ $IS_WSL -eq 1 ]; then
    install xclip
fi

localectl set-locale LANG=en_US.UTF-8
unset LANG
source /etc/profile.d/locale.sh

install git-lfs
chmod +x ~/git/ediff.sh

install rust

install dotnet-sdk dotnet-sdk-8.0 aspnet-runtime
dotnet tool install --global csharp-ls
dotnet tool install --global dotnet-ef
echo "DOTNET_CLI_TELEMETRY_OPTOUT=true" | sudo tee -a /etc/environment > /dev/null

curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
mamba init
# mamba create -n ml
# mamba activate ml
# mamba install numpy pandas matplotlib jupyterlab pyright debugpy
# exec "$SHELL"

# install micromamba-bin
# micromamba shell init --shell bash --root-prefix=~/micromamba
# micromamba create -n ml
# micromamba activate ml
# micromamba install numpy pandas matplotlib jupyterlab pyright debugpy

install ttf-jetbrains-mono ttf-jetbrains-mono-nerd
install_native alacritty

install tree-sitter
# git clone https://github.com/tree-sitter/tree-sitter.git
# cd tree-sitter
# make -j$(nproc)
# sudo make install
# sudo ldconfig
# cd ..

install tree-sitter-cli

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
install ripgrep findutils lazygit npm neovim yarn fd luarocks bottom gdu luajit-tiktoken-bin prettier
sudo luarocks --lua-version=5.1 install magick
#python3 -m pip install pynvim
install python-pynvim
sudo npm install -f neovim
luarocks config lua_version 5.1
luarocks config variables.LUA /usr/bin/luajit
luarocks config variables.LUA_INCDIR /usr/include/luajit-2.1

# curl -L https://github.com/dundee/gdu/releases/latest/download/gdu_linux_amd64.tgz | tar xz
# chmod +x gdu_linux_amd64
# sudo mv gdu_linux_amd64 /usr/local/bin/gdu
echo EDITOR=nvim | sudo tee -a /etc/environment

echo "LSP_USE_PLISTS=true" | sudo tee -a /etc/environment > /dev/null
export LSP_USE_PLISTS=true
echo "WEBKIT_DISABLE_DMABUF_RENDERER=1" | sudo tee -a /etc/environment
export "WEBKIT_DISABLE_DMABUF_RENDERER=1"
install libxpm libjpeg libpng libtiff giflib librsvg libxml2 gnutls gtk3 webkit2gtk imagemagick pandoc-bin cmake texlive-core texlive-bin texlive-science gnuplot jupyter texlive-latexextra emacs figlet
mkdir ~/org

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
doom sync --gc -j $(nproc)

# install isync mu
# mu init --maildir ~/mail --my-address $EMAIL_ADDRESS
# mu index

systemctl enable --user --now emacs
install sed
sudo sed -i s/EDITOR=.*/EDITOR=\"emacsclient\"/g /etc/environment

install podman podman-docker podman-compose

# install cifs-utils nfs-utils
# sudo mkdir /mnt
# sudo mkdir /mnt/nfs
# sudo mkdir /mnt/smb
# sudo chown nobody:nobody /mnt/nfs
# sudo chown nobody:nobody /mnt/smb -R
# sudo chmod 777 /mnt/nfs -R
# sudo chmod 777 /mnt/smb -R
# echo "$(NFS_SHARE_LOCATION):/mnt/wd/nfs /mnt/nfs nfs defaults 0 0" | sudo tee -a /etc/fstab > /dev/null
# echo "//$(SMB_SHARE_LOCATION)/smb /mnt/smb cifs _netdev,nofail,credentials=/root/.smbcredentials 0 0" | sudo tee -a /etc/fstab > /dev/null
# sudo systemctl daemon-reload
# mount /mnt/nfs
# mount /mnt/smb

sudo firewall-cmd --zone=home --add-port=22000/tcp
sudo firewall-cmd --zone=home --add-port=22000/udp
sudo firewall-cmd --zone=home --add-port=21027/udp
sudo firewall-cmd --runtime-to-permanent
install syncthing
systemctl enable --now syncthing@${user}.service

install_native redshift
cat <<EOF > tee ~/.config/autostart/redshift.conf
[redshift]
location-provider=manual
[manual]
lon=23
lat=44
EOF


if [ $IS_WSL -eq 1 ]; then
redshift -P -O 4500
fi

install direnv
