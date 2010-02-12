# /etc/profile

# System wide environment and startup programs, for login setup
# Functions and aliases go in /etc/bashrc

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



function pathmunge () {
        if ! echo $PATH | egrep "(^|:)$1($|:)" >/dev/null ; then
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

# Path manipulation
pathmunge /sbin
pathmunge /usr/sbin
pathmunge /opt/local/bin
pathmunge /opt/local/sbin
pathmunge /usr/local/sbin after
pathmunge /usr/local/bin after
pathmunge /dmadmin/scripts
pathmunge ~root/tools/bin


# No core files by default
ulimit -S -c 0 > /dev/null 2>&1

CLICOLOR=1
HOSTNAME=`/bin/hostname`
HISTSIZE=10000
TMOUT=0

if [ -z "$INPUTRC" -a ! -f "$HOME/.inputrc" ]; then
    INPUTRC=/etc/inputrc
fi

PS1="[\u@\H \w]\\$ "

hasvim=`which vim 2>/dev/null`
if [[ $? == 0 ]]; then
        VISUAL=$hasvim
        SVN_EDITOR=$hasvim
else
        VISUAL=`which vi`
        SVN_EDITOR=$VISUAL
fi



export PATH USER HOSTNAME HISTSIZE INPUTRC PS1 TMOUT CLICOLOR VISUAL SVN_EDITOR

unset i
unset pathmunge
