;;;; auto completion
;; (require 'auto-complete)
(require 'auto-complete-config)
;; (require 'init-auto-complete)
;; (add-to-list 'ac-dictionary-directories
;; 	     (expand-file-name "~/.emacs.d/plugins/auto-complete/ac-dict"))
(ac-config-default)
(global-auto-complete-mode t)
(ac-set-trigger-key "TAB")
(setq ac-auto-show-menu t)
(setq ac-use-fuzzy t)
;; (setq ac-auto-start 3)
(setq ac-stop-flymake-on-completing t)

(add-to-list 'ac-modes 'html-mode)
(add-to-list 'ac-modes 'ess-mode)
(add-to-list 'ac-modes 'haskell-mode)
(add-to-list 'ac-modes 'emacs-lisp-mode)
(add-to-list 'ac-modes 'objc-mode)
;; (add-to-list 'ac-modes 'jde-mode)
(add-to-list 'ac-modes 'clojure-mode)
(add-to-list 'ac-modes 'yatex-mode)
(add-to-list 'ac-modes 'csharp-mode)
(add-to-list 'ac-modes 'js3-mode)

;; enable pos-tip.el
(require 'pos-tip)
(setq ac-quick-help-prefer-x t)
;; (ac-flyspell-workaround)

;; set sources
;; company mode
(require 'company)
(require 'ac-company)


;; objective c
(ac-company-define-source ac-source-company-xcode company-xcode)
(add-hook 'c-mode-hook
	  '(lambda () (push 'ac-source-semantic ac-sources)))

(add-hook 'c++-mode-hook
	  '(lambda () (push 'ac-source-semantic ac-sources)))

(add-hook 'objc-mode-hook
	  '(lambda () (push 'ac-source-company-xcode ac-sources)))
;; emacs lisp
(ac-company-define-source ac-source-company-elisp company-elisp)
(add-hook 'emacs-lisp-mode-hook
	  '(lambda () (push 'ac-source-company-elisp ac-sources)))
;; css
(ac-company-define-source ac-source-company-css company-css)
(add-hook 'css-mode-hook
	  '(lambda () (push 'ac-source-company-css ac-sources)))

;; yatex
(add-hook 'yatex-mode-hook
	  '(lambda () (push 'ac-source-yasnippet ac-sources)))

;; haskell
;; (require 'auto-complete-extension)
;; (add-hook 'haskell-mode-hook
;; 	  '(lambda ()
;; 	     (push 'ac-source-haskell ac-sources)
;; 	     (push 'ac-source-yasnippet ac-sources)))

(require 'auto-complete-config)


(provide 'init.auto-complete)