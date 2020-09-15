function ff --description 'Find files matching given string'
  # --prune don't print empty dirs
  # -P match pattern
  # -I ignore pattern
  # --matchdirs if dirs match pattern, print the directory's contents
  # -i No indentation
  # -f Print full path prefix
  # -p print file type/perms
  tree . --prune --matchdirs -P "*$argv*" -I "webpack" -i -f --ignore-case -p |
    ag '\[[^d].*' |
    awk '{print $2}'
end
