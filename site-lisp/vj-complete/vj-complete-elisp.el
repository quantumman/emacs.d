;;; vj-complete-elisp.el --- vj-complete support for Emacs Lisp

;; Copyright (C) 2007  Vagn Johansen

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; Usage: (require 'vj-complete-elisp)
;;   
;; Now you can use C-t for completion in elisp buffers.
;;
;; Has special support for load, require and add-hook.

;;; Code:

(require 'vj-complete)
(require 'thingatpt)


(add-hook 'emacs-lisp-mode-hook 'vj-complete-elisp-setup)

(defun vj-complete-elisp-setup ()
    (setq vj-complete-get-completions-function
        'vj-complete-get-elisp-completions)
    (local-set-key (kbd "C-t") 'vj-complete))


(defun vj-function-arglist (function)
  (let ((arglist (help-function-arglist (symbol-function function))))
    (format "%S" (if (listp arglist)
		     (help-make-usage function arglist)
		   arglist))))

(defun vj-complete-elisp-get-func-doc (symbol)
  (let*
    ((doc (documentation symbol))
      (doc-pair (help-split-fundoc doc (symbol-name symbol)))
      (docstring (cdr doc-pair))

      (docline (if docstring
                 (car (split-string docstring "\\."))
                 (or
		   (car (split-string (or doc "") "\\."))
		   "n/a")))
      (argsline (or (car doc-pair)
                  (vj-function-arglist symbol)))
      )
    (format "%s  %s"
      (replace-regexp-in-string
        (format "^(%s " (regexp-quote (symbol-name symbol))) "(" argsline)
      docline
      )))

(defun vj-complete-get-elisp-documentation (symbol)
  "Get first line of documentation string for SYMBOL including the argument list (if possible)."
  (if (fboundp symbol)
    ;;Emacs22 change
    ;;(vj-complete-elisp-print-function-signature symbol)
    (if (symbolp (symbol-function symbol))
      (format "Aliased to %s" (symbol-name (symbol-function symbol)))
      (vj-complete-elisp-get-func-doc symbol))
    ;; else
    (or
      (if (facep symbol) (propertize "(sample)" 'face symbol))
      (concat
        (if (and (boundp symbol) (numberp (eval symbol)))
          (format "%d. " (eval symbol)))
        (car (split-string
               (or (documentation-property symbol 'variable-documentation)
                 "n/a")
               "\\.")))
      )))

(defun vj-complete-get-require-completions (str)
  (let ((result))
    (dolist (dir load-path)
      (if (file-directory-p dir)
        (dolist (filename (directory-files dir nil (concat "^"
                                                     (regexp-quote str))))
          (add-to-list 'result filename))))
    (mapcar
     (lambda (f)  (list (replace-regexp-in-string "\\..*\\'" "" f) "filename"))
     result)))


;;(vj-filter '(1 2 3 4 5 6 7 8) (lambda (x) (> x 2)) 4)

(defun vj-filter (list predicate &optional limit)
  "Filter out those elements of list LIST for which PREDICATE return nil.

Optionally limit to first LIMIT elements."
  (let ((i 0) (result))
    (dolist (elem list)
      (if limit
        (when (and (< i limit)
                (funcall predicate elem))
          (setq i (1+ i))
          (add-to-list 'result elem t))
        ;; no limit on result list
        (if (funcall predicate elem)
          (add-to-list 'result elem t))))
    result))

(defun vj-complete-get-elisp-completions ()

  (let ((end-point (point)) word result)
    (skip-chars-backward "A-Za-z_0-9-" (point-at-bol))
    (setq vj-complete-current-begin-point (point))

    (setq word (buffer-substring-no-properties (point) end-point))
  
    (setq result
      (cond
        ((equal word "")
          nil)
        ((looking-back "(\\(defun\\|defvar\\) ") ;; don't return anything
          nil)
        ((looking-back "(\\(require\\|load\\|eval-after-load\\) [ ]*[\'\"]")
              (vj-complete-get-require-completions word))

        ((looking-back "(add-hook '")
          (vj-filter (vj-complete-elisp-get-apropos-completions word)
            (lambda (x) (string-match "hook\\|function" (car x)))))

        ((looking-back "(equal major-mode '")
          (vj-filter (vj-complete-elisp-get-apropos-completions word)
            (lambda (x) (string-match "-mode\\'" (car x)))))

        ((looking-back  "[^'](")
          (vj-filter (vj-complete-elisp-get-apropos-completions word)
            (lambda (x) (equal (nth 2 x) "F"))))
      
        (t (vj-complete-elisp-get-apropos-completions word))))
    (goto-char end-point) ;; restore original position
    result))



(defun vj-complete-elisp-get-apropos-completions (word)
  (let ((case-fold-search nil))
    (mapcar
      (lambda (symbol)
        (list
          (symbol-name symbol)
          (vj-complete-get-elisp-documentation symbol)
          (if (fboundp symbol) "F" "V")))
            
      (apropos-internal
        (concat "^" (replace-regexp-in-string "_" ".*" word))
        (lambda (x)
          (let ((case-fold-search nil))
            (not (string-match "char-property" (symbol-name x)))))))))

(provide 'vj-complete-elisp)

;;; vj-complete-elisp.el ends here
