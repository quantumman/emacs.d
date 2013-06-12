;;;; yasnippet
(require 'yasnippet)
(require 'yasnippet-bundle)
(yas/initialize)
(yas/load-directory (expand-file-name "~/.emacs.d/elpa/yasnippet-20120605/snippets"))
;; (add-hook 'jde-mode-hook 'yas/minor-mode-on)
(add-hook 'yatex-mode-hook 'yas/minor-mode-on)
(add-hook 'csharp-mode 'yas/minor-mode-on)
;; (require 'yasnippet-config)
;; (yas/setup  (expand-file-name "~/.emacs.d/plugins/yasnippet"))

(provide 'init.yasnippet)
