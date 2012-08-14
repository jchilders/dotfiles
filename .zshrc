# If not running interactively, do not do anything
#[[ $- != *i* ]] && return
#[[ $TERM != screen* ]] && exec tmux

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(git ruby)

source $ZSH/oh-my-zsh.sh

## Options section
# directory stuff
setopt autocd autopushd pushd_ignore_dups pushd_silent
# completion
setopt always_to_end auto_menu no_nomatch
# history
setopt append_history hist_find_nodups hist_ignore_dups 
# i/o
setopt correct clobber interactive_comments no_mail_warning short_loops
# zle
setopt nobeep zle

bindkey "" history-incremental-search-backward

export PATH=/bin:/usr/sbin:/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin:~/scripts:

alias 	ll='ls -alGp'
alias 	l='ls -alGp'
alias	vvi='vi'
alias   wn='cd ~/workspace/newsroom'
alias   wf='cd ~/workspace/ford'

bindkey -v

export LSCOLORS=dxfxcxdxbxegedabagacad

# Wieck Stuff
export ENVIRONMENT='development'
export WIECK_PROJECT_PATH=~/workspace
export PORT_PATH=~/workspace/
export PGDATA=/usr/local/var/postgres
export JAVA_OPTS="-Xmx1024m -d32"

# Find a file or directory with a pattern in name. Case insensitive.
function ff() {
    find . -type d -iname '*'$*'*' ;
    find . -type f -iname '*'$*'*' ;
}

# Search all jar files in the current directory and below for the given string
# ffjar <pattern>
function ffjar() { 
  jars=(./**/*.jar(.))
  print "Searching ${#jars[*]} jars for '${*}'..."
  for jar in ${jars}; do
    for line in $(unzip -l ${jar}); do
      if [[ "$line" =~ .*${*}.* ]]; then
        print "${jar}: ${line}"
      fi
    done
  done
}

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export PATH=$PATH:/usr/local/rvm/bin
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
