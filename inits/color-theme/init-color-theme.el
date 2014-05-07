(require 'color-theme)
(require 'color-theme-buffer-local)

(color-theme-initialize)

(load-theme 'base16-railscasts t)
(enable-theme 'base16-railscasts)

(copy-face 'default 'region)
(invert-face 'region)

;; (add-hook 'eshell-mode-hook
;;           (lambda nil (color-theme-buffer-local 'color-theme-tango (current-buffer))))

(require 'el-init)
(el-init:provide)
