(require 'js2-mode)
(require 'ac-js2)

(add-to-list 'auto-mode-alist '("\\.js\\" . js2-mode))

(add-hook 'js2-mode-hook 'skewer-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)
(add-hook 'css-mode-hook 'skewer-css-mode)
(add-hook 'html-mode-hook 'skewer-html-mode)
(add-hook 'web-mode-hook 'skewer-html-mode)


(setq ac-js2-evaluate-calls t
      )
