(require 'color-theme)
(require 'color-theme-buffer-local)

(color-theme-initialize)

(require 'moe-theme)
(load-theme 'moe-dark t)
(moe-theme-set-color 'cyan)

(require 'powerline)
(powerline-moe-theme)
(custom-set-variables
 '(powerline-default-separator 'contour))

(require 'el-init)
(el-init-provide)
