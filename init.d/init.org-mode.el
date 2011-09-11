(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key org-mode-map (kbd "\C-cl") 'org-store-link)
(define-key org-mode-map (kbd "\C-ca") 'org-agenda)
(setq org-log-done t)

(setq org-agenda-files (list "~/org/work.org"
			     "~/org/home.org"))

(provide 'init.org-mode)

