if [ -n "${NAME+''}" ]; then return 1; fi
if [ -n "${EMAIL_ADDRESS+''}" ]; then return 1; fi
if [ -n "${SMB_USERNAME+''}" ]; then return 1; fi
if [ -n "${SMB_PASSWORD+''}" ]; then return 1; fi

if [ -f "/etc/wsl.conf" ]; then
    IS_WSL=1
else
    IS_WSL=0
fi

pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si && cd ..

install() {
    yay -S $* --needed -y
    echo "Installed $($*)\n" >> ~/install.log
}

install_native() {
    if [ $IS_WSL -eq 1 ];
       echo "ERR: On WSL. Did not install $($*)\n" >> ~/install.log
       then return 1;
    fi

    install $*
}

if [ $IS_WSL -eq 1 ]; then
    cat <<EOF >> /etc/wsl.conf

    [interop]
    interop=false
    appendWindowsPath=false
    EOF
fi

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

install dotnet-sdk

install micromamba-bin

install_native wezterm ttf-jetbrains-mono ttf-jetbrains-mono-nerd

git clone https://github.com/tree-sitter/tree-sitter.git
cd tree-sitter
make -j$(nproc)
sudo make install
sudo ldconfig

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

sudo echo LSP_USE_PLISTS=true >> /etc/environment
export LSP_USE_PLISTS=true
install libxpm libjpeg libpng libtiff giflib librsvg libxml2 gnutls gtk3 webkit2gtk
git clone git://git.sv.gnu.org/emacs.git --depth=1
cd emacs
./autogen
./configure --with-native-compilation=aot  --with-xwidgets --with-tree-sitter --with-json --with-imagemagick --with-pgtk --with-mailutils CFLAGS="-O2 -pipe -march=native -fomit-frame-pointer"
make -j$(nproc)
sudo make install

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install

if [ -n "${EMAIL_ADDRESS+''}" ]; then
        install isync
        mbsync --all
        mu init --maildir ~/.mail --my-address $EMAIL_ADDRESS
fi

systemctl enable --user --now emacs
sed -i s/EDITOR=.*/EDITOR=\"emacsclient\ -c\"/g test

cat <<EOF> ~/.gitconfig
[user]
	email = $EMAIL_ADDRESS
	name = $NAME
[credential]
	helper = store
[pull]
	rebase = true
EOF

echo ".dotfiles" >> .gitignore
git clone --bare https://github.com/Lillenne/dotfiles.git $HOME/.dotfiles
alias cfg='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
config reset --hard

echo "source ~./.bash_additions" >> ~/.bashrc
source ~./bashrc

doom sync

install podman podman-docker podman-compose

curl https://ollama.ai/install.sh | sh

install cifs-utils nfs-utils
sudo mkdir /mnt
sudo mkdir /mnt/nfs
sudo mkdir /mnt/smb
sudo chown nobody:nogroup /shares/nfs
sudo chown nobody:nobody /shares -R
sudo chmod 777 /shares -R
echo "nas.pixalyzer.com:/mnt/wd/nfs /shares/nfs nfs defaults 0 0" | sudo tee -a /etc/fstab > /dev/null
echo "//nas.pixalyzer.com/smb /mnt/mountpoint cifs _netdev,nofail,username=aus 0 0" | sudo tee -a /etc/fstab > /dev/null
sudo systemctl daemon-reload
mount /mnt/nfs
mount /mnt/smb
