" A tempmlate system for vim in vimL and python
" ref: http://www.terminally-incoherent.com/blog/2013/05/06/vriting-vim-plugins-in-python/
" ref: http://brainacle.com/how-to-write-vim-plugins-with-python.html
" author: Oxnz
" mail: yunxinyi@gmail.com

"""""""""""""""""""""""""""""""""""""""""""
" Verify if already loaded
"""""""""""""""""""""""""""""""""""""""""""
if exists('g:OxnzTemplateKitLoaded')
	echohl ErrorMsg
	echo 'Error: OxnzTemplateKit Already Loaded'
	echohl None
	finish
endif
let g:OxnzTemplateKitLoaded = 1
let g:OxnzTemplateKitVersion = '0.1.1'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display Error Message
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzTemplateKitErrMsgFunc(msg)
    echohl ErrorMsg
    echo 'Error: ' . a:msg
    echohl None
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display Warning Message
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzTemplateKitWarnFunc(msg)
    echohl WarningMsg
    echo 'Warning: ' . a:msg
    echohl None
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Script local var
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:OxnzTemplateKitVimScript = resolve(expand('<sfile>:p'))
let s:OxnzTemplateKitPluginPath =
			\ fnamemodify(s:OxnzTemplateKitVimScript, ':h')
let s:OxnzTemplateKitPythonScript =
			\ fnamemodify(s:OxnzTemplateKitVimScript, ':r') . '.py'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Dependencies Test
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !has('python')
	call <SID>OxnzTemplateKitErrMsgFunc('OxnzTemplateKit requires vim compiled with +python')
	finish
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Entry Function of OxnzTemplate
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzTemplateKitFunc(cmd, ...)
	try
		execute 'pyfile' s:OxnzTemplateKitPythonScript
	"catch
		"call <SID>OxnzTemplateKitErrMsgFunc(v:exception)
	finally
	endtry
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Insert Template by FileType
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function <SID>OxnzTemplateInsertFunc()
	call <SID>OxnzTemplateKitFunc('insert', &filetype)
endfunction

"""""""""""""""""""""""""""""""""""""""
" Test Func
"""""""""""""""""""""""""""""""""""""""
function <SID>OxnzTestFunc()
	echoerr "fa"
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Command definitions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command -nargs=0 OxnzTemplateInsert :call <SID>OxnzTemplateInsertFunc()
command -nargs=0 OxnzTest		:call <SID>OxnzTestFunc()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocmd group for OxnzTemplate
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('autocmd') && !exists('g:OxnzTemplateKitAutocmdLoaded')
	let g:OxnzTemplateKitAutocmdLoaded = 1
	augroup OxnzTemplateKit
		autocmd BufNewFile *.template setfiletype template
		autocmd BufNewFile * call <SID>OxnzTemplateInsertFunc()
	augroup END
endif
