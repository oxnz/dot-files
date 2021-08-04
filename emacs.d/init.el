;; -*-mode: Emacs-Lisp-*-
;
; Copyright (c) 2012-2021 Z
; All rights reserved.
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in
; all copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
; THE SOFTWARE.
;
;;==============================================================================
;; Filename:	init.el
;; Version:		0.2
;; Author:		0xnz <yunxinyi AT gmail DOT com>
;; Last-updated: Wed Sep  9 16:16:22 CST 2015
;;
;; Note:        This file is NOT part of GNU Emacs
;; Description: 0xnz's dot emacs file, fixing weird quirks and poor defaults
;; Install:		copy this file to ~/.emacs or ~/.emacs.d/init.el
;;______________________________________________________________________________
;; ------------Load_path------------
(add-to-list 'load-path user-emacs-directory)

;--------------------version check---------------
(cond
  ((require 'desktop)
   (desktop-load-default)
   (desktop-read)
   )
  ((> emacs-major-version 21)
   (cua-mode t)
   (transient-mark-mode 1); No region when it is not highlighted
   (ido-mode t); or change t to both for buffers and files
   (setq
    cua-auto-tabify-rectangles nil ; Don't tabify after rectangle commands
    cua-keep-region-after-copy t   ; Standard Windows behavior
    ido-enable-prefix nil
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
(setq-default
 save-place t
 save-place-file "~/.emacs.d/places"
 quickurl-url-file (convert-standard-filename "~/.emacs.d/quickurls")
  default-frame-alist
  '(
    (save-interprogram-paste-before-kill t)
    (apropos-do-all t)
    (recentf-mode 1)
    (recentf-max-menu-items 10)
    (recentf-max-saved-items 10)
    (show-paren-mode 1)
    (language-environment 'utf-8)
    (find-file-existing-other-name t) ;avoid problem with symbolic links
;    (curosr-color . "white")
;    (mouse-color . "white")
;    (foreground-color . "white")
;    (background-color . "DoggerBlue4")
;    (cursor-type . bar)
    (tool-bar-lines . 0)
    (menu-bar-lines . 1)
    (width . 80)
    (height . 42)
;    (font . "Monaco")
    )
)

(add-hook 'text-mode-hook 'auto-fill-mode)


;---------------------component toggle----------------
;disable tool-bar-mode
;disable scroll bar
;start speedbar if we're using a window system
(if window-system
    (progn
      (tooltip-mode -1)
      (blink-cursor-mode -1)
      (tool-bar-mode -1)
      (scroll-bar-mode -1)
      ;;(speedbar t)
      (setq frame-title-format '(:eval (format "%s@%s:%s"
            (or (file-remote-p default-directory 'user) user-login-name)
            (or (file-remote-p default-directory 'host) system-name)
            (file-name-nondirectory (or (buffer-name) default-directory)))))
      (set-scroll-bar-mode 'right)	;滚动条在右侧
      ;; do smooth scrolling
      (setq scroll-margin 0
            scroll-conservatively 100000
            scroll-up-aggressively 0
            scroll-down-aggressively 0
            scroll-preserve-screen-position t; preserve screen pos with C-v/M-v
            )
      )
  ;; disable menu-bar in console
  (menu-bar-mode -1)
  )
;------------------mode-line------------------
(setq-default mode-line-format
			  (list "-"
                    'mode-line-mule-info
                    'mode-line-modified
                    'mode-line-frame-identification
                    "%b--"
                    ;; Note that this is evaluated while
                    ;; making the list. It makes a mode line
                    ;; construct which is just a string.
                    (system-name)
                    ;;":"
                    ;;'default-directory
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


;在模式栏中显示当前光标所在函数
;(which-function-mode)

;-------------------------------theme or color----------------
;theme{
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(abbrev-mode t t)
 '(auto-insert-directory "~/.emacs.d/insert/")
 '(auto-insert-mode t)
 '(auto-save-default t)
 '(auto-save-file-name-transforms (\` ((".*" (\, temporary-file-directory) t))))
 '(background-color "black")
 '(backup-by-copying t)
 '(backup-directory-alist (quote (("." . "~/.emacs.d/backups"))))
 '(before-save-hook (quote (copyright-update time-stamp)))
 '(c-echo-syntactic-information-p t)
 '(calendar-chinese-all-holidays-flag t)
 '(color-theme-is-global t)
 '(column-number-mode t)
 '(compile-command "make")
 '(copyright-names-regexp "")
 '(cursor-color "purple")
 '(custom-enabled-themes (quote (light-blue)))
 '(default-buffer-file-coding-system (quote utf-8) t)
 '(default-major-mode (quote text-mode) t)
 '(delete-by-moving-to-trash t)
 '(delete-old-versions t)
 '(dired-kept-versions 1)
 '(echo-keystrokes 0.5)
 '(electric-indent-mode t)
 '(file-name-coding-system (quote utf-8) t)
 '(font-lock-maximum-decoration t)
 '(foreground-color "white")
 '(history-delete-duplicates t)
 '(hs-minor-mode t)
 '(indent-tabs-mode t)
 '(inhibit-default-init t)
 '(inhibit-startup-screen t)
 '(keyboard-coding-system (quote utf-8))
 '(language-environment (quote utf-8))
 '(make-backup-file-name t)
 '(mouse-color "white")
 '(perl-tab-always-indent t)
 '(perl-tab-to-comment t)
 '(query-replace-highlight t)
 '(require-final-newline t)
 ;; safe locals
 ;; mark these as 'safe', so emacs22+ won't give us annoying warnings
 '(safe-local-variable-values (quote ((auto-recompile . t) (folding-mode . t) (outline-minor-mode . t) (sh-indent-comment . t) auto-recompile outline-minor-mode sh-indent-comment)))
 '(search-highlight t)
 '(sh-indent-comment t)
 '(sh-indent-for-after-do (quote +))
 '(sh-indent-for-case-alt (quote +))
 '(sh-indent-for-case-label (quote *))
 '(sh-indent-for-do 0)
 '(sh-indent-for-then 0)
 '(show-paren-delay 0)
 '(show-paren-mode t)
 '(show-paren-style (quote parentheses))
 '(tab-always-indent (quote complete))
 '(tab-width 4)
 '(tempo-insert-region t)
 '(tempo-interactive t)
 '(terminal-coding-system (quote utf-8))
 '(todo-file-do "~/.emacs.d/todo/do")
 '(todo-file-done "~/.emacs.d/todo/done")
 '(todo-file-top "~/.emacs.d/todo/top")
 '(track-eol t)
 '(transient-mark-mode t)
 '(trash-directory "~/.Trash")
 '(truncate-partial-width-windows nil)
 '(uniquify-buffer-name-style (quote forward))
 '(user-full-name "Oxnz")
 '(user-mail-address "yunxinyi@gmail.com")
 '(version-control t)
 '(whitespace-line-column 80)
 '(whitespace-style (quote (trailing lines space-before-tab indentation space-after-tab)))
 '(x-select-enable-clipboard t))

(setq
   initial-scratch-message
   (concat
    ";                  /)\n"
    ";                 //\n"
    ";   .------------| |---------------------------------------------.__\n"
    ";   |   OXNZ     | |>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:>\n"
    ";   `------------| |----------------------------------------------'^^\n"
    ";                 \\\\\n"
    ";                  \\)\n"
    )
   )

;; (setq auto-insert-copyright (user-full-name))
(eval-after-load 'autoinsert
  '(define-auto-insert '(perl-mode . "Perl skeleton")
     '("Description: "
       "#!/usr/bin/env perl" \n
       \n
       "use strict;" \n
       "use warnings;" \n
       _ \n \n
       "__END__" "\n\n"
       "=head1 NAME" "\n\n"
       "=head1 SYNOPSIS" "\n\n"
       (file-name-nondirectory buffer-file-name) " [-h] [-v]" "\n\n"
       "=head1 OPTION" "\n\n"
       "=over 1" "\n\n"
       "=item B<-h|--help>" "\n"
       \n "Print this help message and exit successfully." "\n\n"
       "=item B<-v|--version>" "\n"
       \n "Print version information and exit successfully." "\n\n"
       "=back" "\n\n"
       "=head1 DESCRIPTION" "\n\n\n"
       "=head1 COPYRIGHT" "\n\n"
       "Copyright (c) " (substring (current-time-string) -4) " "
       (getenv "ORGANIZATION") | (progn user-full-name) "\n\n"
       "This library is free software; you can redistribute it and/or" "\n"
       "modify it under the same terms as Perl itself." "\n\n"
       "=cut" "\n")))
(setq time-stamp-active t
	  time-stamp-start "Last-updated: "
	  time-stamp-format "%04y-%02m-%02d %02H:%02M:%02S %Z"
      time-stamp-end "$"
	  )

;Shell 使用 ansi color{
;(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
;(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;}
;---------------------------------------------------------------------


;------------------------------behavior---------------------------------
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
;format
;F9:格式化代码，以使代码缩进清晰，容易阅读
;(global-set-key [f9] 'c-indent-line-or-region)
;;F10:注释 / 取消注释
;(global-set-key [f10] 'comment-or-uncomment-region)
;Ctrl+F11:复制区域到寄存器
;(global-set-key [C-f11] 'copy-to-register)
;;F11:粘贴寄存器内容
;(global-set-key [f11] 'insert-register)
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

;-----------------shell mode---------------
;(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
;(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on t)

;-------------------compile mode------------------
(add-hook 'java-mode-hook
          (lambda(); javac or ant
            (set (make-local-variable 'compile-command) (concat "javac " (buffer-name)))))

;;------------------------faces----------------------
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "LightBlue" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "adobe" :family "Source Code Pro")))))
