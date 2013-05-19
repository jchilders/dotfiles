# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="jaischeema"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

export PATH=/usr/local/opt/ruby/bin:/usr/local/bin:/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH
export PATH=/usr/local/bin:/usr/bin:$PATH
export PATH=/usr/local/opt/ruby/bin:$PATH # Gems
export PATH=/usr/local/sqlplus:$PATH
export SSL_CERT_FILE=/usr/share/.cacert.pem

alias   ll='ls -alGp'
alias   l='ls -alGp'
alias   vvi='vi'

bindkey -v

function ff() { 
  mdfind -onlyin . -name $*
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

function cvs_branches() {
  cvs log -h|awk -F"[.:]" '/^\t/&&$(NF-1)==0{print $1}'|sort -u
}

# PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
#export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt

# sudo mount -t cifs -o domain=MASERGY,user=jchilders '\\mtxfs03\Departments' /mnt/mtxfs03/departments/
