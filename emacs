;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Filename: .emacs
;
; Copying:	Copyright (C) 2013 0xnz, All rights reserved.
; Version:	0.1
; Author:	0xnz <yunxinyi AT gmail DOT com>
; Last-update:  2013-10-06 23:37
;
; Description:  0xnz's dot emacs file
; Howto:	save this file to ~/.emacs

;----------------basic config---------------
;Load_path
(add-to-list 'load-path' "~/.emacs.d")
(require 'color-theme)
(color-theme-initialize)
(color-theme-blackboard)
;(color-theme-matrix)
; todo_path
(setq todo-file-do "~/.emacs.d/todo/do")
(setq todo-file-done "~/.emacs.d/todo/done")
(setq todo-file-top "~/.emacs.d/todo/top")
;-------------save personal info------------
(setq user-full-name "0xnz")
(setq user-mail-address "yunxinyi@gmail.com")


(setq-default indent-tabs-mode nil)
(setq tab-width 4 c-basic-offset 4)

;显示匹配括号
(show-paren-mode t)
(setq show-paren-style 'parentheses)

;;滚动条在右侧
;(set-scroll-bar-mode 'right)
;滚动页面时比较舒服，不要整页的滚动
(setq scroll-step 1
scroll-margin 3
scroll-conservatively 10000)

; show time
(display-time-mode t)
; 24-hour
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq display-time-use-mail-icon t)
(setq display-time-interval 10)


;highlight current line
;(require 'hl-line)
;(global-hl-line-mode t)

;-------------------color settings----------------
(set-cursor-color "purple")
(set-mouse-color "white")
;background color
(set-background-color "black")
;(set-background-color "darkblue")
(set-foreground-color "white")
(set-face-foreground 'region "cyan")
(set-face-background 'region "blue")
(set-face-foreground 'secondary-selection "skyblue")
(set-face-background 'secondary-selection "darkblue")

;;;设置日历的一些颜色
(setq calendar-load-hook
'(lambda ()
(set-face-foreground 'diary-face "skyblue")
(set-face-background 'holiday-face "slate blue")
(set-face-foreground 'holiday-face "white")))

;;-------------------------Shell 使用 ansi color-------------
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;--------------font-----------
;(set-default-font "Monospace-12")
;(set-default-font "Bitstream Vera Sans Mono-12")

(set-language-environment 'UTF-8)
;------------------------file encoding-----------------------
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq file-name-coding-system 'utf-8)

;;打开就启用 text 模式
(setq default-major-mode 'text-mode)
;;语法高亮
(global-font-lock-mode t)
;;把这些缺省禁用的功能打开
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'LaTeX-hide-environment 'disabled nil)
;;显示行列号
(column-number-mode t)
;;在buffer左侧显示行号
(dolist (hook (list
'c-mode-hook
'c++-mode-hook
'emacs-list-mode-hook
'list-interaction-mode-hook
'list-mode-hook
'emms-playlist-mode-hook
'java-mode-hook
'asm-mode-hook
'haskell-mode-hook
'erc-mode-hook
'sh-mode-hook
'makefile-gmake-mode-hook
))
(add-hook hook (lambda () (linum-mode 1))))


;;在标题栏显示buffer的名字(默认不显示)
(setq frame-title-format "%b@emacs")

;;支持emacs和外部程序的粘贴
(setq x-select-enable-clipboard t)

; close auto save
(setq auto-save-mode nil)
; don't generate #filename# temp file
(setq auto-save-default nil)

;;自动的在文件末增加一新行
(setq require-final-newline t)
;;当光标在行尾上下移动的时候，始终保持在行尾。
(setq track-eol t)

(setq
 backup-by-coping t ;don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.saves")) ;don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)

(setq-default c-indent-tabs-mode t; Press TAB should cause indentation
	      c-indent-level 4; A TAB is equivilent to four spaces
	      c-argdecl-indent 0; Do not indent argument decl's extra
	      c-tab-always-indent t
	      c-basic-offset 4
	      backward-delete-function nil); DO NOT expand tabs when deleting



;-----------------------key-sequences-------------------------
; compile and debug
(global-set-key [f5] 'compile);compile
(global-set-key [C-f7] 'gdb);debug
(setq-default compile-command "make")
(global-set-key [C-f8] 'previous-error)
(global-set-key [f8] 'next-error)

;;F9:格式化代码，以使代码缩进清晰，容易阅读
(global-set-key [f9] 'c-indent-line-or-region)
;;F10:注释 / 取消注释
(global-set-key [f10] 'comment-or-uncomment-region)

;Ctrl+F11:复制区域到寄存器
(global-set-key [C-f11] 'copy-to-register)
;;F11:粘贴寄存器内容
(global-set-key [f11] 'insert-register)


;;撤消
(global-set-key (kbd "C-z") 'undo)
;;全选
;(global-set-key (kbd "C-a") 'mark-whole-buffer)
;;保存
(global-set-key (kbd "C-s") 'save-buffer)

;;跳转到某行
(global-set-key [(meta g)] 'goto-line)
;;Tab补全或缩进
(global-set-key [(tab)] 'my-indent-or-complete)

;------------------------programming related----------------------
;;打开代码折叠功能
(add-hook 'c-mode-hook' 'hs-minor-mode)
(add-hook 'c++-mode-hook 'hs-minor-mode)

;(c-set-style "K&R")

;;在模式栏中显示当前光标所在函数
(which-function-mode)
;;自动缩进的宽度设置为4
(setq c-basic-offset 4)

;;预处理设置
(setq c-macro-shrink-window-flag t)
(setq c-macro-preprocessor "cpp")
(setq c-macro-cppflags " ")
(setq c-macro-prompt-flag t)
(setq hs-minor-mode t)
(setq abbrev-mode t)

;;auto-complete
(add-to-list 'load-path "~/.emacs.d/plugins/auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/auto-complete/ac-dict")
(ac-config-default)

;;-----------------------cc mode---------------------
(require 'cc-mode)
(c-set-offset 'inline-open 0)
(c-set-offset 'friend '-)
(c-set-offset 'substatement-open 0)


;; auto format Ctrl-Alt-\
(dolist (command '(yank yank-pop))
  (eval
   `(defadvice ,command (after indent-region activate)
      (and (not current-prefix-arg)
           (member major-mode
                   '(emacs-list-mode
                     list-mode
                     clojure-mode
                     scheme-mode
                     haskell-mode
                     ruby-mode
                     rspec-mode
                     python-mode
                     c-mode
                     c++-mode
                     objc-mode
                     latex-mode
                     js-mode
                     plain-TeX-mode))
           (let ((mark-even-if-inactive transient-mark-mode))
             (indent-region (region-beginning) (region-end) nil))))))
                     
;;semantic
;(setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
;                                  global-semanticdb-minor-mode
;                                  global-semantic-idle-summary-mode
;                                  global-semantic-mru-bookmark-mode))
;(semantic-mode 1)
