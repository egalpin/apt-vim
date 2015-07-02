# apt-vim
Advanced Packaging Tool for VIM

##Summary
apt-vim aims to serve as a complete VIM plugin management tool including dependency installation, using [Pathogen](https://github.com/tpope/vim-pathogen) at its core to load plugins. Plugins, and their dependencies, can be installed, removed, and updated using this one tool.

Plugin installation recipes can be saved and shared, allowing users to create portable configuration files, and allowing plugin developers to create an automated installation process for their users.

#Installation
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


#Usage
In general:  `apt-vim <mode> [options] [URLs]` where mode is one of :  init, install, add, remove, update

The file `~/.vimpkg/vim_config.json` is used to store configurations for plugins that you use. For a simple example, take a look at [vim_config.json](vim_config.json) in this repo. For an advanced example, look  [here](https://github.com/egalpin/vim_settings/blob/master/vim_config.json).

__Options__
  - -y, --assume-yes
  - -j, --json

Use `--assume-yes` to tell apt-vim that you want all default options to be used. Any choice that you would typically be presented with (Ex. 'Confirm remove package `pathogen`') will not be presented and it will be assumed that you selected yes. Good for automation, but potentially dangerous.

Using the `--json` option allows you to add/install an entire configuration for a plugin. This is useful for installing a new plugin to your Vim setup that someone has created a configuration for. For example, you could add [Tagbar](https://github.com/majutsushi/tagbar) and its dependency, `ctags` like so:


```json
apt-vim install -jy
{
    "depends-on": [
        {
            "name": "ctags",
            "recipe": {
                "darwin": [
                    "curl -LSso ctags-5.8.tar.gz 'http://sourceforge.net/projects/ctags/files/ctags/5.8/ctags-5.8.tar.gz/download?use_mirror=iweb'",
                    "tar xzf ctags-5.8.tar.gz",
                    "cd ctags-5.8",
                    "sudo ./configure",
                    "sudo make",
                    "sudo make install"
                ],
                "linux": [
                    "curl -LSso ctags-5.8.tar.gz 'http://sourceforge.net/projects/ctags/files/ctags/5.8/ctags-5.8.tar.gz/download?use_mirror=iweb'",
                    "tar xzf ctags-5.8.tar.gz",
                    "cd ctags-5.8",
                    "sudo ./configure",
                    "sudo make",
                    "sudo make install"
                ]
            }
        }
    ],
    "name": "tagbar",
    "pkg-url": "https://github.com/majutsushi/tagbar.git",
    "recipe": {}
}
```


__Init__

`apt-vim init`

This command sets up vital files and settings to allow `apt-vim` to do its thing. This command should be run after cloning, and only needs to be run once.

__Add__

`apt-vim add [options] URLs`

Allows you to add a plugin and its configuration to your `vim_config.json` file, _without_ installing. This command mode is useful when creating a portable `vim_config.json` while not wanting to change your own system's settings.

URLs (required):  URLs of Git repositories separated by whitespace. At least one URL must be specified to add a plugin.

__Install__

`apt-vim install [options] [URLs]`
Allows you to add a plugin and its configuration to your `vim_config.json` file, _with_ installation. This will install any declared dependencies, clone the specified URL, and run any post-install commands.

If a configuration already exists in `vim_config.json` for a specified URL, that configuration will be used. To edit the configuration for a given plugin, directly edit the file `~/.vimpkg/vim_config.json` or `remove` and then `install`.

If no URLs are provided, you will be walked through installing any plugins in `vim_config.json` that are not already installed. You will be prompted with a choice of whether or not to install each package. Use `--assume-yes` to select all packages in `vim_config.json`.

Using the `--json` option allows you to add/install an entire configuration for a plugin. This is useful for installing a new plugin to your Vim setup that someone has created a configuration for. See above for an example.

URLs:  URLs of Git repositories separated by whitespace

__Remove__

`apt-vim remove [options] [URLs]`
Removes a plugin and all of its dependencies. In doing so, your system will not become cluttered with outdated files on which no plugins depend. A dependency (Ex. `node`) is __ONLY__ removed if no other plugins in your configuration have the same dependency.

URLs:  URLs of Git repositories separated by whitespace

__Update__

`apt-vim update [options] [URLs]`
Update first removes a plugin, then re-clones and re-executes the configuration for that plugin.

URLs:  URLs of Git repositories separated by whitespace
