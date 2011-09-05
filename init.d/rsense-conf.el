;; rsense

;;; completion
(setq rsense-home (expand-file-name "~/.devel/ruby/rsense"))
(add-to-list 'load-path (concat rsense-home "/etc"))
(require 'cl)
(require 'rsense)
(add-hook 'ruby-mode-hook
	  '(lambda ()
	     (add-to-list 'ac-sources 'ac-source-rsense-method)
	     (add-to-list 'ac-sources 'ac-source-rsense-constant)
	     ))

;;; search document
(setq rsense-rurema-home (expand-file-name "~/.devel/ruby/doc/ruby-refm"))

(provide 'rsense-conf)