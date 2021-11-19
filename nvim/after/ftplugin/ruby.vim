set softtabstop=2
set shiftwidth=2

nnoremap <Leader>bp obinding.pry<ESC>:w<ENTER>
nnoremap <Leader>bP Obinding.pry<ESC>:w<ENTER>
nnoremap <Leader>rp oputs "-=-=> #{self.class}##{__method__}:#{__LINE__}\n\t-> "<ESC>i
nnoremap <Leader>rP Oputs "-=-=> #{self.class}##{__method__}:#{__LINE__}\n\t-> "<ESC>i
