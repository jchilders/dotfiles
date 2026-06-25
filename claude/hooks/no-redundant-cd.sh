#!/usr/bin/env bash
# PreToolUse(Bash) hook: block a leading `cd <cwd>` into the directory the Bash
# tool already runs in. The working directory persists between Bash calls, so
# `cd` into the current working directory is redundant and just wastes tokens
# (and can trigger permission prompts). cd into a *subdirectory* is allowed.
set -euo pipefail

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')
[ -z "$cwd" ] && cwd="$PWD"

# Trim leading whitespace.
trimmed="${cmd#"${cmd%%[![:space:]]*}"}"

# Escape regex metacharacters in the cwd path for use in an ERE.
esc=$(printf '%s' "$cwd" | sed 's/[][\.^$*+?(){}|/]/\\&/g')

# Match `cd <cwd>` (optionally quoted / trailing slash) when it's the whole
# command or is immediately followed by a separator (; && || |). This leaves
# `cd <cwd>/subdir ...` untouched.
if printf '%s' "$trimmed" | grep -Eq "^cd[[:space:]]+\"?${esc}/?\"?[[:space:]]*(\$|;|&&|\|\||\|)"; then
  echo "Redundant 'cd ${cwd}': the Bash tool already runs in this directory and the working directory persists between calls. Drop the leading 'cd' and re-run the rest of the command." >&2
  exit 2
fi

exit 0
