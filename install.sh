#! /usr/bin/env sh

start_dir=$(pwd)
log_file="${HOME}/apt-vim/install.log"

# Redirect all output to install log
exec 5<&1
exec 6<&2
exec 1> $log_file 2>&1

echo

if grep -q "export PATH=${PATH}:${HOME}/.vimpkg/bin" then
    echo "export PATH=${PATH}:${HOME}/.vimpkg/bin" >> /etc/profile
fi

# Download the apt-vim files
curl -fLo ${HOME}/apt-vim/apt-vim --create-dirs \
    https://raw.githubusercontent.com/egalpin/apt-vim/29_ENH_one_touch_setup/apt-vim

curl -fLo ${HOME}/apt-vim/vim_config.json \
    https://raw.githubusercontent.com/egalpin/apt-vim/29_ENH_one_touch_setup/vim_config.json

# Add vimrc if there isn't one already
[ -f ${HOME}/.vimrc ] || touch ${HOME}/.vimrc

# Make sure vimrc is using pathogen
if grep -q "execute pathogen#infect()" then
    echo "execute pathogen#infect()" >> ${HOME}/.vimrc
fi
if grep -q "call pathogen#helptags()" then
    echo "call pathogen#helptags()" >> ${HOME}/.vimrc
fi

# Execute apt-vim init
cd ${HOME}/apt-vim
sudo python apt-vim init
cd $start_dir

# Restore stdin / stdout
exec 1<&5
exec 2<&6

echo "${PATH}:${HOME}/.vimpkg/bin"
