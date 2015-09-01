(require 'clojure-mode)
(require 'clojure-mode-extra-font-locking)
(require 'clj-refactor)
(require 'paredit)
(require 'smartparens)
(require 'rainbow-delimiters)

(add-hook 'clojure-mode-hook #'subword-mode)
(add-hook 'clojure-mode-hook #'paredit-mode)
(add-hook 'clojure-mode-hook #'smartparens-strict-mode)
(add-hook 'clojure-mode-hook #'rainbow-delimiters)

;; indentation for macro
(define-clojure-indent
  (defroutes 'defun)
  (GET 2)
  (POST 2)
  (PUT 2)
  (DELETE 2)
  (HEAD 2)
  (ANY 2)
  (context 2))

(require 'el-init)
(el-init-provide)
