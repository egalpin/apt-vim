#! /usr/bin/env sh

start_dir=$(pwd)

if [ -f /etc/profile ] && [ $(sudo grep -c "export PATH=\$PATH:${HOME}/.vimpkg/bin" /etc/profile) -eq 0 ]; then
    sudo chmod 666 /etc/profile
    sudo echo "export PATH=\$PATH:${HOME}/.vimpkg/bin" >> /etc/profile
    sudo chmod 444 /etc/profile
fi

if [ -f /etc/bash.bashrc ] && [ $(sudo grep -c "export PATH=\$PATH:${HOME}/.vimpkg/bin" /etc/bash.bashrc) -eq 0 ]; then
    sudo chmod 666 /etc/bash.bashrc
    sudo echo "export PATH=\$PATH:${HOME}/.vimpkg/bin" >> /etc/bash.bashrc
    sudo chmod 444 /etc/bash.bashrc
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

# Update path for current shell
export PATH=${PATH}:${HOME}/.vimpkg/bin

# Execute apt-vim init
cd ${HOME}/apt-vim
exec python apt-vim init
#python -i <<EOF
#import imp
#import os
#HOME = os.path.expanduser("~")
#APT_VIM_DIR = os.path.abspath(os.path.join(HOME, 'apt-vim'))
#SCRIPT_ROOT_DIR = os.path.abspath(os.path.join(HOME, '.vimpkg'))
#BIN_DIR = os.path.abspath(os.path.join(SCRIPT_ROOT_DIR, 'bin'))
#os.environ['PATH'] += os.pathsep + BIN_DIR
#os.chdir(APT_VIM_DIR)

#aptvim = imp.load_source("aptvim", "./apt-vim")
#aptvim.first_run()
#EOF
cd $start_dir
