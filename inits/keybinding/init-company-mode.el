(require 'company)
(require 'company-ghc)

(global-company-mode)
(add-to-list 'company-backends 'company-ghc)
(add-to-list 'company-backends 'company-omnisharp)

(defun fallback-key-sequence ()
  (setq unread-command-events
        (append (this-single-command-raw-keys)
                unread-command-events))
  (read-key-sequence-vector ""))

(defun fallback-key-binding ()
  (let* ((company-mode nil)
         (keys (fallback-key-sequence))
         (command (and keys (key-binding keys))))
    (when (commandp command)
      (call-interactively command))))

(define-key company-mode-map (kbd "TAB")
  '(lambda ()
     (interactive)
     (if (word-at-point)
         (company-complete)
       (fallback-key-binding))))

(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "SPC") 'company-filter-candidates)
(define-key company-filter-map (kbd "<backspace>") 'company-search-delete-char)


(require 'el-init)
(el-init-provide)
