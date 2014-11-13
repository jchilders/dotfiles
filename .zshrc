# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="superjarin" # Ruby friendly

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git rails)

source $ZSH/oh-my-zsh.sh

export PATH=/usr/local/bin:/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH
export PATH=/usr/local/bin:/usr/bin:$PATH
export PATH=/usr/local/opt/ruby/bin:$PATH # Gems
export PATH=/usr/local/sqlplus:$PATH

# export SSL_CERT_FILE=/usr/share/.cacert.pem

# see: /usr/libexec/java_home
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_67.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0.jdk/Contents/Home

export JRUBY_OPTS="--headless --1.9 -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1 -J-XX:PermSize=356m -J-XX:NewSize=356m -J-XX:MaxNewSize=512m -J-XX:MaxPermSize=512m -J-Xms2048m -J-Xmx2048m"
export CATALINA_HOME=/usr/local/Cellar/tomcat/7.0.39/libexec

# Fix issue w/ oh-my-zsh cursor not being positioned correctly
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

setopt rcquotes # Use two single quotes to escape quotes when used inside a string

alias   ll='ls -alGp'
alias   l='ls -alGp'
alias   vvi='vi'
alias   tc='cd /usr/local/Cellar/tomcat/7.0.39/libexec'

alias   sms='cd ~/workspace/sms'
alias   pamt='SMS_TEST_USERNAME=''pam_client_test'' SMS_TEST_PASSWORD=''password'' rake'
alias   remora='REMORA_DB_USERNAME=''sms_user'' REMORA_DB_PASSWORD=''password'' rails s'
alias   rmrmig='REMORA_DB_USERNAME=''sms_user'' REMORA_DB_PASSWORD=''password'' rake db:migrate'
alias   rmrt='REMORA_DB_USERNAME=''sms_user'' REMORA_DB_PASSWORD=''password'' rspec --fail-fast'

function rmr() {
    REMORA_DB_USERNAME='sms_user' REMORA_DB_PASSWORD='password' $1 $2
}

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
