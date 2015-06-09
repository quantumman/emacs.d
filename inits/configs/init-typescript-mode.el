(require 'typescript)
;; (require 'tss)

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))

;; (setq tss-popup-help-key "C-:")
;; (setq tss-jump-to-definition-key "C->")
;; (setq tss-implement-definition-key "C-c i")

;; (tss-config-default)

(require 'el-init)
(el-init-provide)
