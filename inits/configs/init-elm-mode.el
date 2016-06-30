(require 'elm-mode)
(require 'company)

(add-hook 'elm-mode-hook #'elm-oracle-setup-completion)
(add-to-list 'company-backends 'company-elm)
(define-key elm-mode-map [<return>] ' indent)

(require 'el-init)
(el-init-provide)
