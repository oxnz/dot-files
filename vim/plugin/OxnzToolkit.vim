" File: OxnzToolkit.vim
" Description: insert header depends on filetype, insert mode line
"
" Author: Oxnz
" Version: 0.1.1
" Date: Wed Oct  9 13:53:09 CST 2013
" License: 
" Copyright (c) 2013 Oxnz
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.
"
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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Exit if already loaded
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("g:OxnzToolkitVersion")
	echohl ErrorMsg
	echo 'Error: OxnzToolkit Already Loaded'
	echohl None
	finish
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display Error Message
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzTemplateKitErrMsgFunc(msg)
    echohl ErrorMsg
    echo 'Warning: ' . a:msg
    echohl None
endfunction

function <SID>OxnzTemplateKitWarnFunc(msg)
    echohl WarningMsg
    echo 'Error: ' . a:msg
    echohl None
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" test if "compatible" mode set
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &compatible
	" To use this plugin, :set nocompatible
	" or just create an empty .vimrc file
	call <SID>OxnzTemplateKitErrMsgFunc('OxnzToolkit requires no compatible')
	finish
endif

if v:version < 700
	call <SID>OxnzTemplateKitErrMsgFunc('OxnzToolkit requires vim >= 7.0')
	finish
endif

" check for Ruby functionality
if !has('ruby')
	call <SID>OxnzTemplateKitWarnFunc('OxnzToolkit requires vim compiled with +ruby for some functionality')
	" finish
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin global var
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:OxnzToolkitVersion = '0.1.1'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Script local vars
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:OxnzToolkitVimScript = resolve(expand('<sfile>:p'))
let s:OxnzToolkitPluginPath =
			\ fnamemodify(s:OxnzToolkitVimScript, ':h')
let s:OxnzToolkitRubyScript =
			\ fnamemodify(s:OxnzToolkitVimScript, ':r') . '.rb'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Insert C\CPP Include Guards
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzInsertGuardFunc()
	exec "normal G"
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

"""""""""""""""""""""""""""""""""""""""""""""""
" Update time stamp
"""""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzUpdateTimeStampFunc()
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
function <SID>OxnzAppendModeLineFunc()
	let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
				\ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
	let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
	call append(line("$"), l:modeline)
endfunction

"""""""""""""""""""""""""
" Insert Line Numbers
"""""""""""""""""""""""""
function <SID>OxnzInsertLineNumbersFunc()
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
function <SID>OxnzDeleteLeadingSpacesFunc()
	try
		:%s/^\s\+//
	catch /^Vim\%((\a\+)\)\=:E486/
		echo "No more leading space exists"
	endtry
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""
" Delete Trailing White Spaces
""""""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzDeleteTrailingSpacesFunc()
	try
		:%s/\s\+$//
	catch /^Vim\%((\a\+)\)\=:E486/
		echo "No more trailing space exists"
	endtry
endfunction

""""""""""""""""""""""""""""""""""""""""""""
" Remove Extra Blank Lines, Only Leave One
""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzUniqueBlankLinesFunc()
	:silent! g/^\n\{2,}/d
endfunction

""""""""""""""""""""""""""""""""""""""""""""""
" Delete Blank Lines
""""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzDeleteBlankLinesFunc()
	:silent! g/^\s*$/d
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Trim Leading, Trailing Spaces and Also Unique Blank Lines
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzTrimFunc()
	call <SID>OxnzDeleteLeadingSpacesFunc()
	call <SID>OxnzDeleteTrailingSpacesFunc()
	call <SID>OxnzUniqueBlankLinesFunc()
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Comment or Uncomment selected area or current line
" ref: http://vim.wikia.com/wiki/Comment_%26_Uncomment_multiple_lines_in_Vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzToggleCommentFunc()
	echo "hello"
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ruby entry
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzToolkitRubyFunc(cmd, ...)
	try
		execute 'rubyfile' s:OxnzToolkitRubyScript
	catch
		echohl WarningMsg | echo v:exception | echohl None
	endtry
endfunction

function <SID>OxnzRubyInfoFunc()
	call <SID>OxnzToolkitRubyFunc('rubyinfo')
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands definitions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command -nargs=0 OxnzModeLine			:call <SID>OxnzAppendModeLineFunc()
command -nargs=0 OxnzInsertLineNumbers	:call <SID>OxnzInsertLineNumbersFunc()
command -nargs=0 OxnzDeleteLineNumbers	:call <SID>OxnzDeleteLineNumbersFunc()
command -nargs=0 OxnzDeleteLeadingSpaces
			\ :call <SID>OxnzDeleteLeadingSpacesFunc()
command -nargs=0 OxnzDeleteTrailingSpaces
			\ :call <SID>OxnzDeleteTrailingSpacesFunc()
command -nargs=0 OxnzUniqueBlankLines	:call <SID>OxnzUniqueBlankLinesFunc()
command -nargs=0 OxnzDeleteBlankLines	:call <SID>OxnzDeleteBlankLinesFunc()
command -nargs=0 OxnzTrim				:call <SID>OxnzTrimFunc()
command -nargs=0 OxnzToggleComment		:call <SID>OxnzToggleCommentFunc()
command -nargs=0 OxnzRubyInfo			:call <SID>OxnzRubyInfoFunc()

"按\ml,自动插入modeline
"nnoremap <silent> <Leader>ml	:call OxnzModeLine() <CR>

if has('autocmd') && !exists('g:OxnzToolkitAutocmdLoaded')
	let g:OxnzToolkitAutocmdLoaded = 1
	augroup OxnzToolkitEx
		" autocmd BufNewFile *.h{,pp} call <SID>OxnzInsertGuardFunc()
		autocmd BufWrite *.* call <SID>OxnzUpdateTimeStampFunc()
	augroup END
endif
