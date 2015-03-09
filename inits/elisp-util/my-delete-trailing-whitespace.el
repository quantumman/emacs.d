(defun my-delete-trailing-whitespace ()
  "Delete trailing sapces and tabs in current buffer.
A Line on which the cursor locates and
lines which contain only single newline character
are not targeted by this function."
  (interactive)
  (let ((cursor-line (line-number-at-pos)))
    (save-excursion
      (save-restriction
        (goto-char (point-max))
        (while (re-search-backward "[ \t]+\n" nil t)
          (unless (eq cursor-line (line-number-at-pos))
            (delete-horizontal-space))
          )))))

(require 'el-init)
(el-init-provide)
