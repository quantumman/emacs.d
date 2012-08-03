;;;; never allow spaces after filled lines.
;; (defadvice reindent-then-newline-and-indent (after reindent-then-newline-and-indent-after-advice ())
;;   (delete-trailing-whitespace))
;; (ad-activate 'reindent-then-newline-and-indent 'reindent-then-newline-and-indent-after-advice)

(defadvice previous-line (after previous-line-after-advice ())
  (delete-trailing-whitespace))
x(ad-activate 'previous-line 'previous-line-after-advice)

(defadvice next-line (after next-line-after-advice ())
  (delete-trailing-whitespace))
(ad-activate 'next-line 'next-line-after-advice)

(defadvice view-mode (before view-mode-before-advice ())
  (progn
    (ad-deactivate 'reindent-then-newline-and-indent)
    (ad-deactivate 'next-line)
    (ad-deactivate 'previous-line)))
(ad-activate 'view-mode 'view-mode-before-advice)
;; (ad-deactivate 'view-mode 'view-mode-before-advice)

(defadvice view-mode (after view-mode-after-advice ())
  (progn
    (ad-activate 'reindent-then-newline-and-indent 'reindent-then-newline-and-indent-after-advice)
    (ad-activate 'previous-line 'previous-line-after-advice)
    (ad-activate 'next-line 'next-line-after-advice)))
(ad-activate 'view-mode 'view-mode-after-advice)
;; (ad-deactivate 'view-mode 'view-mode-after-advice)
;;;; end of advices.


(provide 'init.tailing-space-eraser)
