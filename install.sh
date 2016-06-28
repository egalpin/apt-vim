#! /usr/bin/env sh

start_dir=$(pwd)
bin_string="PATH=${PATH}:${HOME}/.vimpkg/bin"

#if [ -f /etc/profile ] && [ $(sudo grep -c "export PATH=\$PATH:${HOME}/.vimpkg/bin" /etc/profile) -eq 0 ]; then
    #sudo chmod 666 /etc/profile
    #sudo echo "export PATH=\$PATH:${HOME}/.vimpkg/bin" >> /etc/profile
    #sudo chmod 444 /etc/profile
#fi

#if [ -f /etc/bash.bashrc ] && [ $(sudo grep -c "export PATH=\$PATH:${HOME}/.vimpkg/bin" /etc/bash.bashrc) -eq 0 ]; then
    #sudo chmod 666 /etc/bash.bashrc
    #sudo echo "export PATH=\$PATH:${HOME}/.vimpkg/bin" >> /etc/bash.bashrc
    #sudo chmod 444 /etc/bash.bashrc
#fi

# Download the apt-vim files
curl -fSsLo ${HOME}/apt-vim/apt-vim --create-dirs \
    https://raw.githubusercontent.com/egalpin/apt-vim/master/apt-vim

curl -fSsLo ${HOME}/apt-vim/vim_config.json \
    https://raw.githubusercontent.com/egalpin/apt-vim/master/vim_config.json

# Add vimrc if there isn't one already
[ -f ${HOME}/.vimrc ] || touch ${HOME}/.vimrc

# Make sure vimrc is using pathogen
if [ $(grep -c "execute pathogen#infect()" ${HOME}/.vimrc) -eq 0 ]; then
    echo "execute pathogen#infect()" >> ${HOME}/.vimrc
fi
if [ $(grep -c "call pathogen#helptags()" ${HOME}/.vimrc) -eq 0 ]; then
    echo "call pathogen#helptags()" >> ${HOME}/.vimrc
fi

# Update path for executing shell
export "$bin_string"

added_to_profile=false
already_present=false
for rc in bashrc zshrc bash_profile; do
  if [ -s "$HOME/.$rc" ]; then
    if grep -q "$bin_string" "$HOME/.$rc"; then
      printf "== apt-vim PATH already installed in '~/.$rc'\n"
      already_present=true
    else
      printf "\n$bin_string\n" >> "$HOME/.$rc"
      printf "== Added apt-vim PATH to '~/.$rc'\n"
      added_to_profile=true
    fi
  fi
done

# Execute apt-vim init
cd ${HOME}/apt-vim
python - <<EOF
import imp, os
print('apt-vim setup starting')
HOME = os.path.expanduser("~")
APT_VIM_DIR = os.path.abspath(os.path.join(HOME, 'apt-vim'))
SCRIPT_ROOT_DIR = os.path.abspath(os.path.join(HOME, '.vimpkg'))
BIN_DIR = os.path.abspath(os.path.join(SCRIPT_ROOT_DIR, 'bin'))
os.environ['PATH'] += os.pathsep + BIN_DIR
os.chdir(APT_VIM_DIR)

aptvim = imp.load_source("aptvim", "./apt-vim")
av = aptvim.aptvim(ASSUME_YES=True, VIM_CONFIG='', INSTALL_TARGET='')
av.first_run()
av.handle_install(None, None, None)
EOF

cd $start_dir
added_to_bin=false
cp ${HOME}/apt-vim/apt-vim ${HOME}/.vimpkg/bin && added_to_bin=true


if [ "$added_to_profile" = false ] && [ "$already_present" = false ]; then
    echo "== Error:"
    echo "   Found no profile to add apt-vim PATH to."
    echo "   Add the following line to your shell profile and source it to install manually:"
    printf "   $exec_string\n"
elif [ "$added_to_bin" = false ]; then
    echo "== Error:"
    echo "   Failed to add apt-vim to ${HOME}/.vimpkg/bin"
    echo "   Please add ${HOME}/apt-vim/apt-vim to PATH."
else
    echo "== apt-vim installation succeeded! Run 'source ~/.bashrc || source ~/.bash_profile' or 'source ~/.zshrc'"
    echo "   to access the executable script."
fi
