;; display emacs lisp function's helps in the echo area
(require 'eldoc)
(require 'eldoc-extension)
(require 'c-eldoc)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(add-hook 'c-mode-hook 'turn-on-eldoc-mode)
(setq eldoc-idle-delay 0.1)
(setq eldoc-minor-mode-string "")
(setq eldoc-echo-area-use-multiline-p t)

(provide 'init.eldoc)