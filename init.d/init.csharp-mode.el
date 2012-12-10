;;;
(require 'csharp-mode)
(push '("\\.cs$" . csharp-mode) auto-mode-alist)

(defvar yas/menu-keymap yas/minor-mode-menu)
(defalias 'yas/snippet-table-fetch 'yas/fetch)
(defalias 'yas/snippet-table 'yas/snippet-table-get-create)
(defalias 'yas/menu-keymap-for-mode 'yas/menu-keymap-get-create)

(add-hook 'csharp-mode-hook
	  #'(lambda ()
	      (setq c-basic-offset 4
		    tab-width 4
		    indent-tabs-mode t)
	      (c-set-offset 'substatement-open 0)
	      (c-set-offset 'case-label '+)
	      (c-set-offset 'arglist-intro '+)
	      (c-set-offset 'arglist-close 0)
	      )
	  )

(provide 'init.csharp-mode)
