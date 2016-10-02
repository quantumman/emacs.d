(require 'typescript)
;; (require 'tide)

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))

(defun typescript-mode-hook-function ()
  (setq indent-tabs-mode nil
        typescript-indent-level 2
        )

  ;; (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (company-mode-on))
(add-hook 'typescript-mode-hook 'typescript-mode-hook-function)

(require 'el-init)
(el-init-provide)

