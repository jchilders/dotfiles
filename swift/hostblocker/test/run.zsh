#!/usr/bin/env zsh
# Characterization harness for hostblocker. Runs every scenario against one
# implementation in a sandbox (fake sudo/pfctl/dig/launchctl/etc. on PATH, fake
# /etc/hosts and /Library/LaunchDaemons under $HOSTBLOCKER_ROOT) and records
# stdout, stderr, exit code, the log of external commands, and final state.
#
# Usage: run.zsh <outdir> <command...>
#   run.zsh out/current ../.build/hostblocker
#
# check.zsh compares a build against the recorded results in golden/.
#
# Nothing here touches the real system: the fake sudo refuses real /etc and
# /Library paths, and pfctl/launchctl/dscacheutil/killall are fakes.

emulate -L zsh
setopt err_exit no_unset pipe_fail

HERE=${0:A:h}
OUT=${1:?usage: run.zsh <outdir> <command...>}; shift
IMPL=("$@")
(( $#IMPL )) || { print -u2 "usage: run.zsh <outdir> <command...>"; exit 2 }
OUT=${OUT:A}
SB=$HERE/.sandbox # same path for every implementation, so outputs compare
SHIMS=$HERE/shims

rm -rf $OUT && mkdir -p $OUT

HOSTS_SEED='##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1	localhost
255.255.255.255	broadcasthost
::1             localhost
'

DNS_SEED='reddit.com A 151.101.1.140
reddit.com A 151.101.65.140
reddit.com AAAA 2a04:4e42::396
www.reddit.com CNAME reddit.map.fastly.net.
www.reddit.com A 151.101.1.140
www.reddit.com A 151.101.129.140
news.ycombinator.com A 209.216.230.207
v6only.example AAAA 2001:db8::1
o'"'"'reilly.com A 10.0.0.1
'

# Fresh sandbox for a scenario. Blocklist content is $1 ("-" for no file).
function setup {
  local blocklist=$1
  rm -rf $SB
  mkdir -p $SB/{home/.config/hostblocker,home/.local/share,root/etc,root/Library/LaunchDaemons,state,fixtures}
  print -rn -- $HOSTS_SEED > $SB/root/etc/hosts
  print -rn -- $DNS_SEED > $SB/fixtures/dns
  [[ $blocklist == - ]] || print -rn -- $blocklist > $SB/home/.config/hostblocker/blocked-domains
  : > $SB/state/log
  STEP=0
}

# step <label> [VAR=value...] -- <args...>
function step {
  local label=$1; shift
  local -a extra_env
  while [[ $1 != -- ]]; do extra_env+=($1); shift; done
  shift
  local dir=$OUT/$SCENARIO
  mkdir -p $dir
  local base=$dir/$(( ++STEP ))-$label
  print -r -- "== step $STEP $label: $*" >> $SB/state/log
  local rc=0
  env -i \
    HOME=$SB/home \
    XDG_CONFIG_HOME=$SB/home/.config \
    XDG_DATA_HOME=$SB/home/.local/share \
    HOSTBLOCKER_ROOT=$SB/root \
    PATH=$SHIMS:/usr/bin:/bin:/usr/sbin:/sbin \
    HB_LOG=$SB/state/log HB_STATE=$SB/state HB_FIXTURES=$SB/fixtures \
    EDITOR=editor \
    $extra_env \
    $IMPL "$@" > $base.out 2> $base.err < /dev/null || rc=$?
  print $rc > $base.rc
}

# Record end-of-scenario state. Server artifacts differ by design (Ruby writes
# server.rb and runs it with its own interpreter; Swift installs itself), so
# the plist's ProgramArguments and the server file are recorded separately.
function snapshot {
  local dir=$OUT/$SCENARIO
  mkdir -p $dir
  # SQL embeds unix timestamps; normalize them
  perl -pe 's/\b1\d{9}\b/<TS>/g' $SB/state/log > $dir/log
  cp $SB/root/etc/hosts $dir/hosts
  [[ -f $SB/state/pf_table ]] && cp $SB/state/pf_table $dir/pf_table
  [[ -f $SB/state/pf_rules ]] && cp $SB/state/pf_rules $dir/pf_rules
  local plist=$SB/root/Library/LaunchDaemons/local.hostblocker.plist
  if [[ -f $plist ]]; then
    # ProgramArguments differ by design; keep everything else
    perl -0pe 's{(<key>ProgramArguments</key>\s*<array>).*?(</array>)}{$1 ARGS $2}s' $plist > $dir/plist
    perl -0ne 'print $1 if m{<key>ProgramArguments</key>\s*<array>(.*?)</array>}s' $plist > $dir/plist.args
  fi
  local db=$SB/home/.local/share/hostblocker/dns_cache.db
  if [[ -f $db ]]; then
    # timestamps vary run to run; record whether each is recent instead
    local table=$(/usr/bin/sqlite3 $db "SELECT name FROM sqlite_master WHERE type = 'table' AND name LIKE 'dns_cache%';")
    /usr/bin/sqlite3 $db "SELECT domain, ips, (strftime('%s','now') - timestamp) < 120 FROM $table ORDER BY domain;" > $dir/dns_cache
    /usr/bin/sqlite3 $db ".schema" > $dir/dns_cache.schema
  fi
  (cd $SB/home && find . -type f | sort) > $dir/files
}

# ---- scenarios --------------------------------------------------------------

SCENARIO=s01_usage
setup $'reddit.com\n'
step noargs --
step bogus -- frobnicate
step extra-args -- status extra
snapshot

SCENARIO=s02_missing_blocklist
setup -
step status -- status
step enable -- enable
step reload -- reload
step disable -- disable
snapshot

SCENARIO=s03_lifecycle
setup $'reddit.com\nwww.reddit.com\nnews.ycombinator.com\n'
step enable -- enable
step enable-again -- enable
step status -- status
step reload -- reload
step status -- status
step disable -- disable
step status -- status
step enable-after-disable -- enable
snapshot

SCENARIO=s04_color
setup $'reddit.com\nnxdomain.example\n'
step enable-clicolor CLICOLOR_FORCE=1 -- enable
step status-force FORCE_COLOR=1 -- status
step status-nocolor NO_COLOR=1 CLICOLOR_FORCE=1 -- status
step status-nocolor-empty NO_COLOR= CLICOLOR_FORCE=1 -- status
step usage-clicolor CLICOLOR_FORCE=1 --
step disable-clicolor CLICOLOR_FORCE=1 -- disable
step status-disabled-color CLICOLOR_FORCE=1 -- status
snapshot

SCENARIO=s05_no_ips
setup $'nxdomain.example\nv6only.example\n'
step enable -- enable
step status -- status
snapshot

SCENARIO=s06_existing_hosts_section
setup $'reddit.com\n'
print -rn -- $'127.0.0.1\tlocalhost\n\n# hostblocker-start\n127.0.0.1 old.example\n# hostblocker-end\n\n10.0.0.5 nas.local\n# hostblocker-start\n127.0.0.1 older.example\n# hostblocker-end' > $SB/root/etc/hosts
step enable -- enable
cp $SB/root/etc/hosts $OUT/$SCENARIO/hosts.after-enable
step disable -- disable
snapshot

SCENARIO=s07_pf_load_fail
setup $'reddit.com\n'
step enable HB_PF_FAIL=load -- enable
snapshot

SCENARIO=s08_pf_replace_fail
setup $'reddit.com\n'
step enable HB_PF_FAIL=replace -- enable
snapshot

SCENARIO=s09_sqlite_fail
setup $'reddit.com\n'
step enable HB_SQLITE_FAIL=1 -- enable
snapshot

SCENARIO=s10_cache_ttl
setup $'reddit.com\nnews.ycombinator.com\n'
step enable -- enable
/usr/bin/sqlite3 $SB/home/.local/share/hostblocker/dns_cache.db \
  "UPDATE $(/usr/bin/sqlite3 $SB/home/.local/share/hostblocker/dns_cache.db "SELECT name FROM sqlite_master WHERE type = 'table' AND name LIKE 'dns_cache%';") SET timestamp = strftime('%s','now') - 86401 WHERE domain = 'reddit.com';"
step enable-expired -- enable
snapshot

SCENARIO=s11_plist_preinstalled
setup $'reddit.com\n'
print -r -- '<plist>preinstalled</plist>' > $SB/root/Library/LaunchDaemons/local.hostblocker.plist
step enable -- enable
step disable -- disable
snapshot

SCENARIO=s12_edit_config
setup -
rm -rf $SB/home/.config/hostblocker
step edit -- edit-config
step edit-args EDITOR='editor --wait "two words"' -- edit-config
step edit-empty EDITOR= -- edit-config
snapshot

SCENARIO=s13_blocklist_changes
setup $'reddit.com\n'
step enable -- enable
print -r -- news.ycombinator.com >> $SB/home/.config/hostblocker/blocked-domains
step enable-added -- enable
print -r -- reddit.com > $SB/home/.config/hostblocker/blocked-domains
step enable-removed -- enable
snapshot

SCENARIO=s14_blocklist_formatting
setup $'# comment\n\n  reddit.com  \r\n\t# indented comment\n\to\'reilly.com\nreddit.com\n   \nnews.ycombinator.com\na-very-long-subdomain.nxdomain.example'
step enable -- enable
step status -- status
snapshot

# Machine-independent results: the sandbox path depends on where the repo is
SB=$SB perl -pi -e 's/\Q$ENV{SB}\E/<SANDBOX>/g' $OUT/**/*(.)

print "wrote $OUT"
