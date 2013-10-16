"===============================================================================
" Filename	: .vimrc
" Author	: 0xnz
" Version	: 0.2
" Email		: <yunxinyi AT gmail DOT com>
" Created	: 2010-03-20 18:00:12
" Copying	: Copyright (C) 2013 0xnz, All rights reserved.
"
" Last-update: 2013-10-16 15:06:30
"
" Description: vimrc compatible for Linux/Windows/OSX, GUI/Console
"-------------------------------------------------------------------------------


" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set fenc=utf-8 		" set file encoding

set confirm			" 在处理未保存或只读文件的时候，弹出确认 

set iskeyword+=_,$,@,%,#,- " 带有如下符号的单词不要被换行分割 
"set nobackup		" do not keep a backup file, use versions instead
set backupdir=~/.vim/backup
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set rulerformat=%20(%2*%<%f%=\ %m%r\ %3l\ %c\ %p%%%) 
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set incsearch		" do incremental searching
"set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set smarttab		" Be smart when using tabs
"set nowrap			" Don't wrap lines
"set spell			" Do spell check, type `z=` to see advice
set lazyredraw		" Don't redraw while executing macros (for good performance)

"set autowrite		" Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" Set font according to system
"if has("unix")
"	set gfn=Menlo:h15
"elseif has("win16") || has("win32")
"	set gfn=Bitstream\ Vera\ Sans\ Mono:h11
"elseif has("linux")
"	set gfn=Monospace\ 11
"endif
" 状态行颜色 
highlight StatusLine guifg=SlateBlue guibg=Yellow 
highlight StatusLineNC guifg=Gray guibg=White 
set wildmenu		" 增强模式中的命令行自动完成操作 
" Ignore compiled files
set wildignore=*.o,*.obj,*.class,*.pyc,.DS_Store
" 在被分割的窗口间显示空白，便于阅读 
set fillchars=vert:\ ,stl:\ ,stlnc:\ 
"set nowrapscan " 禁止在搜索到文件两端时重新搜索

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " Do spell check for LaTeX files
  autocmd FileType tex setlocal spell spelllang=en
  autocmd FileType plaintext setlocal spell spelllang=en
  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" setlocal使set的效果只对当前buffer有效，不会影响到打开的其它文件。
" expandtab = et smarttab=sta sw=shiftwidth sts=softtabstop
set sw=4
set ts=4
autocmd FileType python setlocal et sta sw=4 sts=4

set foldmethod=syntax
set foldlevel=99

set modeline

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark
colorscheme default
"colorscheme molokai

"-----------------------------------------------------------------
" plugin - DoxygenToolkit.vim 由注释生成文档，并且能够快速生成函数标准注释
"-----------------------------------------------------------------
"let g:DoxygenToolkit_briefTag_pre="@Synopsis"
"let g:DoxygenToolkit_paramTag_pre="@Param"
"let g:DoxygenToolkit_returnTag_pre="@Returns"
let g:DoxygenToolkit_briefTag_funcName="yes"
let g:DoxygenToolkit_blockHeader="---------------------------------------------"
let g:DoxygenToolkit_blockFooter="---------------------------------------------"
let g:DoxygenToolkit_authorName="0xnz - <yunxinyi AT gmail DOT com>"
let g:DoxygenToolkit_versionString = "0.1"
let g:DoxygenToolkit_licenseTag="MIT License"

"空格展开折叠  
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

""""""""""""""""""""""""""
" plugin - OxnzToolkit
""""""""""""""""""""""""""
let g:OxnzToolkit_Author="Oxnz"
let g:OxnzToolkit_Email = "yunxinyi@gmail.com"
