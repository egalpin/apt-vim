function __apt_vim_installed
  apt-vim list | awk '/Installed/,/^\s*$/' | awk '/^\s*$/ { next; } {if (NR!=1) { print $1 }}'
end

function __apt_vim_available
  apt-vim list | awk '/Available/,/^\s*$/' | awk '/^\s*$/ { next; } {if (NR!=1) { print $1 }}'
end

function __apt_vim_all
  apt-vim list | awk '/^\t+[A-Za-z]+/ { print $1 }'
end

complete -c apt-vim -x
complete -c apt-vim -s y -l assume-yes
complete -c apt-vim -s j -l json

complete -c apt-vim -n "__fish_use_subcommand" -x -a add
complete -c apt-vim -n "__fish_use_subcommand" -x -a delete
complete -c apt-vim -n "__fish_use_subcommand" -x -a init
complete -c apt-vim -n "__fish_use_subcommand" -x -a install
complete -c apt-vim -n "__fish_use_subcommand" -x -a list
complete -c apt-vim -n "__fish_use_subcommand" -x -a remove
complete -c apt-vim -n "__fish_use_subcommand" -x -a update

complete -c apt-vim -n "__fish_seen_subcommand_from remove" -a '(__apt_vim_installed)'
complete -c apt-vim -n "__fish_seen_subcommand_from update" -a '(__apt_vim_installed)'
complete -c apt-vim -n "__fish_seen_subcommand_from install" -a '(__apt_vim_available)'
complete -c apt-vim -n "__fish_seen_subcommand_from delete" -a '(__apt_vim_all)'
