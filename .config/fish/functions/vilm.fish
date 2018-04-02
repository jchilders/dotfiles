function vilm
  set -l migs (ls db/migrate/*)
  vi -o $migs[-1..-2]
end
