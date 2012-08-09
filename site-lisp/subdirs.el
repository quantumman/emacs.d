(defun directory-dirs (dir)
    "Find all directories in DIR."
    (unless (file-directory-p dir)
      (error "Not a directory `%s'" dir))
    (let ((dir (directory-file-name dir))
          (dirs '())
          (files (directory-files dir nil nil t)))
        (dolist (file files)
          (unless (member file '("." ".."))
            (let ((file (concat dir "/" file)))
              (when (file-directory-p file)
                (setq dirs (append (cons file
                                         (directory-dirs file))
                                   dirs))))))
        dirs))

(dolist (dir (directory-dirs default-directory))
  (add-to-list 'load-path dir))
