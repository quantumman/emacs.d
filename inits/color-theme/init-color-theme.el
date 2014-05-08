(require 'color-theme)
(require 'color-theme-buffer-local)

(color-theme-initialize)

(load-theme 'base16-railscasts t)
(enable-theme 'base16-railscasts)

(copy-face 'default 'region)
(invert-face 'region)

;; Use visible foreground color for git commit summary
;; because "base16-railscasts" theme uses invisible color for git commit summary.
(copy-face 'git-commit-text-face 'git-commit-summary-face)

;; (add-hook 'eshell-mode-hook
;;           (lambda nil (color-theme-buffer-local 'color-theme-tango (current-buffer))))

(require 'el-init)
(el-init:provide)
