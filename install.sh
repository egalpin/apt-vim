#! /usr/bin/env sh

start_dir=$(pwd)

if [ $(sudo grep -c "export PATH=\$PATH:${HOME}/.vimpkg/bin" /etc/profile) -eq 0 ]; then
    sudo chmod 666 /etc/profile
    sudo echo "export PATH=\$PATH:${HOME}/.vimpkg/bin" >> /etc/profile
    sudo chmod 444 /etc/profile
fi

# Download the apt-vim files
curl -fLo ${HOME}/apt-vim/apt-vim --create-dirs \
    https://raw.githubusercontent.com/egalpin/apt-vim/29_ENH_one_touch_setup/apt-vim

curl -fLo ${HOME}/apt-vim/vim_config.json \
    https://raw.githubusercontent.com/egalpin/apt-vim/29_ENH_one_touch_setup/vim_config.json

# Add vimrc if there isn't one already
[ -f ${HOME}/.vimrc ] || touch ${HOME}/.vimrc

# Make sure vimrc is using pathogen
if [ $(grep -c "execute pathogen#infect()" ${HOME}/.vimrc) -eq 0 ]; then
    echo "execute pathogen#infect()" >> ${HOME}/.vimrc
fi
if [ $(grep -c "call pathogen#helptags()" ${HOME}/.vimrc) -eq 0 ]; then
    echo "call pathogen#helptags()" >> ${HOME}/.vimrc
fi

# Execute apt-vim init
cd ${HOME}/apt-vim
sudo python apt-vim init
cd $start_dir
