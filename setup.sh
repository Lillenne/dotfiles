sudo pacman -Syu
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd ..
yay --editmenu --save
yay -S git-secret -y

echo MAKEFLAGS="-j$(nproc)" >> /etc/makepkg.conf
echo MAKEFLAGS="-j$(nproc)" | sudo tee -a /etc/environment

if [ -f "/etc/wsl.conf" ]; then
    IS_WSL=1
else
    IS_WSL=0
fi

install() {
    yay -Sy --needed $*
    echo "Installed $($*)" >> ~/install.log
}

install_native() {
    if [ $IS_WSL -eq 1 ]; then
       echo "ERR: On WSL. Did not install $($*)" >> ~/install.log
       return 0;
    fi

    install $*
    return 0
}

if [ $IS_WSL -eq 1 ]; then
    cat <<EOF >> /etc/wsl.conf

    [interop]
    interop=false
    appendWindowsPath=false
    EOF

    install xclip
fi

localectl set-locale LANG=en_US.UTF-8
unset LANG
source /etc/profile.d/locale.sh

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

install dotnet-sdk
dotnet tool install --global csharp-ls

install micromamba-bin
micromamba shell init --shell bash --root-prefix=~/micromamba
micromamba create -n ml
micromamba activate ml
micromamba install numpy pandas matplotlib jupyterlab pyright debugpy

install ttf-jetbrains-mono ttf-jetbrains-mono-nerd
install_native wezterm

git clone https://github.com/tree-sitter/tree-sitter.git
cd tree-sitter
make -j$(nproc)
sudo make install
sudo ldconfig
cd ..

cargo install tree-sitter-cli

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
install ripgrep findutils lazygit npm neovim yarn fd luarocks bottom
sudo luarocks --lua-version=5.1 install magick
python3 -m pip install pynvim
sudo npm install -f neovim
luarocks config lua_version 5.1
luarocks config variables.LUA /usr/bin/luajit
luarocks config variables.LUA_INCDIR /usr/include/luajit-2.1

curl -L https://github.com/dundee/gdu/releases/latest/download/gdu_linux_amd64.tgz | tar xz
chmod +x gdu_linux_amd64
sudo mv gdu_linux_amd64 /usr/local/bin/gdu

echo ".dotfiles" >> .gitignore
git clone --bare https://github.com/Lillenne/dotfiles.git $HOME/.dotfiles
alias cfg='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
cfg reset --hard

echo "source ~/.bash_additions" >> ~/.bashrc
source ~/.bashrc
git config --global init.defaultBranch main

if [ -f "~/.dotvars.secret" ]; then return 1; fi
cfg secret reveal
set -o allexport
source ~/.dotvars
set +o allexport

cat <<EOF> ~/.gitconfig
[user]
	name = $NAME
	email = $GIT_EMAIL
[credential]
	helper = store
[pull]
	rebase = true
EOF

echo "LSP_USE_PLISTS=true" | sudo tee -a /etc/environment > /dev/null
export LSP_USE_PLISTS=true
echo "WEBKIT_DISABLE_DMABUF_RENDERER=1" | sudo tee -a /etc/environment
export "WEBKIT_DISABLE_DMABUF_RENDERER=1"
install libxpm libjpeg libpng libtiff giflib librsvg libxml2 gnutls gtk3 webkit2gtk imagemagick pandoc-bin cmake
install emacs-git
mkdir ~/org

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
cfg reset --hard
doom sync
doom gc

install isync mu
mu init --maildir ~/.pmail --my-address $EMAIL_ADDRESS
mu index

systemctl enable --user --now emacs
install sed
sudo sed -i s/EDITOR=.*/EDITOR=\"emacsclient\"/g /etc/environment

install podman podman-docker podman-compose

install cifs-utils nfs-utils
sudo mkdir /mnt
sudo mkdir /mnt/nfs
sudo mkdir /mnt/smb
sudo chown nobody:nobody /mnt/nfs
sudo chown nobody:nobody /mnt/smb -R
sudo chmod 777 /mnt/nfs -R
sudo chmod 777 /mnt/smb -R
echo "$(NFS_SHARE_LOCATION):/mnt/wd/nfs /mnt/nfs nfs defaults 0 0" | sudo tee -a /etc/fstab > /dev/null
echo "//$(SMB_SHARE_LOCATION)/smb /mnt/smb cifs _netdev,nofail,credentials=/root/.smbcredentials 0 0" | sudo tee -a /etc/fstab > /dev/null
sudo systemctl daemon-reload
mount /mnt/nfs
mount /mnt/smb

  sudo firewall-cmd --zone=home --add-port=22000/tcp
  sudo firewall-cmd --zone=home --add-port=22000/udp
  sudo firewall-cmd --zone=home --add-port=21027/udp
  sudo firewall-cmd --runtime-to-permanent
  install syncthing
  systemctl enable --now syncthing@${user}.service
