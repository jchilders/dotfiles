#!/usr/bin/env zsh
# Regression check: run the harness against a build and diff with the recorded
# results in golden/. After an intended behavior change, review the diff, then
# re-record with: check.zsh --record
#
# Usage: check.zsh [--record] [binary]   (default binary: ../.build/hostblocker)

emulate -L zsh
setopt err_exit no_unset pipe_fail

HERE=${0:A:h}
record=0
if [[ ${1:-} == --record ]]; then record=1; shift; fi
BIN=${1:-$HERE/../.build/hostblocker}

$HERE/run.zsh $HERE/out/current $BIN > /dev/null
# The installed server copy is this binary; which files exist is what matters
if (( record )); then
  rm -rf $HERE/golden && cp -R $HERE/out/current $HERE/golden
  print "recorded $HERE/golden"
elif diff -r $HERE/golden $HERE/out/current; then
  print "PASS: matches golden/"
else
  print -u2 "FAIL: differences above (< golden, > current)"
  exit 1
fi
