" A tempmlate system for vim in vimL and python
" ref: http://www.terminally-incoherent.com/blog/2013/05/06/vriting-vim-plugins-in-python/
" ref: http://brainacle.com/how-to-write-vim-plugins-with-python.html
" author: Oxnz
" mail: yunxinyi@gmail.com

"""""""""""""""""""""""""""""""""""""""""""
" Verify if already loaded
"""""""""""""""""""""""""""""""""""""""""""
if exists("g:OxnzTemplate")
	echo 'OxnzTemplate Already Loaded.'
	finish
endif
let g:OxnzTemplateVersion = '0.1.1'

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Dependencies test
"""""""""""""""""""""""""""""""""""""""""""""""""""""
if !has('python')
	echo 'Error: Required vim compiled with +python'
	finish
endif

""""""""""""""""""""""""""""""""""""""""""""
" Entry Function of OxnzTemplate
""""""""""""""""""""""""""""""""""""""""""""
function! <SID>OxnzTemplateFunc(cmd, ...)
	pyfile OxnzTemplate.py
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" Insert Template by FileType
"""""""""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>OxnzTemplateInsertFunc()
	call <SID>OxnzTemplateFunc('insert', &filetype)
endfunction

"""""""""""""""""""""""""""""""""""""""
" Test Func
"""""""""""""""""""""""""""""""""""""""
function! <SID>OxnzTestFunc()
	echoerr "fa"
endfunction

command! -nargs=0 OxnzTest		:call <SID>OxnzTestFunc()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autocmd group for OxnzTemplate
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("autocmd")
	augroup OxnzTemplateEx
	au!
		autocmd BufNewFile *.* call <SID>OxnzTemplateInsertFunc()
	augroup END
endif
