# Zsh startup, cobbled together.

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

## Completion section - from http://zshwiki.org/home/examples/compquickstart
# simple completions
# complete only dirs (or symlinks to dirs in some cases) for certain commands
zmodload zsh/complist
autoload -U compinit && compinit

zstyle ':completion:*' max-errors 2
zstyle ':completion:::::' completer _complete _approximate
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) )'
zstyle ':completion:*:descriptions' format "- %d -"
zstyle ':completion:*:corrections' format "- %d - (errors %e})"
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*' menu select=3
zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache on
zstyle ':completion:*' users resolve

if [[ -f $HOME/.ssh/known_hosts ]]; then
  hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*})
  zstyle ':completion:*:hosts' hosts $hosts
fi

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

## Bindkey section
# vi-mode by default
bindkey -v
# in menu selection, use ^o instead of ^m to go into a menu'ed directory
bindkey -M menuselect '^o' accept-and-infer-next-history
# emacs-esque things i'm used to
bindkey "" history-incremental-search-backward
bindkey "_" insert-last-word
bindkey "" end-of-line
bindkey "" beginning-of-line

# number of lines kept in history
export HISTSIZE=1000
# number of lines saved in the history after logout
export SAVEHIST=1000
# location of history
export HISTFILE=$HOME/.zhistory

# crazy scripts to source
source $HOME/.zsh/windowtitle.zsh

## alias section
alias d="screen -d main; screen -x main"
alias jump='ssh -t launchpad002 ssh'

## function section, for things longer than aliases
function rmssh () {
    sed -ie "$1d" ~/.ssh/known_hosts
}

function hpre() {
    awk -v h="$1" '{printf("%24s | %s\n", h,$0);}'
}

function hj() {
    [[ $# -lt 3 ]] && return -1
    jot -w "${1}%03d" $(($3-$2+1)) $2 $3
}

function d() {
    if [[ -z $1 ]] ; then s=main
    else 
        s=$1
    fi
    screen -d $s
    screen -x $s
}
    
function fss() {
    [[ ! -z $SSH_AUTH_SOCK ]] && echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK" > ~/ssh.sh || echo "No SSH_AUTH_SOCK variable here"
}

function ss() {
    source ~/ssh.sh
}

# from RH /etc/profile
function pathmunge () {
	if ! echo $PATH | egrep -q "(^|:)$1($|:)" ; then
	   if [ "$2" = "after" ] ; then
              if [[ -d $1 ]]; then
                 PATH=$PATH:$1
              fi
	   else
              if [[ -d $1 ]]; then
                 PATH=$1:$PATH
              fi
	   fi
	fi
}


pathmunge /sbin
pathmunge /usr/sbin
pathmunge /opt/local/bin
pathmunge /opt/local/sbin
pathmunge /usr/local/sbin after
pathmunge /usr/local/bin after
pathmunge /dmadmin/scripts
pathmunge /root/tools/bin

unset pathmunge

# variables to set
TZ="America/Los_Angeles"
PS1="[%n@%3m %40<...<%~]%# " 


if [[ `uname` == "Darwin" ]]; then
	# for osx desktops only
	MANPATH=/usr/local/man:/usr/share/man:/opt/local/man
	CLICOLOR=1
	export CLICOLOR
	# convenient aliases
	alias restartvpn="sudo /System/Library/StartupItems/CiscoVPN/CiscoVPN restart"
fi

hasvim=`which vim 2>/dev/null`
if [[ $? == 0 ]]; then
        VISUAL=$hasvim
        SVN_EDITOR=$hasvim
else
        VISUAL=`which vi`
        SVN_EDITOR=$VISUAL
fi

export TZ PS1 PATH VISUAL SVN_EDITOR
