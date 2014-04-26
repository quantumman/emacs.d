(setq message-log-max 10000)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/auto-install"))
;;;; auto-install.el
(require 'auto-install)
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)

(require 'cl)

(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'pallet)

;; save load-path for debug
(require 'save-load-path)
(save-load-path-initialize)

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
;; (when
;;     (load
;;      (expand-file-name "~/.emacs.d/elpa/package.el"))
;;   (package-initialize))


(add-to-list 'load-path (expand-file-name "~/.emacs.d/init.d"))
(let ((default-directory "~/.emacs.d/init.d"))
  (load (expand-file-name "~/.emacs.d/init.d/subdirs.el")))
;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp"))
;; (let ((default-directory "~/.emacs.d/site-lisp"))
;;   (load (expand-file-name "~/.emacs.d/site-lisp/subdirs.el")))


(defun directory-dirs (dir)
  "Find all directories in DIR."
  (unless (file-directory-p dir)
    (error "Not a directory `%s'" dir))
  (let ((dir (directory-file-name dir))
        (dirs '())
        (files (directory-files dir nil nil t)))
    (dolist (file files)
      (unless (member file '("." ".."))
        (let ((file (concat dir "/" file)))
          (when (file-directory-p file)
            (setq dirs (append (cons file
                                     (directory-dirs file))
                               dirs))))))
    (add-to-list 'dirs dir)))

(defun add-to-load-path-recursively (base)
  (loop for dir in (directory-dirs base)
        do (add-to-list 'load-path dir)))

(add-to-load-path-recursively (expand-file-name "~/.emacs.d/site-lisp"))

;;;; init-check
;; (require 'emacs-init-check)
;; (setq auto-emacs-init-check-file-regexp "/\\.emacs\\.d/")
;; (add-hook 'vc-checkin-hook 'auto-emacs-init-check)

(require 'init.char-code)

;;;; environment test utility
(require 'env-test)
;;;;

;; (require 'multi-term)
;; (setq multi-term-program shell-file-name)
;; (custom-set-variables
;;  '(term-default-bg-color "#000000")        ;; background color (black)
;;  '(term-default-fg-color "#FFFFFF"))       ;; foreground color (yellow)

(require 'windmove)

(require 'init.appearance)

(when (file-exists-p (expand-file-name "~/.rsense"))
  (require 'rsense-conf nil nil))

(require 'init.auto-complete)

(require 'init.bm)

(require 'init.buffer-conf)

(require 'init.eldoc)

(require 'init.emacs-server)

(require 'init.ffap-bindings)

(require 'init.flymake-mode)

(require 'init.haskell-mode)

(require 'init.fsharp-mode)

(require 'init.ghc-mod)

(require 'init.misc-util)

(require 'init.objective-c-mode)

(require 'init.key-chrod)

(require 'init.paredit)

(require 'init.sequential-command)

(when linux-p (require 'init.skype))

(require 'init.viewer)

(require 'init.yasnippet)

(require 'init.yatex)

(require 'init.html-fold)

(require 'init.org-mode)

(require 'init.elscreen)
;;;

(require 'egg)

;;; Powershell
(when windows-p
  (require 'powershell)
  (require 'powershell-mode)
  (push '("\\.ps1$" . powershell-mode) auto-mode-alist)
  (add-to-list 'ac-modes 'powershell-mode)
  (setq powershell-indent 4))

;;;
(require 'text-adjust)

;;;
(require 'git-commit)
(set-face-bold-p 'git-commit-summary-face nil)
(define-key git-commit-map (kbd "\C-x\C-c")
  (lambda ()
    (interactive)
    (save-buffer)
    (flet ((yes-or-no-p (arg) t))
      (kill-buffer))
    (elscreen-kill)
    ))

(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
(global-set-key (kbd "\C-x0") 'popwin:close-popup-window)

;;;

(require 'ediff)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)
;; (require 'git-emacs)

(require 'init.csharp-mode)

;;;

(require 'point-undo)
(define-key global-map [f7] 'point-undo)
(define-key global-map [f9] 'point-redo)

;;;

(require 'redo+)
(setq undo-limit 60000000)
(setq undo-strong-limit 90000000)

;;;

(require 'color-moccur)
(require 'moccur-edit)
(setq moccur-split-word t)
(setq dmoccur-exclusion-mask
      (append '("\\~$" "\\.o$" "\\.hi$") dmoccur-exclusion-mask))

(require 'occur-schroeder)
(define-key occur-mode-map (kbd "\C-s o") 'isearch-occur)
(define-key occur-mode-map (kbd "\C-s n") 'next-error)
(define-key occur-mode-map (kbd "\C-s p") 'previous-error)

;;;; option key to meta key in the mac
(when carbon-p (setq mac-option-modifier 'meta))

;;;; specify the path to bash.exe on cygwin in windows
(when (and cygwin-p windows-p)
  (setq shell-file-name "C:\\cygwin\\bin\\bash.exe")
  (setq explicit-shell-file-name shell-file-name))

;;;; do not save backup files
(setq make-backup-files nil)
(setq auto-save-default nil)
;;;; auto revert
(global-auto-revert-mode t)


;;;; test case mode
(require 'test-case-mode)
(add-hook 'find-file-hook 'enable-test-case-mode-if-test)

;;;; itunes
(when (or darwin-p carbon-p) (require 'itunes))

;;; see colors quickly
(require 'quick-color)
;;;; #eee409

;;;; zen-coding mode
(require 'zencoding-mode)

;;;; minor mode hack
(require 'minor-mode-hack)


;;;; shell

(require 'shell-history)
(require 'background)

;; escape sequence
(autoload 'ansi-color-for-comit-mode-on "ansi-color"
  "Set 'ansi-color-for-comint-mode' to t." t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;;;; sticky
(require 'sticky)

;;;;;

;;;; junk file
(require 'open-junk-file)
(setq open-junk-file-format (expand-file-name "~/junk/%Y-%m-%d-%H%M%S."))

;;;; buffer summary
(require 'summarye)

;;;; hideif.el
(require 'hideif)
(add-hook 'c-mode-common-hook 'hide-ifdef-mode)


;;;; folding code blocks
(require 'hideshow)
(require 'fold-dwim)

;;;; display current function name
(which-func-mode 1)
(setq which-func-modes t)
(delete (assoc 'which-func-mode mode-line-format) mode-line-format)
(setq-default header-line-mode '(which-func-mode ("" which-func-format)))

;;;; multiverse: take snapshots
(require 'multiverse)

;;;; auto-save-buffer
(require 'auto-save-buffers)
(defvar auto-save-idle-timer nil)
(setq auto-save-idle-timer
 (run-with-idle-timer 1 t 'auto-save-buffers))


;;;; ispell
(add-to-list 'load-path (expand-file-name "~/.emacs.d/config/ispell"))
(require 'flyspell-check)
(require 'ispell-configuration)


;;;;

;;;; region
(transient-mark-mode t)


;;;; misc
;; parenthesis
(show-paren-mode)
;; show column number
(column-number-mode t)
;; blink cursor
(blink-cursor-mode t)


;;;; emacs lisp
(require 'lispxmp)
(require 'edit-list)
(require 'el-expectations)


;;;; miscs
;; indent atomically when you return
(global-set-key "\C-m" 'reindent-then-newline-and-indent)
(global-set-key "\C-j" 'newline)


;;;; auto async byte compile mode
(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-hook-mode 'enable-auto-async-byte-compile-mode)
(custom-set-variables
 '(auto-async-byte-compile-display-function 'display-buffer)
 )
(require 'popwin)
(push '(" *auto-async-byte-compile*" :height 14 :position bottom :noselect t)
      popwin:special-display-config)


;;;; w3m
(when (or darwin-p carbon-p)
  (add-to-list 'load-path "/Applications/Emacs.app/Contents/Resource/share/emacs/site-lisp/w3m/"))
(when linux-p (add-to-list 'load-path "/usr/share/emacs/site-lisp/"))
;; (require 'w3m-load)

;;;; Toggle transparency and opacity mode
(set-frame-parameter nil 'alpha '(100 . 100))
(defun switch-opacity (opacityp)
  (let ((alpha-value (if opacityp '(100 . 100) '(0 . 0)) )
        (lockp (if opacityp 0 1)))
    (set-frame-parameter nil 'alpha alpha-value)
    (toggle-read-only lockp)))

(eval-when-compile (require 'cl))
 (defun toggle-opacity ()
   (interactive)
   (let ((opacity (frame-parameter nil 'alpha))
         (opacity-switcher #'(lambda () (switch-opacity t))))
     (if (= 100 (if (listp opacity)
                    (car opacity) opacity))
         (switch-opacity nil)
       (switch-opacity t))))
(global-set-key (kbd "C-c t") 'toggle-opacity)


;; Line Number
(global-linum-mode t)

;; 行番号のフォーマット
(set-face-attribute 'linum nil :foreground "grey40" :height 0.7)
(setq linum-format "%4d")

;; iconify
(global-set-key (kbd "\C-z\C-z")
                'iconify-or-deiconify-frame)

(require 'rst-goodies)
(require 'rst)

(require 'windmove)               ; to load the package
(windmove-default-keybindings)    ; default keybindings

(require 'riece nil t)

(setq-default bidi-display-reordering
             nil
             bidi-paragraph-direction
             'left-to-right)

(require 'rebase-mode)

(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\\.feature$" . feature-mode))

(setq indent-tabs-mode nil)

(load-file (expand-file-name "~/.emacs.d/auto-install/camelCase-mode.el"))
(require 'camelCase)

(require 'guide-key)
(setq guide-key/guide-key-sequence '("C-x r" "C-x 4"))
(setq guide-key/popup-window-position 'bottom)
(guide-key-mode 1)

(add-hook 'org-mode-hook
          '(lambda ()
             (guide-key/add-local-guide-key-sequence "C-c")
             (guide-key/add-local-guide-key-sequence "C-c C-x")
             (guide-key/add-local-highlight-command-regexp "org-")))

(add-hook 'feature-mode
          '(lambda ()
             (guide-key/add-local-guide-key-sequence "C-c")
             (guide-key/add-local-highlight-command-regexp "feature-")))

(add-hook 'ruby-mode-hook
          '(lambda ()
             (ruby-electric-mode t)))

(add-hook 'eclim-mode-hook
          '(lambda ()
             (guide-key/add-local-guide-key-sequence "C-c C-e")
             (guide-key/add-local-highlight-command-regexp "eclim-")))

(require 'rainbow-delimiters)
(global-rainbow-delimiters-mode t)

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C--") 'er/contract-region)

(require 'multiple-cursors)

(add-hook 'before-save-hook
          (lambda ()
            (unless (and windows-p (eq major-mode 'csharp-mode))
              (my-delete-trailing-whitespace))))

(setq require-final-newline t)

(require 'nxml-mode)
(add-to-list 'auto-mode-alist '("\\.html$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.htm$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.xhtml$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.shtml$" . nxml-mode))
(setq nxml-slash-auto-complete-flag t
      nxml-child-indent 2
      nxml-attribute-indent 4
      nxml-sexp-element-flag t)

(eval-after-load "rng-loc"
  '(add-to-list 'rng-schema-locating-files (expand-file-name "~/.emacs.d/site-lisp/html5-el/schemas.xml")))
(require 'whattf-dt)

(require 'gitsum)

(display-time)
(setq display-time-string-forms '((format "%s:%s" 24-hours minutes)))

;; (display-battery-mode nil)

(require 'historyf)
(when (and (executable-find "cmigemo")
           (require 'migemo nil t))
  ;; cmigemoを使う
  (setq migemo-command "cmigemo")
  ;; migemoのコマンドラインオプション
  (setq migemo-options '("-q" "--emacs" "-i" "\a"))
  ;; migemo辞書の場所
  (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
  ;; cmigemoで必須の設定
  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  ;; キャッシュの設定
  (setq migemo-use-pattern-alist t)
  (setq migemo-use-frequent-pattern-alist t)
  (setq migemo-pattern-alist-length 1000)
  (setq migemo-coding-system 'utf-8-unix)

  ;; migemoを起動する
  (migemo-init))

(add-hook 'java-mode-hook
          '(lambda ()
             (setq indent-tabs-mode nil
                   tab-width 4
                   )))

;; Eclim
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(eclim-eclipse-dirs (quote ("/Application/eclipse")))
 '(haskell-notify-p t)
 '(haskell-process-args-cabal-repl (quote ("--ghc-option=-ferror-spans")))
 '(haskell-process-path-cabal (expand-file-name "~/Library/Haskell/bin/cabal"))
 '(haskell-process-type (quote cabal-repl))
 '(haskell-stylish-on-save t)
 '(haskell-tags-on-save t)
 '(server-kill-new-buffers t))

(require 'eclim)
(setq eclim-eclipse-dirs
      (cond (windows-p "")
            (linux-p "")
            (darwin-p "/Application/eclipse")))
(global-eclim-mode)
(require 'eclimd)
(require 'ac-emacs-eclim-source)
(ac-emacs-eclim-config)


(setq visible-bell nil)
(setq ring-bell-function 'ignore)

(setq sr-speedbar-right-side nil
      speedbar-use-images t
      )

(setq helm-split-window-default-side 'below
      helm-split-window-default-side-p t)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/el-init"))
(require 'el-init)
(setq el-init:load-directory-list
      '("macro"
        "common"
        "elisp-util"
        "keybinding"
        "eshell"
        "helm"
        "tab"
        "color-theme"
        "command"
        "sns"
        "mode"
        "devel-util"
        ))
(el-init:load "~/.emacs.d/inits")

(set-frame-parameter (selected-frame) 'alpha '(95 95))

(require 'powerline)
(defun my-powerline-default-theme ()
  "Setup my default mode-line."
  (interactive)
  (setq-default mode-line-format
                '("%e"
                  (:eval
                   (let* ((active (powerline-selected-window-active))
                          (face1 (if active 'powerline-active1
                                   'powerline-inactive1))
                          (face2 (if active 'powerline-active2
                                   'powerline-inactive2))
                          (lhs (list
                                (powerline-raw "%*" face2 'l)
                                (powerline-buffer-size face2 'l)
                                (powerline-buffer-id face2 'l)

                                (powerline-raw " " face2)
                                (powerline-arrow-right face2 face1)
                                (powerline-raw which-func-format face1)
                                (powerline-vc face1)

                                (powerline-arrow-right face1 face2)

                                (powerline-major-mode face2 'l)
                                (powerline-process face2)
                                (powerline-minor-modes face2 'l)
                                (powerline-narrow face2 'l)
                                ))
                          (rhs (list
                                (powerline-raw global-mode-string face2 'r)

                                (powerline-arrow-left face2 face1)

                                (powerline-raw "%4l" face1 'r)
                                (powerline-raw ":" face1)
                                (powerline-raw "%3c" face1 'r)

                                (powerline-arrow-left face1 nil)

                                (powerline-raw "%6p" nil 'r)

                                (powerline-hud face2 face1))))
                     (concat
                      (powerline-render lhs)
                      (powerline-fill face2 (powerline-width rhs))
                      (powerline-render rhs)))))))
(my-powerline-default-theme)

(custom-set-faces
 '(powerline-active1 ((t (:background "light salmon" :inherit mode-line))))
 '(powerline-active2 ((t (:background "navajo white" :inherit mode-line))))
 '(powerline-inactive1 ((t (:background "light salmon" :inherit mode-line))))
 '(powerline-inactive2 ((t (:background "navajo white" :inherit mode-line))))
 )



;;;; confirm the source reading finished til the end of this buffer.
(print "Load all the files!")
