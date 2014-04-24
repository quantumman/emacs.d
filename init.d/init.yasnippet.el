;;;; yasnippet
(require 'yasnippet)
(yas/initialize)
(yas/load-directory (expand-file-name "~/.emacs.d/snippets"))
;; (add-hook 'jde-mode-hook 'yas/minor-mode-on)
(add-hook 'yatex-mode-hook 'yas/minor-mode-on)
(add-hook 'csharp-mode 'yas/minor-mode-on)
;; (require 'yasnippet-config)
;; (yas/setup  (expand-file-name "~/.emacs.d/plugins/yasnippet"))

(provide 'init.yasnippet)
