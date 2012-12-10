;;;
(require 'csharp-mode)
(push '("\\.cs$" . csharp-mode) auto-mode-alist)

(defvar yas/menu-keymap yas/minor-mode-menu)
(defalias 'yas/snippet-table-fetch 'yas/fetch)
(defalias 'yas/snippet-table 'yas/snippet-table-get-create)
(defalias 'yas/menu-keymap-for-mode 'yas/menu-keymap-get-create)

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
(defvar ac-source-etags
  '((candidates . (lambda ()
                    (all-completions ac-prefix (tags-completion-table))))
    (document . ac-etags-signature)
    (requires . 3))
  "Source for etags.")

(add-hook 'csharp-mode-hook
	  #'(lambda ()
	      (setq c-basic-offset 4
		    tab-width 4
		    indent-tabs-mode t)
	      (c-set-offset 'substatement-open 0)
	      (c-set-offset 'case-label '+)
	      (c-set-offset 'arglist-intro '+)
	      (c-set-offset 'arglist-close 0)
	      (setq ac-sources
		    '(ac-source-etags
		      ac-source-yasnippet
		      ac-source-words-in-same-mode-buffers
		      ac-source-abbrev))
	      )
	  )

(provide 'init.csharp-mode)
