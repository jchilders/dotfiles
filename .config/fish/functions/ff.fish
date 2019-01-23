function ff --description 'Find files matching given string'

  argparse -n ff 'h/hidden' -- $argv
  or return

  if set -q _flag_h
    set -g matches ( find . \( -type d \) -o -type f \
      | sed -n -e 's/^\.\///p' )
  else
    # Ignore .git directories.
    set -g matches ( find . \( -name .git -type d -prune \) -o -type f \
      | sed -n -e '/^\.\/\.git$/n' -e 's/^\.\///p' )
  end
  set -g sorted ( string split $matches \
    | ag $argv \
    | sort )

  if test (count $sorted) -gt 0
    printf '%s\n' $sorted
  end
  printf '%i results\n' (count $sorted)
end
