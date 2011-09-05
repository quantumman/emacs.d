;;;; doc view mode
(require 'doc-view)
(define-key doc-view-mode-map "n" 'doc-view-next-page)
(define-key doc-view-mode-map "p" 'doc-view-previous-page)

;;;; view mode
(setq view-read-only t)
(require 'view)
(define-key view-mode-map (kbd "N") 'View-search-last-regexp-backward)
(define-key view-mode-map (kbd "?") 'View-search-regexp-backward)
(define-key view-mode-map (kbd "G") 'View-goto-line-last)
(define-key view-mode-map (kbd "b") 'View-scroll-page-backward)
(define-key view-mode-map (kbd "f") 'View-scroll-page-forward)

(require 'viewer)
(viewer-stay-in-setup)
(setq viewer-modeline-color-unwritable "tomato")
(setq viewer-modeline-color-view "orange")
(viewer-change-modeline-color-setup)


(provide 'init.viewer)