(require 'typescript)
;; (require 'tss)

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))

(defun typescript-mode-hook-function ()
  (setq indent-tabs-mode nil)
  )
(add-hook 'typescript-mode-hook 'typescript-mode-hook-function)

;; (setq tss-popup-help-key "C-:")
;; (setq tss-jump-to-definition-key "C->")
;; (setq tss-implement-definition-key "C-c i")

;; (tss-config-default)

(require 'flycheck)
(flycheck-define-checker typescript
  "A TypeScript syntax checker using tsc command."
  :command ("tsc" "--out" "/dev/null" source)
  :error-patterns
  ((error line-start (file-name) "(" line "," column "): error " (message) line-end))
  :modes typescript-mode)
(add-to-list 'flycheck-checkers 'typescript)

;; (require 'cl)
;; (loop for mode in tss-enable-modes
;;       for hook = (intern-soft (concat (symbol-name mode) "-hook"))
;;       do (add-to-list 'ac-modes mode)
;;       if (and hook (symbolp hook))
;;       do (add-hook hook 'tss-setup-current-buffer t))
;; (add-hook 'kill-buffer 'tss--delete-process t)

(require 'el-init)
(el-init-provide)
