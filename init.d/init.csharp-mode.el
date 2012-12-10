;;;
(require 'csharp-mode)
(push '("\\.cs$" . csharp-mode) auto-mode-alist)

(defvar yas/menu-keymap yas/minor-mode-menu)
(defalias 'yas/snippet-table-fetch 'yas/fetch)
(defalias 'yas/snippet-table 'yas/snippet-table-get-create)
(defalias 'yas/menu-keymap-for-mode 'yas/menu-keymap-get-create)

(defvar my:ac-source-etags
  '((candidates . (lambda ()
		    (all-completions ac-target (tags-completion-table))))
    (summary . (lambda (highlighted-keyword)
		 (save-excursion
		   (let ((buf (find-tag-noselect highlighted-keyword)))
		     (with-current-buffer buf
		       (goto-char (point))
		       (let ((line-point (bounds-of-thing-at-point 'line)))
			 (buffer-substring-no-properties (car line-point) (- (cdr line-point) 1))
			 )
		       )
		     )
		   )
		 )
	     )
    (candidate-face . ac-etags-candidate-face)
    (selection-face . ac-etags-selection-face)
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
	      (add-to-list 'ac-sources my:ac-source-etags) 
	      )
	  )

(provide 'init.csharp-mode)
