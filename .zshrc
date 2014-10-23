# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="af-magic"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git gradle)

source $ZSH/oh-my-zsh.sh

export PATH=/usr/local/bin:/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH
export PATH=/usr/local/bin:/usr/bin:$PATH
export PATH=/usr/local/opt/ruby/bin:$PATH # Gems
export PATH=/usr/local/sqlplus:$PATH

export SSL_CERT_FILE=/usr/share/.cacert.pem

# see: /usr/libexec/java_home
#export JAVA_HOME=/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_67.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0.jdk/Contents/Home

export CATALINA_HOME=/usr/local/Cellar/tomcat/7.0.39/libexec

# Fix prob with sed on Mavericks
export LC_CTYPE=C
export LANG=C

# Fix prob with git svn on Mavericks
export PERL5LIB='/Library/Developer/CommandLineTools/Library/Perl/5.16/darwin-thread-multi-2level/'

alias   ll='ls -alGp'
alias   l='ls -alGp'
alias   vvi='vi'
alias   tc='cd /usr/local/Cellar/tomcat/7.0.39/libexec'

function ff() { 
  mdfind -onlyin . -name $*
}

# Search all jar files in the current directory and below for the given string
# ffjar <pattern>
# Requires GNU parallel and the_silver_searcher
function ffjar() { 
  jars=(./**/*.jar)
  print "Searching ${#jars[*]} jars for '${*}'..."
  parallel --no-notice --tag unzip -l ::: ${jars} | ag ${*} | awk '{print $1, ":", $5}'
}

function cstart() {
  catalina start
}
function cstop() {
  catalina stop
}

bindkey -v
bindkey '^R' history-incremental-search-backward

# export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt

# sudo mount -t cifs -o domain=MASERGY,user=jchilders '\\mtxfs03\Departments' /mnt/mtxfs03/departments/


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
