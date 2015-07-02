# apt-vim
Advanced Packaging Tool for VIM

Summary
-------------
apt-vim aims to serve as a complete VIM plugin management tool including dependency installation, using [Pathogen](https://github.com/tpope/vim-pathogen) at its core to load plugins. Plugins, and their dependencies, can be installed, removed, and updated using this one tool.

Plugin installation recipes can be saved and shared, allowing users to create portable configuration files, and allowing plugin developers to create an automated installation process for their users.

Installation
------------
1. Install VIM
2. Install Git
3. Install python 2.7.x
4. Clone this repo:  `git clone https://github.com/egalpin/apt-vim.git`
5. Change to the cloned directory
  - `cd apt-vim`
5. Run `./apt-vim init`
6. Add `~/.vimpkg/bin` to your `PATH`
  - This can be done by adding `export PATH=$PATH:~/.vimpkg/bin` to `~/.bashrc` or `~/.bash_profile` or equivalent shell configuration file
  - `~/.vimpkg/bin` is where all Vim plugin dependencies will be installed
7. Add `execute pathogen#infect()` and then `call pathogen#helptags()` to `~/.vimrc`
  - If `~/.vimrc` doesn't exist, create a new file containing just the above 2 commands
8. Run `apt-vim install -y`
  - This will clone and install [Pathogen](https://github.com/tpope/vim-pathogen) and, as an example, [Tagbar](https://github.com/majutsushi/tagbar) and its dependency, `ctags`
