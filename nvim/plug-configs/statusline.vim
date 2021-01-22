set statusline =%#identifier#
set statusline+=[%t]    "tail of the filename (extension)
set statusline+=%*
set statusline+=%y      "filetype
set statusline+=%#identifier#
set statusline+=%r
set statusline+=%*
set statusline+=%#identifier#
set statusline+=%m
set statusline+=%*
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

" always display status line
set laststatus=2
