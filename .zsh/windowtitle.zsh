# Auto-Set window title to currently running program

function title {
  if [[ $TERM == "screen" ]]; then
    # Use these two for GNU Screen:
    print -nR $'\033k'$1$'\033'\\\

    print -nR $'\033]0;'$2$'\a'
  elif [[ $TERM == "xterm" || $TERM == "rxvt" || $TERM == "xterm-color" ]]; then
    # Use this one instead for XTerms:
    print -nR $'\033]0;'$*$'\a'
  fi
}
  
function precmd {
  title zsh "$PWD"
}

preexec() {
  emulate -L zsh
  local -a cmd; cmd=(${(z)1})             # Re-parse the command line
  
  # Construct a command that will output the desired job number.
  case $cmd[1] in
      fg)
        if (( $#cmd == 1 )); then
          # No arguments, must find the current job
          cmd=(builtin jobs -l %+)
        else
          # Replace the command name, ignore extra args.
          cmd=(builtin jobs -l ${(Q)cmd[2]})
        fi;;
       %*) cmd=(builtin jobs -l ${(Q)cmd[1]});; # Same as "else" above
       exec) shift cmd;& # If the command is 'exec', drop that, because
          # we'd rather just see the command that is being
          # exec'd. Note the ;& to fall through.
       *)  title $cmd[1]:t "$cmd[2,-1]"    # Not resuming a job,
          return;;                        # so we're all done
      esac
  
  local -A jt; jt=(${(kv)jobtexts})       # Copy jobtexts for subshell
  
  # Run the command, read its output, and look up the jobtext.
  # Could parse $rest here, but $jobtexts (via $jt) is easier.
  $cmd >> (read num rest
          cmd=(${(z)${(e):-\$jt$num}})
          title $cmd[1]:t "$cmd[2,-1]") 2 > /dev/null
}


