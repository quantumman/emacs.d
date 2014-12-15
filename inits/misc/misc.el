(require 'phi-search-migemo)
;;; 設定例に書いてるのはコマンド名が間違っている
(define-key phi-search-default-map (kbd "M-m") 'phi-search-migemo-toggle)
(with-eval-after-load 'multiple-cursors-core
  (define-key mc/keymap (kbd "C-s") 'phi-search-migemo)
  (define-key mc/keymap (kbd "C-r") 'phi-search-migemo-backward))

(require 'el-init)
(el-init:provide)
