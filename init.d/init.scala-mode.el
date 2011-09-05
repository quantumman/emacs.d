;;;; scala mode
(add-to-list 'load-path "/opt/local/share/scala/misc/scala-tool-support/emacs")
(require 'scala-mode-auto)
;; cooperate with yasnippet
(yas/load-directory
 (expand-file-name "~/.emacs.d/plugins/yasnippet/snippets/text-mode/scala-mode"))
(add-hook 'scala-mode-hook
	  '(lambda ()
	     (yas/minor-mode-on)
	     ))

(provide 'init.scala-mode)