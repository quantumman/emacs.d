(require 'auto-complete)

(setq ac-use-menu-map t)
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)


(defun delete-chars-region (start end)
  (interactive)
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (goto-char (point-min))
      (delete-forward-char (- (point-max) (point-min)))
      )))

(define-region-key global-map (kbd "\C-d")
  'delete-chars-region
  (lambda ()
    (delete-forward-char 1)))
