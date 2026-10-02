#!/usr/bin/env zsh
# Run the harness against the Ruby reference (bin/hostblocker with its two
# system paths made sandboxable) and a Swift build, then diff the results.
#
# Usage: compare.zsh [swift-binary]   (default: ../.build/hostblocker)

emulate -L zsh
setopt err_exit no_unset pipe_fail

HERE=${0:A:h}
REPO=${HERE:h:h:h}
SWIFT_BIN=${1:-$HERE/../.build/hostblocker}
OUT=$HERE/out
mkdir -p $OUT

# The only changes to the reference: /etc/hosts and the daemon plist path get
# the same $HOSTBLOCKER_ROOT prefix the Swift version honors.
ref=$OUT/hostblocker.rb
sed \
  -e "s|^  HOSTS_PATH = '/etc/hosts'\$|  HOSTS_PATH = \"#{ENV.fetch('HOSTBLOCKER_ROOT', '')}/etc/hosts\"|" \
  -e 's|^  DAEMON_PLIST_PATH = "/Library/LaunchDaemons/#{DAEMON_LABEL}.plist"$|  DAEMON_PLIST_PATH = "#{ENV.fetch('"'HOSTBLOCKER_ROOT'"', '"''"')}/Library/LaunchDaemons/#{DAEMON_LABEL}.plist"|' \
  $REPO/bin/hostblocker > $ref
if (( $(diff $REPO/bin/hostblocker $ref | grep -c '^>') != 2 )); then
  print -u2 "reference sed did not change exactly 2 lines"; exit 1
fi

# absolute path: run.zsh resets PATH, which would find the old system ruby
$HERE/run.zsh $OUT/ruby $(command -v ruby) $ref
$HERE/run.zsh $OUT/swift $SWIFT_BIN

# plist.args and server files differ by design; everything else must match
if diff -r -x plist.args -x files $OUT/ruby $OUT/swift; then
  print "PASS: Swift matches Ruby on all scenarios"
else
  print -u2 "FAIL: differences above (< ruby, > swift)"
  exit 1
fi
