;===============================================================================
; Filename: init.el
;
; Copying:	Copyright (C) 2013 0xnz, All rights reserved.
; Version:	0.2
; Author:	0xnz <yunxinyi AT gmail DOT com>
; Last-update:  2013-10-06 23:37
;
; Description:  0xnz's dot emacs file
; Howto:	copy this file to ~/.emacs or ~/.emacs.d/init.el
;_______________________________________________________________________________

;-------------save personal info------------
(setq user-full-name "oxnz")
(setq user-mail-address "yunxinyi@gmail.com")
;-----------------path config---------------
;Load_path{
;(add-to-list 'load-path' "~/.emacs.d")
;}
;todo path{
(setq todo-file-do "~/.emacs.d/todo/do")
(setq todo-file-done "~/.emacs.d/todo/done")
(setq todo-file-top "~/.emacs.d/todo/top")
;}
;(setq default-directory "/Users/oxnz/Developer/")

;----------------backup------------------
(setq
 backup-by-coping t ;don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.emacs.d/saves")) ;don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)

;---------------auto-save----------------
; close auto save
(setq auto-save-mode nil)
; don't generate #filename# temp file
(setq auto-save-default nil)

;----------------------encoding---------------------
(set-language-environment 'UTF-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq file-name-coding-system 'utf-8)

;---------------------component toggle----------------
;disable tool-bar-mode
;disable scroll bar
;start speedbar if we're using a window system
(when window-system
	(tool-bar-mode -1)
	(scroll-bar-mode -1)
	(speedbar t)
)
;-----------------------------speed bar--------------------------------

;--------------------frame-----------------------
;title{
;在标题栏显示buffer的名字(默认不显示)
(setq frame-title-format "[%b]")
;}

;---------------------tool-bar-mode---------------

;------------------scroll-bar--------------------
;;滚动条在右侧
;(set-scroll-bar-mode 'right)
 ;滚动页面时比较舒服，不要整页的滚动
;(setq scroll-step 1
;scroll-margin 3
;scroll-conservatively 10000)

;------------------mode-line------------------
; show time{
(display-time-mode t)
; 24-hour
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq display-time-use-mail-icon t)
(setq display-time-interval 10)
;}
;在模式栏中显示当前光标所在函数
;(which-function-mode)

;-----------------echo-area-----------------

;--------------set font---------------------
;English font{
;(set-default-font "Monospace-12")
(set-face-attribute
 'default nil :font "Monaco 12")
;(set-default-font "Bitstream Vera Sans Mono-12")
;}
Chinese font{
(dolist (charset '(kana han symbol cjk-misc bopomofo))
  (set-fontset-font (frame-parameter nil 'font)
		    charset
		    (font-spec :family "Hiragino Sans GB W3" :size 12)))
;}
;-------------------------------theme or color---------------- 
;theme{
(custom-set-variables
 '(custom-enabled-themes (quote (light-blue))))
(custom-set-faces
 )
;}
;color{
;(set-cursor-color "purple")
;(set-mouse-color "white")
;(set-background-color "black")
;;(set-background-color "darkblue")
;(set-foreground-color "white")
;(set-face-foreground 'region "cyan")
;(set-face-background 'region "blue")
;(set-face-foreground 'secondary-selection "skyblue")
;(set-face-background 'secondary-selection "darkblue")
;}
;Shell 使用 ansi color{
;(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
;(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;}
;---------------------------------------------------------------------

;---------------------------calendar--------------------------
;to start and display your calendar, just do the following:
;M-x calender
;display the 'celestial-stem’ (天干) and the ‘terrestrial-branch’ (地支)
;in Chinese:
(setq chinese-calendar-celestial-stem
	  ["甲" "乙" "丙" "丁" "戊" "己" "庚" "辛" "壬" "癸"]
	  chinese-calendar-terrestrial-branch
	  ["子" "丑" "寅" "卯" "辰" "巳" "午" "未" "申" "酉" "戌" "亥"])
;设置日历的一些颜色{
;(setq calendar-load-hook
;'(lambda ()
;(set-face-foreground 'diary-face "skyblue")
;(set-face-background 'holiday-face "slate blue")
;(set-face-foreground 'holiday-face "white")))
;}

;------------------------------behavior---------------------------------
;支持emacs和外部程序的粘贴
(setq x-select-enable-clipboard t)
;自动的在文件末增加一新行
;(setq require-final-newline t)
;当光标在行尾上下移动的时候，始终保持在行尾。
(setq track-eol t)
;show matching brackets{
;(setq show-paren-delay 0)
;(setq show-paren-style 'parentheses)
(show-paren-mode t)
;}
;highlight current line{
;(global-hl-line-mode t)
;}
;;显示行列号
;(column-number-mode t)
;;把这些缺省禁用的功能打开
;(put 'set-goal-column 'disabled nil)
;(put 'narrow-to-region 'disabled nil)
;(put 'upcase-region 'disabled nil)
;(put 'downcase-region 'disabled nil)
;(put 'LaTeX-hide-environment 'disabled nil)

;-----------------------------------CEDET-----------------------------------
;Collection of Emacs Development Environment Tools
;(see [http://www.randomsample.de/cedetdocs/ede/] for more details.)
;semantic mode{
(setq semantic-default-submodes '(global-semantic-idle-completions-mode
                                  global-semantic-idle-summary-mode
								  global-semantic-idle-scheduler-mode
								  global-semantic-decoration-mode
								  global-semantic-highlight-func-mode
								  global-semantic-show-unmatched-syntax-mode
                                  global-semanticdb-minor-mode
                                  global-semantic-mru-bookmark-mode))
(global-ede-mode 1)
(require 'semantic/sb)	; semantic speedbar
(semantic-mode 1)
;}
;(setq hs-minor-mode t)
;(setq abbrev-mode t)
;------------------indent------------------
;(setq-default indent-tabs-mode nil)
;(setq tab-width 4 c-basic-offset 4)
;打开就启用 text 模式
;(setq default-major-mode 'text-mode)
(electric-indent-mode t)
;;-----------------------cc mode---------------------
(setq-default c-basic-offset 4
			  tab-width 4
			  indent-tabs-mode t)
;(c-set-style "K&R")
;自动缩进的宽度设置为4
;(setq c-basic-offset 4)
;;;预处理设置
;(setq c-macro-shrink-window-flag t)
;(setq c-macro-preprocessor "cpp")
;(setq c-macro-cppflags " ")
;(setq c-macro-prompt-flag t)
;(require 'cc-mode)
;(c-set-offset 'inline-open 0)
;(c-set-offset 'friend '-)
;(c-set-offset 'substatement-open 0)

;(setq-default c-indent-tabs-mode t; Press TAB should cause indentation
;	      c-indent-level 4; A TAB is equivilent to four spaces
;	      c-argdecl-indent 0; Do not indent argument decl's extra
;	      c-tab-always-indent t
;	      c-basic-offset 4
;	      backward-delete-function nil); DO NOT expand tabs when deleting
;
;-----------------highlight----------------
;语法高亮
(global-font-lock-mode t)
;;在buffer左侧显示行号
;(dolist (hook (list
;'c-mode-hook
;'c++-mode-hook
;'emacs-list-mode-hook
;'list-interaction-mode-hook
;'list-mode-hook
;'emms-playlist-mode-hook
;'java-mode-hook
;'asm-mode-hook
;'haskell-mode-hook
;'erc-mode-hook
;'sh-mode-hook
;'makefile-gmake-mode-hook
;))
;(add-hook hook (lambda () (linum-mode 1))))

;------------------------programming related----------------------
;打开代码折叠功能
(add-hook 'c-mode-hook' 'hs-minor-mode)
(add-hook 'c++-mode-hook 'hs-minor-mode)
;------------------------auto complete------------------------
;(require 'auto-complete)
;(global-auto-complete-mode t)
;;auto-complete
;(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete")
;(require 'auto-complete-config)
;(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete/ac-dict")
;(ac-config-default)


;---------------------------action--------------------------
; auto-indent yanked (pasted) code
(dolist (command '(yank yank-pop))
 (eval `(defadvice ,command (after indent-region activate)
	(and (not current-prefix-arg)
		(member major-mode '(emacs-lisp-mode lisp-mode clojure-mode
			scheme-mode haskell-mode ruby-mode rspec-mode python-mode
			c-mode c++-mode objc-mode latex-mode plain-tex-mode js-mode
			html-mode))
		(let ((mark-even-if-inactive transient-mark-mode))
			(indent-region (region-beginning) (region-end) nil))))))


;-----------------------key-sequence---------------------
; compile and debug{
;(global-set-key [f5] 'compile);compile
;(global-set-key [C-f7] 'gdb);debug
;(setq-default compile-command "make")
;(global-set-key [C-f8] 'previous-error)
;(global-set-key [f8] 'next-error)
;}
;format{
;F9:格式化代码，以使代码缩进清晰，容易阅读
;(global-set-key [f9] 'c-indent-line-or-region)
;;F10:注释 / 取消注释
;(global-set-key [f10] 'comment-or-uncomment-region)
;Ctrl+F11:复制区域到寄存器
;(global-set-key [C-f11] 'copy-to-register)
;;F11:粘贴寄存器内容
;(global-set-key [f11] 'insert-register)
;}
;;撤消
;(global-set-key (kbd "C-z") 'undo)
;;;全选
;;(global-set-key (kbd "C-a") 'mark-whole-buffer)
;;;保存
;(global-set-key (kbd "C-s") 'save-buffer)
;;;跳转到某行
;(global-set-key [(meta g)] 'goto-line)
