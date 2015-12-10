set nocompatible

syntax enable

set ruler
set vb
set nohlsearch
set nodigraph
set nowrapscan
set wrap
set showmatch
set background=dark 
set scrolloff=3
"set number
"set paste

set novisualbell
set noerrorbells

set lazyredraw
set ttyfast

set nobackup

set history=10000

set listchars+=precedes:<,extends:>
set sidescroll=5
set sidescrolloff=5

set iskeyword=@,48-57,_,!,#,$,%

imap <C-U> <Left>
imap <C-J> <Down>
imap <C-K> <Up>
imap <C-L> <Right>
imap <C-0> <Home> 

vmap <C-U> <Left>
vmap <C-J> <Down>
vmap <C-K> <Up>
vmap <C-L> <Right>

"Help
imap <F1> <Esc>:h<CR>
nmap <F1> :h<CR>

"Save current buffer
imap <F2> <Esc>:w!<CR>a
nmap <F2> :w!<CR>

"Save all buffers 
imap <S-F2> <Esc>:wa!<CR>a
nmap <S-F2> :wa!<CR>

"Dictionary (install wamerican)

set dictionary=/usr/share/dict/words
imap <F3> <Esc>:set complete+=k<CR>a
map <F3> :set complete+=k<CR>
imap <F4> <Esc>:set complete-=k<CR>a
map <F4> :set complete-=k<CR>

nmap <F5> :prev<CR>
imap <F5> <Esc>:prev<CR>a
nmap <F6> :next<CR>
imap <F6> <Esc>:next<CR>a

nmap <F7> <C-W>k<C-W>_
imap <F7> <Esc><C-W>k<C-W>_a
nmap <F8> <C-W>j<C-W>_
imap <F8> <Esc><C-W>j<C-W>_a

"Compile results
imap <S-F9> <Esc>:copen<CR>
nmap <S-F9> :copen<CR>

"Save and exit
map <F10> <Esc>:x<CR>
imap <F10> <Esc>:x<CR>
map <S-F10> <Esc>:xa<CR>
imap <S-F10> <Esc>:xa<CR>

"Discard and exit
map <F11> <Esc>:q!<CR>
imap <F11> <Esc>:q!<CR>
map <S-F11> <Esc>:qa!<CR>
imap <S-F11> <Esc>:qa!<CR>

if &term == "cygwin"
    set t_kD=[3~
endif
set backspace=indent,eol,start

highlight StatusLine cterm=bold ctermfg=white ctermbg=blue

" Enable plugins
set nocp
filetype plugin on 

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

