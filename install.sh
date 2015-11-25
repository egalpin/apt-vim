#! /usr/bin/env sh

start_dir = `pwd`
home = $( echo $HOME )

curl -fLo ${home}/apt-vim/apt-vim --create-dirs \
    https://raw.githubusercontent.com/egalpin/apt-vim/29_ENH_one_touch_setup/apt-vim

curl -fLo ${home}/apt-vim/vim_config.json --create-dirs \
    https://raw.githubusercontent.com/egalpin/apt-vim/29_ENH_one_touch_setup/vim_config.json

cd ${home}/apt-vim
sudo python ${home}/apt-vim/apt-vim init
cd $start_dir
