(require 'js2-mode)
(require 'ac-js2)

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json\\'" . js2-mode))

(add-hook 'js2-mode-hook 'skewer-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)
(add-hook 'css-mode-hook 'skewer-css-mode)
(add-hook 'html-mode-hook 'skewer-html-mode)
(add-hook 'web-mode-hook 'skewer-html-mode)

(custom-set-variables
 '(js2-basic-offset 2)
 )

(defun js2-mode-hook-function ()
  (setq indent-tabs-mode nil
        tab-width 2
        auto-complete-mode nil
        company-mode t
        )
  (unload-feature auto-complete-mode t)
  (flycheck-mode)
  )
(add-hook 'js2-mode-hook 'js2-mode-hook-function)

(setq ac-js2-evaluate-calls t)

(require' el-init)
(el-init-provide)
