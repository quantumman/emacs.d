;;;; flymake
;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/config/flymake"))
(require 'flymake-for-csharp)
;; (require 'flymake-extension)
;; (require 'flymake-configuration)
(setq flymake-extension-use-showtip t)
(setq flymake-extension-auto-show nil)

;; remove the function added by flymake-extention for Haskell.
(remove-hook
 'haskell-mode-hook
 '(lambda ()
    ;; use add-to-list rather than push to avoid growing the list for every Haskell file loaded
    (add-to-list 'flymake-allowed-file-name-masks
                 '("\\.l?hs$" flymake-Haskell-init flymake-simple-java-cleanup))
    (add-to-list 'flymake-err-line-patterns
                 '("^\\(.+\\.l?hs\\):\\([0-9]+\\):\\([0-9]+\\):\\(\\(?:.\\|\\W\\)+\\)"
                   1 2 3 4))
    (set (make-local-variable 'multiline-flymake-mode) t)))



(defadvice flymake-get-c-cmdline (around flymake-get-c-cmdline-around-advice ())
    (setq ad-return-value
	  (list "gcc" (list "-Wall" "-fsyntax-only"
			    (concat (ad-get-arg 1) (ad-get-arg 0)))))
    )
(ad-activate 'flymake-get-c-cmdline 'flymake-get-c-cmdline-around-advice)
;; (ad-deactivate 'flymake-get-c-cmdline 'flymake-get-c-cmdline-around-advice)


(defadvice flymake-get-c++-cmdline (around flymake-get-c++-cmdline-around-advice ())
    (setq ad-return-value
	  (list "g++" (list "-Wall" "-fsyntax-only"
			    (concat (ad-get-arg 1) (ad-get-arg 0)))))
    )
(ad-activate 'flymake-get-c++-cmdline 'flymake-get-c++-cmdline-around-advice)
;; (ad-deactivate 'flymake-get-c++-cmdline 'flymake-get-c++-cmdline-around-advice)


(defun flymake-display-current-line-error ()
  "This always tries to return the error message around where it is called."
  (interactive)
  (flymake-extension-show+))


;; (defadvice flymake-mode (before post-command-stuff ())
;;   "Automatically display the error message using popup on the line
;; that failed to flymake "
;;   (set (make-local-variable 'post-command-hook)
;;        (add-hook 'post-command-hook 'flymake-extension-show+)))
;; (ad-activate 'flymake-mode 'post-command-stuff)


(set-face-background 'flymake-errline "pink")
(set-face-foreground 'flymake-errline "red")
(set-face-underline-p 'flymake-errline "red")
(set-face-background 'flymake-warnline "sky blue")
(set-face-foreground 'flymake-warnline "DarkOrange3")
(set-face-underline-p 'flymake-warnline "DarkOrange3")


(defun add-hook-flymake-when-buffer-filled (hook)
  "Enable flymake-mode when the buffer is filled codes."
  (add-hook hook
	    '(lambda ()
	       (if (not (null buffer-file-name))
		   (flymake-mode)
		 nil))))

(add-hook-flymake-when-buffer-filled 'c-mode-hook)
(add-hook-flymake-when-buffer-filled 'c++-mode-hook)
(add-hook-flymake-when-buffer-filled 'csharp-mode-hook)
;; (add-hook-flymake-when-buffer-filled 'haskell-mode-hook)
(add-hook-flymake-when-buffer-filled 'java-mode-hook)
;; (add-hook-flymake-when-buffer-filled 'jde-mode-hook)
;; (add-hook 'objc-mode-hook
;; 	  (lambda ()
;; 	    (flymake-mode t)))


(provide 'init.flymake-mode)
