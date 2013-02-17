(setq message-log-max 1000)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/auto-install"))
;;;; auto-install.el
(require 'auto-install)
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)

(require 'cl)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/loader"))
(require 'el-init)
(setq el-init:load-directory-list '("keybinding" "eshell" "helm" "color-theme" "command"))
(el-init:load "~/.emacs.d/inits")

;; save load-path for debug
(require 'save-load-path)
(save-load-path-initialize)

;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/package/"))
(when
    (when (< emacs-major-version 24)
      (load (expand-file-name "~/.emacs.d/elpa/package.el")))
  (package-initialize))
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

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

;; (require 'init.calendar)

(require 'init.eldoc)

;; (require 'init.elscreen)
;; (require 'init.tabbar)
;; (tabbar-mode t)

(require 'init.emacs-server)

(require 'init.ffap-bindings)

(require 'init.flymake-mode)

(require 'init.haskell-mode)

(require 'init.fsharp-mode)

(require 'init.ghc-mode)

(require 'init.misc-util)

(require 'init.objective-c-mode)

(require 'init.key-chrod)

(require 'init.paredit)

(require 'init.sequential-command)

(when linux-p (require 'init.skype))

(require 'init.twitter)

(require 'init.viewer)

(require 'init.yasnippet)

(require 'init.yatex)

(require 'init.html-fold)

;; (require 'init.el-get)

(require 'init.eshell)

(require 'init.org-mode)

(require 'init.elscreen)
;;;

(require 'egg)

;;; Powershell
(require 'powershell)
(require 'powershell-mode)
(push '("\\.ps1$" . powershell-mode) auto-mode-alist)
(add-to-list 'ac-modes 'powershell-mode)
(setq powershell-indent 4)

;;;
(require 'text-adjust)

;;;
(require 'git-commit)
(set-face-bold-p 'git-commit-summary-face nil)

(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)

;;;

(require 'sr-speedbar)
(setq sr-speedbar-right-side t)

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

;;;; full screen
(cond (linux-p (require 'fullscreen))
      (cocoa-p (require 'init.fullscreen-mac)))



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

;;;; tramp
;;(add-to-list 'load-path (expand-file-name "~/.emacs.d/config/tramp"))
;;(require 'tramp-setting)

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


;;;; facefook
;; (require 'facebook)

;;;; miscs
;; indent atomically when you return
(global-set-key "\C-m" 'reindent-then-newline-and-indent)
(global-set-key "\C-j" 'newline)


;;;; auto async byte compile mode
(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-hook-mode 'enable-auto-async-byte-compile-mode)

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


(require 'init.custom-key-binding)

;; Line Number
(global-linum-mode t)

;; 行番号のフォーマット
(set-face-attribute 'linum nil :foreground "grey40" :height 0.7)
(setq linum-format "%4d")

;; iconify
(global-set-key (kbd "\C-z\C-z")
                'iconify-or-deiconify-frame)

;; (defun linum-dynamic-format ()
;;   (setq linum-format
;;      (concat "%"
;;              (format "%dd"
;;                      (+ 1
;;                         (length
;;                          (int-to-string
;;                           (count-lines (point-min) (point-max)))))))))
;; (defadvice next-line (after next-line-after-advice ())
;;   (linum-dynamic-format))
;; (ad-activate 'next-line 'next-line-after-advice)
;; ;; (ad-deactivate 'next-line)
;; (defadvice previous-line (after previous-line-after-advice ())
;;   (linum-dynamic-format))
;; (ad-activate 'previous-line 'previous-line-after-advice)
;; ;; (ad-deactivate 'previous-line)

;; (global-set-key (kbd "C-c t") '(lambda ()
;;                                 (interactive)
;;                                 (term shell-file-name)))

;; resume windows after init elisp
(defadvice yes-or-no-p (around yes-or-no-always-yes)
  "Return alwasy yes."
  (setq ad-return-value t))

;; (add-hook 'after-init-hook
;;           #'(lambda ()
;;               (ad-activate 'yes-or-no-p)
;;               (resume-windows)
;;               (ad-deactivate 'yes-or-no-p)))

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

(require 'rainbow-delimiters)
(global-rainbow-delimiters-mode t)

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C--") 'er/contract-region)

(require 'multiple-cursors)

(add-hook 'before-save-hook 'my-delete-trailing-whitespace)

(setq require-final-newline t)

;;;; confirm the source reading finished til the end of this buffer.
(print "Load all the files!")
