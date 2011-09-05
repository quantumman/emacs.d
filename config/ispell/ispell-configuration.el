;; command
(global-set-key "\C-w" 'ispell-word)

;; auto check
(autoload 'ispell-word "ispell" "Check the spelling of word in buffer." t)
(autoload 'ispell-region "ispell" "Check the spelling of region." t)
(autoload 'ispell-buffer "ispell" "Check the spelling of buffer." t)
(autoload 'ispell-complete-word "ispell" "Look up current word in dictionary and try to complete it." t)
(autoload 'ispell-change-dictionary "ispell" "Change ispell dictionary." t)
(autoload 'ispell-message "ispell" "Check spelling of mail message or newsx post.")
(defun ispell-tex-buffer-p ()
  (memq major-mode '(plain-tex-mode latex-mode slitex-mode yatex-mode)))
(setq ispell-enable-tex-parser t)

;; japanese is in sentence
(eval-after-load "ispell"
  '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))

;; latex
(setq ispell-filter-hook-args '("-w"))
(setq TeX-mode-hook
      (function
       (lambda ()
	 (setq ispell-filter-hook "detex"))))

;; exhaneg ispell to aspell
(setq-default ispell-program-name "aspell")

;; set keystroke
(global-set-key "\C-c\C-w" 'ispell-complete-word)

(provide 'ispell-configuration)
