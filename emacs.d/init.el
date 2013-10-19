; -*-mode: Emacs-Lisp-*-
;==============================================================================
; Filename: init.el
;
; Copying:	Copyright (C) 2013 0xnz, All rights reserved.
; Version:	0.2
; Author:	0xnz <yunxinyi AT gmail DOT com>
; Last-update:  2013-10-06 23:37
;
; Note:         This file is NOT part of GNU Emacs
; Description:  0xnz's dot emacs file, fixing weird quirks and poor defaults
; Use:          copy this file to ~/.emacs or ~/.emacs.d/init.el
;______________________________________________________________________________
;-------------save personal info------------
(setq user-full-name "oxnz")
(setq user-mail-address "yunxinyi@gmail.com")
;-----------------path config---------------
;Load_path{
(add-to-list 'load-path user-emacs-directory)
;}
;todo path{
(setq todo-file-do "~/.emacs.d/todo/do")
(setq todo-file-done "~/.emacs.d/todo/done")
(setq todo-file-top "~/.emacs.d/todo/top")
;}
;(setq default-directory "/Users/oxnz/Developer/")

;--------------------version check---------------
(cond
  ((require 'desktop)
   (desktop-load-default)
   (desktop-read)
   )
  ((> emacs-major-version 21)
   (cua-mode t)
   (setq cua-auto-tabify-rectangles nil); Don't tabify after rectangle commands
   (transient-mark-mode 1); No region when it is not highlighted
   (setq cua-keep-region-after-copy t); Standard Windows behavior
   (ido-mode t); or change t to both for buffers and files
   (setq ido-enable-prefix nil
         ido-save-directory-list-file "~/.emacs.d/ido.last"
         ido-work-directory-list '("~/Developer" "~/Desktop")
         ido-enable-flex-matching t
         ido-create-new-buffer 'always
         ido-use-filename-at-point t
         ido-confirm-unique-completion t
         ido-enable-last-directory-history t; remember last used dirs
         ido-use-url-at-point nil; don't use url at point (annoying)
         ido-max-prospects 10))
  ((>= emacs-major-version 23)
;   (electric-indent-mode t)
   )
)
;------------------------vi mode-------------------
;(evil-mode 1)
;(setq viper-inhibit-startup-message 't)
;(setq viper-expert-level '3)
;-----------------set default---------------
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (concat user-emacs-directory "places"))
(setq version-control t)
(setq kept-new-versions 3)
(setq delete-old-versions t)
(setq kept-old-versions 2)
(setq dired-kept-versions 1)
(setq backup-directory-alist `(("." . ,
                                (concat user-emacs-directory "backups"))))
(setq-default
  default-frame-alist
  '(
    (save-interprogram-paste-before-kill t)
    (apropos-do-all t)
    (recentf-mode 1)
    (show-paren-mode 1)
    (language-environment 'UTF-8)
    (find-file-existing-other-name t) ;avoid problem with symbolic links
;    (curosr-color . "white")
;    (mouse-color . "white")
;    (foreground-color . "white")
;    (background-color . "DoggerBlue4")
;    (cursor-type . bar)
    (tool-bar-lines . 0)
    (menu-bar-lines . 1)
    (width . 80)
;    (height . 58)
;    (font . "Monaco")
    )
)

;---------------auto-save----------------
; close auto save
;(setq auto-save-mode nil)
; don't generate #filename# temp file
;(setq auto-save-default nil)

;----------------------commen---------------------
;打开就启用 text 模式
(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook 'auto-fill-mode)
(set-language-environment 'UTF-8)
(set-input-method nil); no funky input or normal editing;
;----------------------encoding---------------------
;(set-buffer-file-coding-system 'utf-8)
;(setq default-buffer-file-coding-system 'utf-8)
;(set-terminal-coding-system 'utf-8)
;(set-keyboard-coding-system 'utf-8)
;(setq file-name-coding-system 'utf-8)

(setq echo-keystrokes 0.1
      font-lock-maximum-decoration t
      inhibit-startup-message t
      transient-mark-mode t
      color-theme-is-global t
      delete-by-moving-to-trash t
;      shift-select-mode nil
      truncate-partial-width-windows nil
      uniquify-buffer-name-style 'forward
      whitespace-style '(trailing lines space-before-tab
                                  indentation space-after-tab)
      whitespace-line-column 100
      search-highlight t;highlight when searching...
      query-replace-highlight t; ...and replacing
)

; a bit more intelligent copy-paste: emacswiki.org/emacs/SlickCopy

;---------------------component toggle----------------
;disable tool-bar-mode
;disable scroll bar
;start speedbar if we're using a window system
(if window-system (progn
                    (tooltip-mode -1)
	(blink-cursor-mode -1)
	(tool-bar-mode -1)
	(scroll-bar-mode -1)
;	(speedbar t)
        (setq frame-title-format '(:eval (format "%s@%s:%s"
                                                 (or (file-remote-p default-directory 'user) user-login-name)
                                                 (or (file-remote-p default-directory 'host) system-name)
                                                 (file-name-nondirectory (or (buffer-name) default-directory)))))
	(set-scroll-bar-mode 'right)	;滚动条在右侧
        ; do smooth scrolling
        (setq scroll-margin 0
              scroll-conservatively 100000
              scroll-up-aggressively 0
              scroll-down-aggressively 0
              scroll-preserve-screen-position t; preserve screen pos with C-v/M-v
              )
	)
	; disable menu-bar in console
	(menu-bar-mode -1)
)
;------------------mode-line------------------
(setq-default mode-line-format
			  (list "-"
                                'mode-line-mule-info
                                'mode-line-modified
                                'mode-line-frame-identification
                                "%b--"
                                        ; Note that this is evaluated while
                                        ; making the list. It makes a mode line
                                        ; construct which is just a string.
                                (system-name)
                                ":"
                                'default-directory
                                "    "
                                'global-mode-string
                                "    "
                                "    %[("
                                '(:eval (mode-line-mode-name))
                                'mode-line-process
                                'minor-mode-alist
                                "%n"
                                ")%]--"
                                '(which-func-mode ("" which-func-format "--"))
                                '(line-number-mode "L%l--")
                                '(column-number-mode "C%c--")
                                '(-3 "%p"))
)
(setq column-number-mode t)

;在模式栏中显示当前光标所在函数
;(which-function-mode)

;-----------------echo-area-----------------


;--------------set font---------------------
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.

 ;;English font{
                                        ;(set-default-font "Monospace-12")
                                        ;(set-face-attribute
                                        ; 'default nil :font "Monaco 12")
 ;(set-default-font "Bitstream Vera Sans Mono-12")
;}
                                        ;Chinese font{
;(dolist (charset '(kana han symbol cjk-misc bopomofo))
;  (set-fontset-font (frame-parameter nil 'font)
;		    charset
;		    (font-spec :family "Hiragino Sans GB W3" :size 12)))
 ;; 中文测试
 ;;}
 )
;-------------------------------theme or color---------------- 
;theme{
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-insert-mode t)
 '(backup-directory-alist (quote (("." . "~/.emacs.d/backups"))))
 '(c-default-style (quote ((c-mode . "") (c++-mode . "") (objc-mode . "") (java-mode . "java") (awk-mode . "awk") (other . "gnu"))))
 '(c-echo-syntactic-information-p t)
 '(calendar-chinese-all-holidays-flag t)
 '(column-number-mode t)
 '(compile-command "make")
 '(custom-enabled-themes (quote (light-blue)))
 '(delete-old-versions t)
 '(echo-keystrokes 0.5)
 '(electric-indent-mode t)
 '(global-ede-mode t)
 '(global-highlight-changes-mode t)
 '(history-delete-duplicates t)
 '(indent-tabs-mode t)
 '(inhibit-default-init t)
 '(perl-tab-always-indent t)
 '(perl-tab-to-comment t)
 '(tab-always-indent (quote complete))
 '(tab-width 4)
 '(version-control t))
;}
;color{
;(set-cursor-color "purple")
;(set-mouse-color "white")
;(set-background-color "black")
;(set-background-color "darkblue")
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

;------------------------------behavior---------------------------------
;支持emacs和外部程序的粘贴
(setq x-select-enable-clipboard t;copy-paste should work ...
      interprogram-paste-function; ...with...
      'x-cut-buffer-or-selection-value); ...other X clients
;自动的在文件末增加一新行
(setq require-final-newline t)
;当光标在行尾上下移动的时候，始终保持在行尾。
(setq track-eol t)
;show matching brackets{
(setq show-paren-delay 0)
(setq show-paren-style 'parentheses)
(show-paren-mode t)
;}
;highlight current line{
;(global-hl-line-mode t)
;}
;;把这些缺省禁用的功能打开
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'LaTeX-hide-environment 'disabled nil)

;-----------------------------------CEDET-----------------------------------
;Collection of Emacs Development Environment Tools
;(see [http://www.randomsample.de/cedetdocs/ede/] for more details.)
;semantic mode{
;(setq semantic-default-submodes '(global-semantic-idle-completions-mode
;                                  global-semantic-idle-summary-mode
;								  global-semantic-idle-scheduler-mode
;								  global-semantic-decoration-mode
;								  global-semantic-highlight-func-mode
;								  global-semantic-show-unmatched-syntax-mode
;                                  global-semanticdb-minor-mode
;                                  global-semantic-mru-bookmark-mode))
;(global-ede-mode 1)
;(require 'semantic/sb)	; semantic speedbar
;(semantic-mode 1)
;}
(setq hs-minor-mode t)
(setq abbrev-mode t)
;------------------indent------------------
(setq-default indent-tabs-mode nil
              tab-width 4
              indent-empty-lines t
              imenu-auto-rescan t
              backward-delete-function nil; DO NOT expand tabs when deleting
              ;---------cc mode-----------
              c-basic-offset 4
              c-indent-tabs-mode t ; Press tab should cause indent
              c-tab-always-indent t
              c-argdecl-indent 0; Do not indent argument decl's extra
              c-indent-level 4 ; A Tab is equivilent to 4 spaces
              ; preprocessor
              c-macro-shrink-window-flag t
              c-macro-preprocessor "cpp"
              c-macro-cppflags " "
              c-macro-prompt-flag t
              )

(add-hook 'text-mode-hook 'turn-on-auto-fill)

;;-----------------------cc mode---------------------
;;;预处理设置
;(require 'cc-mode)
;(c-set-offset 'inline-open 0)
;(c-set-offset 'friend '-)
;(c-set-offset 'substatement-open 0)

;------------------------programming related----------------------
;打开代码折叠功能
;(add-hook 'c-mode-hook' 'hs-minor-mode)
;(add-hook 'c++-mode-hook 'hs-minor-mode)
;------------------------auto complete------------------------
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

;---------------------------action--------------------------
; auto-indent yanked (pasted) code
;(dolist (command '(yank yank-pop))
; (eval `(defadvice ,command (after indent-region activate)
;	(and (not current-prefix-arg)
;		(member major-mode '(emacs-lisp-mode lisp-mode clojure-mode
;			scheme-mode haskell-mode ruby-mode rspec-mode python-mode
;			c-mode c++-mode objc-mode latex-mode plain-tex-mode js-mode
;			html-mode))
;		(let ((mark-even-if-inactive transient-mark-mode))
;			(indent-region (region-beginning) (region-end) nil))))))
;

;-----------------------key-sequence---------------------
; compile and debug{
(global-set-key [f5] 'compile);compile
(global-set-key [f6] 'gdb);debug
(setq-default compile-command "make")
(global-set-key [f7] 'previous-error)
(global-set-key [f8] 'next-error)
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
(global-set-key (kbd "RET") 'newline-and-indent)
; mac key binding make you feel at home
(global-set-key [?\A-a] 'mark-whole-buffer)
(global-set-key [?\A-s] 'save-buffer)
(global-set-key [?\A-S] 'write-file)
(global-set-key [?\A-p] 'ps-print-buffer)
(global-set-key [?\A-o] 'find-file)
(global-set-key [?\A-q] 'save-buffers-kill-emacs)
(global-set-key [?\A-w] 'kill-buffer-and-window)
(global-set-key [?\A-z] 'undo)
(global-set-key [?\A-f] 'isearch-forward)
(global-set-key [?\A-g] 'query-replace)
(global-set-key [?\A-l] 'goto-line)
(global-set-key [?\A-m] 'iconify-frame)
(global-set-key [?\A-n] 'new-frame)
;---------------------------mode----------------------------------------
; uncomment the following line to override the default scratch messsage
(setq initial-scratch-message (concat
";                  /)\n"
";                 //\n"
";   .------------| |---------------------------------------------.__\n"
";   |   OXNZ     | |>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:>\n"
";   `------------| |----------------------------------------------'^^\n"
";                 \\\\\n"
";                  \\)\n"
	)
)

;-----------------shell mode---------------
;(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
;(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on t)

;--------------sh-mode-------------
(setq
 sh-indent-for-then 0
 sh-indent-for-do 0
 sh-indent-for-after-do '+
 sh-indent-for-case-label '*
 sh-indent-for-case-alt '+
 sh-indent-comment t)
;-------------------compile mode------------------
(add-hook 'java-mode-hook
          (lambda(); javac or ant
            (set (make-local-variable 'compile-command) (concat "javac " (buffer-name)))))
; safe locals
; we mark these as 'safe', so emacs22+ won't give us annoying warnings
(setq safe-local-variable-values
      (quote ((auto-recompile . t)
              (folding-mode . t)
              (outline-minor-mode . t)
              (sh-indent-comment . t)
              auto-recompile outline-minor-mode sh-indent-comment
              )
             )
      )
