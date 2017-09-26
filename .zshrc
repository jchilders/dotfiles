# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="superjarin" # Ruby friendly
# ZSH_THEME="theunraveler" # minimalistic
# ZSH_THEME="sunaku"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git rails tmux rake-fast z grunt)

source $ZSH/oh-my-zsh.sh

export PATH=/usr/local/bin:/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/usr/local/bin:$PATH
export PATH=/usr/local/bin:/usr/bin:$PATH
export PATH=/usr/local/opt/ruby/bin:$PATH # Gems
export PATH=/usr/local/instantclient_11_2:$PATH

# see: /usr/libexec/java_home
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

export JRUBY_OPTS="--headless -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1 -J-XX:MaxNewSize=512m -J-Xms2048m -J-Xmx2048m --dev"
# export JRUBY_OPTS="$JRUBY_OPTS -X+O" # added for nokogiri gem
# export JRUBY_OPTS="$JRUBY_OPTS --profile.html --profile.out sms-profile.html"
# export JRUBY_OPTS="$JRUBY_OPTS -J-Xrunhprof:cpu=samples"

unset CATALINA_HOME # do this to get working w/ older ver of Tomcat installed via homebrew
alias cstart='catalina start'
alias cstop='catalina stop'

# For MRI to work with SMS
# https://github.com/CINBCUniversal/sms/wiki/How-to-replatform
export DYLD_LIBRARY_PATH=/opt/oracle/instantclient_11_2
#export OCI_DIR=$DYLD_LIBRARY_PATH
export OCI_DIR=$(brew --prefix)/lib
export NLS_LANG='American_America.UTF8'

# Fix issue w/ oh-my-zsh cursor not being positioned correctly
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export LESS="-RXF" # Colorized, don't clear screen, exit if < 1 pg
setopt rcquotes # Use two single quotes to escape quotes when used inside a string

alias   ll='ls -alGp'
alias   l='ls -alGp'
alias   ag='ag --pager less' 

alias   taildev='ssh -t webuser@smsdev.inbcu.com ''tail -f /opt/www/tomcat/sms/logs/sms.log'''
alias   tailqa='ssh -n webuser@smsqa.inbcu.com ''tail -f /opt/www/tomcat/sms/logs/sms.log'''

alias   vssh='cd ~/workspace/sms ; TERM=xterm-color vagrant ssh ; cd -'

alias   vi='nvim'

alias   gprd='rvm use ruby-2.3.0; ruby ~/scripts/gprd; rvm use jruby-9.1.5.0'
alias   gcb='git rev-parse --abbrev-ref HEAD | pbcopy'

export REMORA_DB_USERNAME=sms_user
export REMORA_DB_PASSWORD=password
export ORACLE_SYSTEM_PASSWORD=password

# Agency Gateway API app env vars
# export PORT=5000
export UNICORN_WORKERS=2

export CLASSPATH=./lib/log4j-1.2.17.jar

# git completion. See: /usr/local/share/zsh/site-functions
fpath=(~/.zsh $fpath)

function bi() {
  bundle install
  rc=$?
  if [[ $rc != 0 ]] then
      say -r 300 -v Thomas 'Bun dull install failed'
  else
      say -r 300 -v Thomas 'Bun dull install done'
  fi
}

# NOTE: Spotlight does not index hidden directories! e.g.: ~/.vim
# THIS SUCKS.
function ff() { 
  mdfind -onlyin . -name $1
  # if [ $? -eq 0 ]; then
    # echo 'Using find ...'
    # # print -l (#i)($1)**/*
    # find . -iname "$1*"
  # fi
}

# Search all jar files in the current directory and below for the given string
# ffjar <pattern>
# Requires GNU parallel and the_silver_searcher
function ffjar() { 
  jars=(./**/*.jar)
  print "Searching ${#jars[*]} jars for '${*}'..."
  parallel --no-notice --tag unzip -l ::: ${jars} | ag ${*} | awk '{print $1, ":", $5}'
}

# Kill all Java processes
function kr() {
  jps | ag Main | awk '{print $1}' | xargs kill
}

# Rails shortcuts
alias   rdbm='rake db:migrate ; say -r 300 DB migrate done'
alias   rc='rails console'
alias   rs='rails s webrick'
alias   rdbms='rake db:migrate:status ; say -r 300 DB status done'

# unalias rc
# function rc() {
  # old_opts=${JRUBY_OPTS}
  # export JRUBY_OPTS="--headless -J-XX:+TieredCompilation -J-XX:TieredStopAtLevel=1 -J-XX:MaxNewSize=512m -J-Xms2048m -J-Xmx2048m --dev"
  # rails console
  # export JRUBY_OPTS=${old_opts}
