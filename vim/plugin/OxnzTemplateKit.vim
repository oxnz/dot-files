" Copyright (c) 2013-2016 Will Z
" All rights reserved.
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
" File: OxnzTemplateKit.vim
" Description: A tempmlate system for vim in vimL and python
" Author: Will Z
" Maintainer: Will Z<yunxinyi@gmail.com>
" Version: 1.0.0
" Last Change: Thu May  5 22:28:27 CST 2016
"
" Notes:
" ref: http://brainacle.com/how-to-write-vim-plugins-with-python.html
"
" Feature:
" - suffix and filetype based template
"
" TODO:
" 1. add control option for autocmds
"
" Use:
" Autoloaded when create new buffer
"
" Dependencies:
" - python/dyn needed for some functionality


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Verify if already loaded
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists('g:OxnzTemplateKitVersion')
	finish
endif
let g:OxnzTemplateKitVersion = 1.0.0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display Error Message
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzTemplateKitErrMsgFunc(msg)
    echohl ErrorMsg
    echo 'Error: ' . a:msg
    echohl None
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display Warning Message
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzTemplateKitWarnFunc(msg)
    echohl WarningMsg
    echo 'Warning: ' . a:msg
    echohl None
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Script local var
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:OxnzTemplateKitVimScript = resolve(expand('<sfile>:p'))
let s:OxnzTemplateKitPluginPath =
			\ fnamemodify(s:OxnzTemplateKitVimScript, ':h')
let s:OxnzTemplateKitPythonScript =
			\ fnamemodify(s:OxnzTemplateKitVimScript, ':r') . '.py'
let s:OxnzTemplateKitOptions = &cpo
set cpo&vim


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Dependencies Test
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !has('python')
	call <SID>OxnzTemplateKitErrMsgFunc('OxnzTemplateKit requires vim compiled with +python')
	finish
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Entry Function of OxnzTemplate
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzTemplateKitFunc(cmd, ...)
	try
		execute 'pyfile' s:OxnzTemplateKitPythonScript
	"catch
		"call <SID>OxnzTemplateKitErrMsgFunc(v:exception)
	finally
	endtry
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Insert Template by FileType
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzTemplateInsertFunc()
	call <SID>OxnzTemplateKitFunc('insert', &filetype)
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Confirm function
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: add confirm while some templates need extra parameter,
" like makefile against C is different from other Object-C projects

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Test Stub Func
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzTemplateKitTestFunc()
	"use py return var to send back the var value
	py << EOF
try:
	import vim
	print vim.eval("%:t")
except Exception as e:
	print "excepted: ", e
	return 1
except:
	print "2 excepted: ", e
	print 'hello not exists {}'.format(e)
else:
	print 'ok'
finally:
	print 'done'
EOF
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Command definitions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command -nargs=0 OxnzTemplateInsert :call <SID>OxnzTemplateInsertFunc()
command -nargs=0 OxnzTemplateKitTest	:call <SID>OxnzTemplateKitTestFunc()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocmd group for OxnzTemplate
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('autocmd')
	augroup OxnzTemplateKit
		au!
		autocmd BufNewFile *.template setfiletype template
		autocmd BufNewFile * call <SID>OxnzTemplateInsertFunc()
	augroup END
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Clean up
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let &cpo=s:OxnzTemplateKitOptions
unlet s:OxnzTemplateKitOptions
