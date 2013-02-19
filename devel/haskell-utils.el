(defun ghc-sort-functions-in-module ()
  (save-excursion
    (goto-char (point-max))
    (while (re-search-backward "\\(^import.+\\)\\((.+)\\)" nil t)
      (let ((modules (match-string 2)))
        (replace-match
         (concat (match-string 1)
                 (with-temp-buffer
                   (save-match-data
                     (insert modules)
                     (goto-char (point-min))
                     (replace-regexp ",\\([^ \t]+\\)" ", \\1")
                     (sort-regexp-fields nil "\\w+" "\\&" (point-min) (point-max))
                     (buffer-string)))
                 )))
      (goto-char (match-beginning 0))
      )))
