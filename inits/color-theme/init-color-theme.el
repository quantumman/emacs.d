(require 'color-theme)
(require 'color-theme-buffer-local)

(color-theme-initialize)

(load-theme 'solarized-light t)

;; (add-hook 'eshell-mode-hook
;;           (lambda nil (color-theme-buffer-local 'color-theme-tango (current-buffer))))

(require 'el-init)
(el-init:provide)
