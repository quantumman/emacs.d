(require 'init.haskell-mode)

;;;; ghc-mod
(add-to-list 'exec-path
             (expand-file-name "~/.cabal/bin"))

(autoload 'ghc-init "ghc" nil t)

(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

(defvar ac-source-ghc-completion
  '((candidates . ghc-select-completion-symbol)
    (document . haskell-doc-sym-doc)
    (cache)
    ))

;; add some symbols into ac-sources
(add-hook 'haskell-mode-hook
          '(lambda ()
             (auto-complete-mode t)
             (setq ac-sources
                   '(ac-source-ghc-completion
                     ac-source-yasnippet
                     ac-source-words-in-same-mode-buffers
                     ac-source-abbrev))
             nil ))

(defun pretty-error-message (errs)
  (format "%s"
          (substring
           (mapconcat
            (lambda (x)(ghc-replace-character x ghc-null ghc-newline))
            errs "\n")
           0 -1)))

(defvar ghc-flymake-popup-errors-timer-handler nil)

(provide 'init.ghc-mod)
