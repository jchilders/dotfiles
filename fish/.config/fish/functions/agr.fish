# Replace string in current directory
#
# > arg OldString NewString
function agr
  echo "replacing string $argv[1] with $argv[2]"
  ag -0 -l "$argv[1]" | xargs -0 perl -pi.bak -e "s/$argv[1]/$argv[2]/g";
end
