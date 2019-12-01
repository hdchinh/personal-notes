---
title: "Basic Vim Setup"
date: 2019-09-20
draft: false
tags: ["TIl"]
categories: ["til"]
mytag: "#TIL"
---

1. Plugin management: https://github.com/junegunn/vim-plug#installation
2. Tree project: https://github.com/scrooloose/nerdtree
3. Code complete: https://github.com/ycm-core/YouCompleteMe#installation
4. Control + P: https://github.com/ctrlpvim/ctrlp.vim
5. Monakai theme: https://github.com/sickill/vim-monokai
6. Vimfile:

```vim
call plug#begin('~/.vim/plugged')

Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdcommenter'
" Plug 'dracula/vim', { 'as': 'dracula' }

" Initialize plugin system
call plug#end()

" Set colorscheme
" colorscheme gruvbox

" Set dark background
"set background=dark

" Use monokai
" syntax enable
colorscheme monokai

" Copy clibboard
set clipboard=unnamedplus

" Use ctrlp
set runtimepath^=~/.vim/bundle/ctrlp.vim

if has('mouse')
  set mouse=a
endif

set nu

set autoindent
set si "smart indent"

syntax on

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-n> :NERDTreeToggle<CR>

set expandtab
set tabstop=2
set softtabstop=2

```
