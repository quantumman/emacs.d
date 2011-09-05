;;;; a little bit config for programming
;; sort included packages.
(defun point-to-beginnnig-line ()
  (save-restriction
    (beginning-of-line)
    (point)))

(defun sort-lines-regex (reg)
  "This is a function to sort lines by regex,
which are placing near by each other."
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (re-search-forward reg)
    (let ((point (point-to-beginnnig-line)))
      (while (re-search-forward reg nil t))
      (sort-lines nil point (point)))))

(defun sort-c-include-lines ()
  "Sort the include macros of C/C++."
  (interactive)
  (sort-lines-regex "^#include\s*<.+>$"))

;;;; Do not ask to kill process(es) when closing the emacs.
(defadvice save-buffers-kill-terminal (before save-buffers-kill-terminal-before-advice ())
  (when (process-list)
    (dolist (p (process-list))
      (set-process-query-on-exit-flag p nil))))
(ad-activate 'save-buffers-kill-terminal 'save-buffers-kill-terminal-before-advice)
;; (ad-deactivate 'save-buffers-kill-terminal)


;; Finish all the processes
(defun exit-emacs-after-terminating-all-the-processes ()
  "This finishes all the processes before terminate emacs"
  (interactive)
  (progn
    (mapcar (lambda (x) (set-process-query-on-exit-flag x nil)
	      (quit-process x)
	      (kill-process x)
	      )
	    (process-list))
    (save-buffers-kill-emacs)
    ))
(global-set-key "\C-xc" 'exit-emacs-after-terminating-all-the-processes)


(provide 'init.misc-util)