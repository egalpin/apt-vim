# apt-vim
Yet another Plugin Manager for Vim

- [Summary](#summary)
- [Installation](#installation)
- [Usage](#usage)
  - [Init](#init)
  - [Install](#install)
  - [List](#list)
  - [Add](#add)
  - [Remove](#remove)
  - [Delete](#delete)
  - [Update](#update)

# Summary
`apt-vim` aims to serve as a fully-automated, __cross-platform__ plugin management tool for Vim __including dependency installation__, using [Pathogen](https://github.com/tpope/vim-pathogen) at its core to load plugins. Plugins and their dependencies can be installed, removed, and updated using this one tool.

Plugin installation recipes can be saved and shared, allowing users to create portable configuration files ([here's one](https://github.com/egalpin/vim_settings/blob/master/vim_config.json)), and allowing plugin developers to create an automated installation process for their users. Installation recipes can be made cross-platform by setting recipes for `linux`, `darwin` (Mac), or `windows` (cygwin). Recipes you create will be saved under your current platform automatically.

For an example plugin recipe, see [tern_for_vim][tern_for_vim].  If you'd like to have a recipe created for your plugin, please open an issue :-)

__Note:__ `apt-vim` is under active development. Please report any issues, questions, or suggestions, however minor you feel they may be, by opening an [issue][issues]. Please also open a new [issue][issues] to create a feature request. Adding tags and thorough descriptions will be of great help!

# Installation
_Don't worry:_
 - Before starting setup, a backup of the `bundle` directory is created at `~/.vim/bundle.bak`.
 - Any plugins you already have in `~/.vim/bundle` will persist. If an existing plugin was cloned with `git`, the plugin will automatically be tracked with `apt-vim`.
 - Your `.vim` directory will not be altered aside from `bundle` (which is backed up automatically before installation), which will be soft-linked to `~/.vimpkg/bundle`.

## Option 1 - Automatic

    curl -sL https://raw.githubusercontent.com/egalpin/apt-vim/master/install.sh | sh
_Note: you may need to close and reopen your terminal_

## Option 2 - Manual
1. Install Vim
2. Install Git
3. Install python 2.7.x or python 3
4. Clone this repo:  `git clone https://github.com/egalpin/apt-vim.git`
5. Change to the cloned directory
  - `cd apt-vim`
5. Run `./apt-vim init`
  - You may be prompted for `sudo` password during installation if you are missing dependencies such as `git` or `vim`
  - See [vim_config:9](https://github.com/egalpin/apt-vim/blob/master/vim_config.json#L9)
6. Add `~/.vimpkg/bin` to your `PATH`
  - This can be done by adding `export PATH=$PATH:~/.vimpkg/bin` to `~/.bashrc` or `~/.bash_profile` or equivalent shell configuration file
  - `~/.vimpkg/bin` is where all Vim plugin dependencies will be installed
7. Add `execute pathogen#infect()` and then `call pathogen#helptags()` to `~/.vimrc`
  - If `~/.vimrc` doesn't exist, create a new `~/.vimrc` file containing at least the above 2 commands
8. `source` your shell profile.
  - This will update the `PATH` variable in the current shell
  - Future shells/logins will contain the updated `PATH` automatically
9. Run `apt-vim install`
  - You will be walked through a series of prompts to see how `apt-vim` works
  - This will clone and install [Pathogen](https://github.com/tpope/vim-pathogen) and, as an example, [Tagbar](https://github.com/majutsushi/tagbar) and its dependency, `ctags`
  - You **must** install [Pathogen](https://github.com/tpope/vim-pathogen) for `apt-vim` to work.
  - [Tagbar](https://github.com/majutsushi/tagbar) is an optional example which you can deny if desired


# Usage
In general:  `apt-vim <mode> [options] [URLs]` where mode is one of :  __[init](#init), [install](#install), [list](#list), [add](#add), [remove](#remove), [delete](#delete), [update](#update)__

The file `~/.vimpkg/vim_config.json` is used to store configurations for plugins that you use. For a simple example, take a look at [vim_config.json](vim_config.json) in this repo. For an advanced example, look  [here](https://github.com/egalpin/vim_settings/blob/master/vim_config.json).


#### init

    apt-vim init

This command sets up vital files and settings to allow `apt-vim` to do its thing. This command should only be run as part of the manual installation process, and only needs to be run once.

#### install

    apt-vim install [options] [URLs]

URLs:  URLs of Git repositories separated by whitespace

Allows you to add a plugin and its configuration to your `vim_config.json` file, _with_ installation. This will install any declared dependencies, clone the specified URL, and run any post-install commands.

Most plugins--those without dependencies--can simply be installed with `apt-vim install -y <git-url>`.  Other plugins, such as [tern_for_vim][tern_install] and [this fork of YouCompleteMe][egalpin_YouCompleteMe] have `apt-vim` recipes built-in.  These plugins, along with their dependencies, can be installed with a simple `apt-vim install -y <git-url>`.


##### For other plugins with dependencies:

There are a number of cases to consider when installing a plugin, as an installation recipe can come from many places:

1. If a configuration already exists in `vim_config.json` for a specified URL, that configuration will be used.
2. If a configuraion file was provided with the cloned plugin repo, it will be used. Configuration files are in the form of a `json` with `@vimpkg` on the first line. See [tern_for_vim][tern_for_vim]
3. If no pre-defined configuration is found, you will be prompted to enter dependencies (if any) and their installation recipes, as well as a recipe for the plugin itself (if any)
  - A recipe for a plugin refers to commands to run _after_ cloning a plugin's repo
  - A recipe for a plugin is executed from the context of the cloned directory
  - Ex. [YouCompleteMe][YouCompleteMe] requires that you run `./install.sh` after cloning

To edit the configuration for a given plugin after installation, directly edit the file `~/.vimpkg/vim_config.json` or `remove` and then `install` that specific URL.

If no URLs are provided, you will be walked through installing any plugins in `vim_config.json` that are not already installed. You will be prompted with a choice of whether or not to install each package. Use `--assume-yes` to select all packages in `vim_config.json`.

Using the `--json` option allows you to install a plugin and specify its configuration. This is useful for installing a new plugin to your Vim setup that someone has created a configuration for. See [above](#options) for an example.

#### list

    apt-vim list

Displays a list of packages you have _actually_ installed, and a list of packages that are in your `~/.vimpkg/vim_config.json` file but _not yet installed_. 

__Note__: This is not an exhaustive list of all of the plugins that can be installed using `apt-vim`. Any plugin on GitHub (or other Git repository that you have access to) can be installed using `apt-vim` by supplying the corresponding URL.

#### add

    apt-vim add [options] URLs

URLs (required):  URLs of Git repositories separated by whitespace. At least one URL must be specified to add a plugin.

Allows you to add a plugin and its configuration to your `vim_config.json` file, _without_ installing. This command mode is useful when creating a portable `vim_config.json` while not wanting to change your own system's settings. 

#### remove

    apt-vim remove [options] URLs

URLs (required):  URLs of Git repositories separated by whitespace

Removes a plugin and all of its dependencies, but KEEPS the installation recipe. A dependency (Ex. `ctags`) is __ONLY__ removed if no other plugins in your configuration have the same dependency. This feature can be helpful if trying a few similar plugins to compare features. A plugin's installation recipe can be later `deleted` if desired.

#### delete

    apt-vim delete [options] URLs

URLs (required):  URLs of Git repositories separated by whitespace

The same as `remove`, but also DELETES the installation recipe from your `vim_config.json`.

#### update

    apt-vim update [options] [URLs]

URLs:  URLs of Git repositories separated by whitespace

Update first removes a plugin's files (but _not_ its configuration), then re-clones and re-executes the configuration for that plugin.

#### Options
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

# Next Steps
- `pip` installer
- `brew` installer
- Improved cross-platform support via increased number of install targets
    - Ex. 'fedora' and 'ubuntu' rather than simply 'linux'

[tern_for_vim]: https://github.com/marijnh/tern_for_vim/blob/master/vim_config.json
[tern_install]: https://github.com/marijnh/tern_for_vim#apt-vim
[YouCompleteMe]: https://github.com/Valloric/YouCompleteMe
[issues]: https://github.com/egalpin/apt-vim/issues
[egalpin_YouCompleteMe]: https://github.com/egalpin/YouCompleteMe#installation
