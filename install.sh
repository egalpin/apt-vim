#! /usr/bin/env sh

curl -fLo ~/apt-vim/apt-vim --create-dirs \
    https://raw.githubusercontent.com/egalpin/apt-vim/29_ENH_one_touch_setup/apt-vim

curl -fLo ~/apt-vim/vim_config.json --create-dirs \
    https://raw.githubusercontent.com/egalpin/apt-vim/29_ENH_one_touch_setup/vim_config.json

cd ~/apt-vim
./apt-vim init