# }

unalias rails
function rails() {
  bundle check &>/dev/null
  if [[ $? -ne 0 ]]; then
    bundle install
  fi
  _rails_command $@
}

function rsp() {
  bin/rspec --fail-fast --tty $1 
  if [ $? -ne 0 ]; then
    say -r 400 "Tests failed"
  else
    say -r 400 "Tests passed"
  fi
}

# Edit the latest migration
function vilm() {
  a=(db/migrate/*)
  vi -o ${a[@]: -2}
}

bindkey -v # vi mode
bindkey '^R' history-incremental-search-backward

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

###-begin-ng-completion###
#
# ng command completion script
#
# Installation: ng completion 1>> ~/.bashrc 2>>&1
#           or  ng completion 1>> ~/.zshrc 2>>&1
#

ng_opts='b build completion doc e2e g generate get github-pages:deploy gh-pages:deploy h help i init install lint make-this-awesome new s serve server set t test v version -h --help'

build_opts='--aot --base-href --environment --output-path --suppress-sizes --target --watch --watcher -bh -dev -e -o -prod -t -w'
generate_opts='class component directive enum module pipe route service c cl d e m p r s --help'
github_pages_deploy_opts='--base-href --environment --gh-token --gh-username --message --skip-build --target --user-page -bh -e -t'
help_opts='--json --verbose -v'
init_opts='--dry-run inline-style inline-template --link-cli --mobile --name --prefix --routing --skip-bower --skip-npm --source-dir --style --verbose -d -is -it -lc -n -p -sb -sd -sn -v'
new_opts='--directory --dry-run inline-style inline-template --link-cli --mobile --prefix --routing --skip-bower --skip-git --skip-npm --source-dir --style --verbose -d -dir -is -it -lc -p -sb -sd -sg -sn -v'
serve_opts='--aot --environment --host --live-reload --live-reload-base-url --live-reload-host --live-reload-live-css --live-reload-port --open --port --proxy-config --ssl --ssl-cert --ssl-key --target --watcher -H -e -lr -lrbu -lrh -lrp -o -p -pc -t -w'
set_opts='--global -g'
test_opts='--browsers --build --code-coverage --colors --lint --log-level --port --reporters --watch -cc -l -w'

version_opts='--verbose'

if test ".$(type -t complete 2>/dev/null || true)" = ".builtin"; then
  _ng_completion() {
    local cword pword opts

    COMPREPLY=()
    cword=${COMP_WORDS[COMP_CWORD]}
    pword=${COMP_WORDS[COMP_CWORD - 1]}

    case ${pword} in
      ng) opts=$ng_opts ;;
      b|build) opts=$build_opts ;;
      g|generate) opts=$generate_opts ;;
      gh-pages:deploy|github-pages:deploy) opts=$github_pages_deploy_opts ;;
      h|help|-h|--help) opts=$help_opts ;;
      init) opts=$init_opts ;;
      new) opts=$new_opts ;;
      s|serve|server) opts=$serve_opts ;;
      set) opts=$set_opts ;;
      t|test) opts=$test_opts ;;
      v|version) opts=$version_opts ;;
      *) opts='' ;;
    esac

    COMPREPLY=( $(compgen -W '${opts}' -- $cword) )

    return 0
  }

  complete -o default -F _ng_completion ng
elif test ".$(type -w compctl 2>/dev/null || true)" = ".compctl: builtin" ; then
  _ng_completion () {
    local words cword opts
    read -Ac words
    read -cn cword
    let cword-=1

    case $words[cword] in
      ng) opts=$ng_opts ;;
      b|build) opts=$build_opts ;;
      g|generate) opts=$generate_opts ;;
      gh-pages:deploy|github-pages:deploy) opts=$github_pages_deploy_opts ;;
      h|help|-h|--help) opts=$help_opts ;;
      init) opts=$init_opts ;;
      new) opts=$new_opts ;;
      s|serve|server) opts=$serve_opts ;;
      set) opts=$set_opts ;;
      t|test) opts=$test_opts ;;
      v|version) opts=$version_opts ;;
      *) opts='' ;;
    esac

    setopt shwordsplit
    reply=($opts)
    unset shwordsplit
  }

  compctl -K _ng_completion ng
else
  echo "Shell builtin command 'complete' or 'compctl' is redefined; cannot perform ng completion."
  return 1
fi

###-end-ng-completion###

# Done per post-install instructions after doing 'brew install nvm'
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

