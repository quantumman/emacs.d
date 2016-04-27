(require 'company)
(require 'company-ghc)
(require 'company-tern)

(global-company-mode)
(add-to-list 'company-backends 'company-ghc)
(add-to-list 'company-backends 'company-omnisharp)
(add-to-list 'company-backends 'company-yasnippet)
(add-to-list 'company-backends 'company-tern)

(setq company-tern-property-marker ""
      company-tern-meta-as-single-line t)

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

(set-face-attribute 'company-tooltip nil
                    :foreground "black" :background "lightgrey")
(set-face-attribute 'company-tooltip-common nil
                    :foreground "black" :background "lightgrey")
(set-face-attribute 'company-tooltip-common-selection nil
                    :foreground "white" :background "steelblue")
(set-face-attribute 'company-tooltip-selection nil
                    :foreground "black" :background "steelblue")
(set-face-attribute 'company-preview-common nil
                    :background nil :foreground "lightgrey" :underline t)
(set-face-attribute 'company-scrollbar-fg nil
                    :background "orange")
(set-face-attribute 'company-scrollbar-bg nil
                    :background "gray40")

(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-search-map (kbd "C-n") 'company-select-next)
(define-key company-search-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "C-s") 'company-filter-candidates)
(define-key company-active-map (kbd "TAB") 'company-complete-selection)

(company-quickhelp-mode +1)

(setq company-tooltip-align-annotations t)
(require 'el-init)
(el-init-provide)
