set nocompatible

" Setup Vundle:
"   gtcl https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
if isdirectory(expand('~/.vim/bundle/Vundle.vim'))
  filetype off

  set rtp+=~/.vim/bundle/Vundle.vim
  let vimdir = '~/.vim/bundle'
  if has('win32unix')
    " Use mixed path on Cygwin so that Windows git works
    let vimdir = substitute(system('cygpath -m ' . vimdir), '\n\+$', '', '')
  endif

  call vundle#begin(vimdir)

  Plugin 'VundleVim/Vundle.vim'

  " Plugins
  Plugin 'git://github.com/inkarkat/vim-ingo-library'
  Plugin 'git://github.com/inkarkat/vim-mark'
  Plugin 'git://github.com/luochen1990/rainbow'
  let g:rainbow_active = 1

  call vundle#end()
endif

filetype plugin on 
syntax enable

set ruler
set vb
set nohlsearch
set noincsearch
set nodigraph
set nowrapscan
set wrap
set showmatch
set background=dark 
set scrolloff=3
"set number
"set paste
set complete-=i  "Too slow...

set noerrorbells
set visualbell
set t_vb=

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

" Autocomplete menu
set wildmenu

" Highlight current line
set cursorline

" Highlight 80 columns
au BufReadPost,BufNewFile *
  \ if &ft=~'^\(c\|cpp\|java\|python\|perl\|vim\|sh\)$' |
  \ set colorcolumn=80 | endif

" File explorer
let g:netrw_banner=0
let g:netrw_liststyle= 3
let g:netrw_preview=1
let g:netrw_alto=0

" Use syntax folds
set foldmethod=syntax
set nofoldenable

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

" Abbreviations
iabbrev binsh #!/bin/sh<CR><CR>set -euo pipefail<CR>set -x<CR>
iabbrev binpl #!/usr/bin/perl<CR><CR>use strict;<CR>use warnings;<CR><CR>
