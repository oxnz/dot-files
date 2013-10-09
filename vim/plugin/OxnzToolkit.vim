" File: OxnzToolkit.vim
" Description: insert header depends on filetype, insert mode line
"
" Author: Oxnz
" Version: 0.1.1
" Date: Wed Oct  9 13:53:09 CST 2013
" Copying: Copyright (C) 2013 oxnz, All rights reserved
"
" Feature:
" - generate headers
" - insert line numbers
" - remove line numbers
" - delete leading spaces
" - delete trailing spaces
" - unique blank lines
"
" TODO:
" 1. add config option for author, email, etc.
"
" Use:
" - Type OxnzHeader to generate header by filetype
" - Type OxnzModeLine to generate vim mode line

" Verify if already loaded
if exists("loaded_OxnzToolkit")
	echo 'OxnzToolkit Already Loaded.'
	finish
endif
let loaded_OxnzToolkit = '0.1.1'

function! <SID>OxnzInsertHeaderFunc()
	if &filetype == 'sh'
		call setline(1, "\#!/bin/bash")
		call append(line("."), "\# Author: Oxnz")
		call append(line(".")+1, "")
	endif
	if &filetype == 'c'
		call setline(1, "\/*******")
	endif
	if &filetype == 'python'
		call setline(1, "\#!/usr/bin/env python")
		call append(line("."), "\#coding: utf-8")
		call append(line(".")+1, "\#Author: Oxnz")
		call append(line(".")+2, "")
		let l:timestamp = printf("\#Last-update: %s",
					\ strftime("%F %T"))
		call append(line(".")+3, l:timestamp)
	endif
	exec "normal G"
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""
" Append Vim Mode Line
"""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>OxnzAppendModeLineFunc()
	let l:modeline = printf("vim: set ts=%d sw=%d tw=%d :",
				\ &tabstop, &shiftwidth, &textwidth)
	let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
	call append(line("$"), l:modeline)
endfunction

"""""""""""""""""""""""""
" Insert Line Numbers
"""""""""""""""""""""""""
function! <SID>OxnzInsertLineNumbersFunc()
	let l:num=1
	let l:end = line("$")
	:1
	while l:num <= l:end
		let l:tmp = l:num . " " . getline(".")
		call setline(".", l:tmp)
		+
		let l:num = l:num+1
	endwhile
endfunction
"""""""""""""""""""""""""
" Delete Line Numbers
"""""""""""""""""""""""""
function <SID>OxnzDeleteLineNumbersFunc()
	let l:num=1
	let l:end = line("$")
	:1
	while l:num <= l:end
		let l:line = getline(".")
		let l:tmp = substitute(l:line, "^\\d\\+ ", "", "")
		call setline(".", l:tmp)
		+
		let l:num = l:num + 1
	endwhile
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""
" Delete Leading White Spaces
""""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>OxnzDeleteLeadingSpacesFunc()
	try
		:%s/^\s\+//
	catch /^Vim\%((\a\+)\)\=:E486/
		echo "No more leading space exists"
	endtry
	":silent! %s/^\s\+//
endfunction
""""""""""""""""""""""""""""""""""""""""""""""""
" Delete Trailing White Spaces
""""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>OxnzDeleteTrailingSpacesFunc()
	try
		:%s/\s\+$//
	catch /^Vim\%((\a\+)\)\=:E486/
		echo "No more trailing space exists"
	endtry
endfunction
""""""""""""""""""""""""""""""""""""""""""""
" Remove Extra Blank Lines, Only Leave One
""""""""""""""""""""""""""""""""""""""""""""
function! <SID>OxnzUniqueBlankLinesFunc()
	":silent! g/^\n\{2,}/d
	:g/^\n\{2,}/d
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Trim Leading, Trailing Spaces and Also Unique Blank Lines
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>OxnzTrimFunc()
	call <SID>OxnzDeleteLeadingSpacesFunc()
	call <SID>OxnzDeleteTrailingSpacesFunc()
	call <SID>OxnzUniqueBlankLinesFunc()
endfunction
""""""""""""""""""""""""""""""
" Test Function
""""""""""""""""""""""""""""""
function! <SID>OxnzTestFunc()
endfunction

"""""""""""""""""
" Shortcuts...
"""""""""""""""""
command! -nargs=0 OxnzModeLine	:call <SID>OxnzAppendModeLineFunc()
command! -nargs=0 OxnzHeader	:call <SID>OxnzInsertHeaderFunc()
command! -nargs=0 OxnzInsertLineNumbers	:call <SID>OxnzInsertLineNumbersFunc()
command! -nargs=0 OxnzDeleteLineNumbers :call <SID>OxnzDeleteLineNumbersFunc()
command! -nargs=0 OxnzDeleteLeadingSpaces
			\ :call <SID>OxnzDeleteLeadingSpacesFunc()
command! -nargs=0 OxnzDeleteTrailingSpaces
			\ :call <SID>OxnzDeleteTrailingSpacesFunc()
command! -nargs=0 OxnzUniqueBlankLines	:call <SID>OxnzUniqueBlankLinesFunc()
command! -nargs=0 OxnzTrim		:call <SID>OxnzTrimFunc()
command! -nargs=0 OxnzTest		:call <SID>OxnzTestFunc()
"按\ml,自动插入modeline
"nnoremap <silent> <Leader>ml	:call OxnzModeLine() <CR>
