(defun anything-c-sources-git-project-for (root-dir)
  (loop for elt in
        '(("Modified files (%s)" . "--modified")
          ("Untracked files (%s)" . "--others --exclude-standard")
          ("All files in this project (%s)" . ""))
        collect
        `((name . ,(format (car elt) root-dir))
          (init . (lambda ()
                    (unless (and ,(string= (cdr elt) "") ;update candidate buffer every time except for that of all project files
                                 (anything-candidate-buffer))
                      (with-current-buffer
                          (anything-candidate-buffer 'global)
                        (insert
                         (shell-command-to-string
                          ,(format "git ls-files %s %s"
                                   root-dir (cdr elt))))))))
          (candidates-in-buffer)
          (type . file))))

(defun anything-git-project ()
  (interactive)
  (let* ((git-rootdir-check-cmd
          (concat "cd ./$(git rev-parse --show-cdup); pwd"))
         (git-root-dir-with-newline (shell-command-to-string git-rootdir-check-cmd))
         (git-root-dir (substring git-root-dir-with-newline 0
                                  (- (length git-root-dir-with-newline) 1)))
         (sources (anything-c-sources-git-project-for git-root-dir)))
    (anything-other-buffer sources
     (format "*Anything git project in %s*" git-root-dir))))

(define-key global-map (kbd "C-;") 'anything-git-project)
