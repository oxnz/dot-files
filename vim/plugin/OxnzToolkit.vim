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
" 1. add control option for autocmds
" 3. use dict to save user config
"
" Use:
" - Type OxnzHeader to generate header by filetype
" - Type OxnzModeLine to generate vim mode line



if v:version < 700
	finish
endif

" Verify if already loaded
if exists("g:loaded_OxnzToolkit")
	echo 'OxnzToolkit Already Loaded.'
	finish
endif
let g:loaded_OxnzToolkit = '0.1.1'

function! <SID>OxnzInsertGuardFunc()
	let l:fname = expand("%:t")
	let l:fname = toupper(l:fname)
	let l:fname = substitute(l:fname, "\\.", "_", "g")
	let l:fname = "_" . l:fname . "_"
	call append(line("$"), ["\#ifndef " . l:fname,
				\ "\#define " . l:fname,
				\ "",
				\ "\#endif//" . l:fname
				\ ])
endfunction

""""""""""""""""""""""""""""""""""""""""""""
" Insert Header by Filetype
""""""""""""""""""""""""""""""""""""""""""""
function! <SID>OxnzInsertHeaderFunc()
	if &filetype == 'sh'
		call setline(1, "\#!/bin/bash")
		call append(line("."), "\# Author: Oxnz")
		call append(line(".")+1, "")
	endif
	if (&filetype == 'c' || &filetype == 'cpp' || &filetype == 'java' ||
				\ &filetype == 'php')
		call setline(1, [
					\ "/*",
					\ "     Filename: " . expand("%:t"),
					\ "  Description: ",
					\ "",
					\ "      Version: 0.1",
					\ "      Created: " . strftime("%F %T"),
					\ "  Last-update: " . strftime("%F %T"),
					\ "     Revision: None",
					\ "",
					\ "       Author: " . g:OxnzToolkit_Author,
					\ "        Email: " . g:OxnzToolkit_Email,
					\ "",
					\ "Revision history:",
					\ "\tDate Author Remarks",
					\ "*/",
					\ ])
		exec "normal G"
	endif
	if &filetype == 'python'
		call setline(1, ["\#!/usr/bin/env python",
					\ "\#coding: utf-8",
					\ "",
					\ "\"\"\"one line abstract",
					\ "",
					\ "detail:\"\"\"",
					\ "",
					\ "__author__ = \"" . g:OxnzToolkit_Author . "\"",
					\ "__version__ = 0.1",
					\ "",
					\ "",
					\ ])
	endif
	exec "normal G"
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""
" Update time stamp
"""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>OxnzUpdateTimeStampFunc()
	let l:lineno = search("Last-update:", "n")
	if l:lineno
		let l:line = getline(l:lineno)
		echom l:lineno
		let l:line = substitute(l:line,
					\ "\\d\\{4\\}-\\d\\{2\\}-\\d\\d \\d\\d:\\d\\d:\\d\\d$",
					\ strftime("%F %T"), "")
					\ "  Last-update: " . strftime("%F %T"),
		call setline(l:lineno, l:line)
	endif
endfunction
"""""""""""""""""""""""""""""""""""""""""""""""
" Append Vim Mode Line
"""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>OxnzAppendModeLineFunc()
	let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
				\ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
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
	:silent! g/^\n\{2,}/d
endfunction

""""""""""""""""""""""""""""""""""""""""""""""
" Delete Blank Lines
""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>OxnzDeleteBlankLinesFunc()
	:silent! g/^\s*$/d
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
	call <SID>OxnzUniqueBlankLinesFunc()
	call <SID>OxnzDeleteBlankLinesFunc()
endfunction

"""""""""""""""""
" Shortcuts...
"""""""""""""""""
""" commands {{{
command! -nargs=0 OxnzModeLine	:call <SID>OxnzAppendModeLineFunc()
command! -nargs=0 OxnzHeader	:call <SID>OxnzInsertHeaderFunc()
command! -nargs=0 OxnzInsertLineNumbers	:call <SID>OxnzInsertLineNumbersFunc()
command! -nargs=0 OxnzDeleteLineNumbers :call <SID>OxnzDeleteLineNumbersFunc()
command! -nargs=0 OxnzDeleteLeadingSpaces
			\ :call <SID>OxnzDeleteLeadingSpacesFunc()
command! -nargs=0 OxnzDeleteTrailingSpaces
			\ :call <SID>OxnzDeleteTrailingSpacesFunc()
command! -nargs=0 OxnzUniqueBlankLines	:call <SID>OxnzUniqueBlankLinesFunc()
command! -nargs=0 OxnzDeleteBlankLines	:call <SID>OxnzDeleteBlankLinesFunc()
command! -nargs=0 OxnzTrim		:call <SID>OxnzTrimFunc()
command! -nargs=0 OxnzTest		:call <SID>OxnzTestFunc()
" }}}
"按\ml,自动插入modeline
"nnoremap <silent> <Leader>ml	:call OxnzModeLine() <CR>

if has("autocmd")
	augroup OxnzToolkitEx
	au!
		autocmd BufNewFile * call <SID>OxnzInsertHeaderFunc()
		autocmd BufNewFile *.h call <SID>OxnzInsertGuardFunc()
		autocmd BufWrite *.* call <SID>OxnzUpdateTimeStampFunc()
	augroup END
endif
