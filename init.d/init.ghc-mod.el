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

(defvar ac-source-ghc-module
  '((candidates . ghc-module-names)
    (prefix . "^import\\s+*")
    (cache)
    ))

;; add some symbols into ac-sources
(add-hook 'haskell-mode-hook
          '(lambda ()
             (auto-complete-mode t)
             (setq ac-sources
                   '(ac-source-ghc-completion
                     ac-source-ghc-module
                     ac-source-yasnippet
                     ac-source-words-in-same-mode-buffers
                     ac-source-abbrev))
             nil ))

(defun ghc-flymake-display-errors-popup ()
  (interactive)
  (when (and (ghc-flymake-have-errs-p)
             (not ac-completing))
    (let* ((title (ghc-flymake-err-title))
           (errs (ghc-flymake-err-list))
           (errmsg (pretty-error-message errs)))
      (pos-tip-show errmsg nil nil nil 0)
      )))

(defun pretty-error-message (errs)
  (format "%s"
          (substring
           (mapconcat
            (lambda (x)(ghc-replace-character x ghc-null ghc-newline))
            errs "\n")
           0 -1)))

(defvar ghc-flymake-popup-errors-timer-handler nil)

(defvar ghc-flymake-popup-errors-key "\C-c\C-SPC")
(add-hook 'haskell-mode-hook
          (lambda ()
            (define-key haskell-mode-map ghc-flymake-popup-errors-key
              'ghc-flymake-display-errors-popup)
            (setq ghc-flymake-popup-errors-timer-handler
                  (run-with-idle-timer
                   1.0 t
                   #'ghc-flymake-display-errors-popup))))

(provide 'init.ghc-mode)
