;;;
(require 'csharp-mode)
(push '("\\.cs$" . csharp-mode) auto-mode-alist)

(defvar yas/menu-keymap yas/minor-mode-menu)

(defun ac-etags-signature (keyword)
  (save-excursion
    (let ((buf (find-tag-noselect keyword)))
      (with-current-buffer buf
        (goto-char (point))
        (let* ((line-point (bounds-of-thing-at-point 'line))
               (signature (buffer-substring-no-properties (car line-point) (- (cdr line-point) 1))))
          (when (string-match "^[ \t]*" signature)
            (replace-match "" nil nil signature)
            ))))))

(require 'etags)
(require 'auto-complete-etags)
(require 'helm-config)
(require 'helm-git)
(require 'helm-etags+)
(require 'ctags-update)
(require 'flyspell)

(define-key flyspell-mode-map (kbd "C-,") 'helm-c-etags-select)
(define-key flyspell-mode-map (kbd "C-.") 'helm-etags+-select)
(define-key csharp-mode-map (kbd "C-,") 'helm-c-etags-select)
(define-key csharp-mode-map (kbd "C-.") 'helm-etags+-select)
(define-key csharp-mode-map (kbd "M-f") 'helm-git-find-files)
(define-key csharp-mode-map (kbd "<return>") 'newline)

(add-hook 'csharp-mode-hook
	  #'(lambda ()
	      (setq c-basic-offset 4
		    tab-width 4
		    indent-tabs-mode t)
	      (c-set-offset 'substatement-open 0)
	      (c-set-offset 'case-label '+)
	      (c-set-offset 'arglist-intro '+)
	      (c-set-offset 'arglist-close 0)
	      (flymake-mode)
	      (setq ac-sources
		    '(;; ac-source-etags
		      ac-source-yasnippet
		      ac-source-words-in-same-mode-buffers
		      ac-source-abbrev))
	      )
	  )

(provide 'init.csharp-mode)
