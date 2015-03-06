(require 'nxml-mode)
(require 'whattf-dt)

(setq nxml-slash-auto-complete-flag t
      nxml-child-indent 4
      nxml-attribute-indent 4
      nxml-sexp-element-flag t)

(add-hook 'nxml-mode-hook 'nxml-mode-hook-function)

(defun nxml-mode-hook-function ()
  (setq indent-tabs-mode nil)
  )

(add-to-list 'auto-mode-alist '("\\.html\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.htm\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.xhtml\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.shtml\\'" . nxml-mode))

(eval-after-load "rng-loc"
  '(add-to-list 'rng-schema-locating-files (expand-file-name "~/.emacs.d/site-lisp/html5-el/schemas.xml")))

(require 'el-init)
(el-init:provide)
