(require 'color-theme)
(require 'color-theme-buffer-local)

(load-file (expand-file-name "~/.emacs.d/inits/color-theme/base16-railscasts-theme.el"))

(color-theme-initialize)

(load-theme 'base16-railscasts)
(enable-theme 'base16-railscasts)

(copy-face 'default 'region)
(invert-face 'region)

;; Use visible color combination for some faces
;; because "base16-railscasts" theme makes those faces be invisible color balance.
(copy-face 'git-commit-text-face 'git-commit-summary-face)

;; (add-hook 'eshell-mode-hook
;;           (lambda nil (color-theme-buffer-local 'color-theme-tango (current-buffer))))

(require 'el-init)
(el-init-provide)
