;;;; sequential command
(require 'sequential-command)

;; head of sentence -> head of line -> beginning of buffer -> departure
(define-sequential-command seq-home
  back-to-indentation beginning-of-line point-to-top
  beginning-of-buffer seq-return)
(global-set-key "\C-a" 'seq-home)

;; end of line -> end of buffer -> departure
(define-sequential-command seq-end
  end-of-line point-to-bottom end-of-buffer seq-return)
(global-set-key "\C-e" 'seq-end)

(provide 'init.sequential-command)