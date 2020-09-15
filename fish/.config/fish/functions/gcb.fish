# copy current branch into pasteboard
function gcb
  git rev-parse --abbrev-ref HEAD | tr -d '\n' | pbcopy
end
