(require 'auto-complete)

(setq ac-use-menu-map t)
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)


(require 'mykie)
(setq mykie:use-major-mode-key-override t)
(mykie:initialize)

(mykie:set-keys nil
  "C-d"
  :default     (delete-char 1)
  :region      delete-chars-region
  [backspace]
  :default     (delete-backward-char 1)
  :region      delete-chars-region
  "C-w"
  :default     (ispell-word)
  :region      kill-region
  :region&:emacs-lisp-mode paredit-kill-region
  "C-k"
  :default     (kill-line)
  :region      kill-region
  [C-tab]
  :default     (indent-for-tab-command)
  :region      indent-region
  )

(defun delete-chars-region (&optional start end)
  (interactive)
  (when (region-active-p)
    (save-excursion
      (save-restriction
        (if (and start end)
            (narrow-to-region start end)
          (narrow-to-region (region-beginning) (region-end))
          )
        (goto-char (point-min))
        (delete-char (- (point-max) (point-min)))
        ))))

(require 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(defun add-keys-to-ace-jump-mode (prefix c &optional mode)
  (define-key global-map
    (read-kbd-macro (concat prefix (string c)))
    `(lambda ()
       (interactive)
       (funcall (if (eq ',mode 'word)
                    #'ace-jump-word-mode
                  #'ace-jump-char-mode) ,c))))
(setq mac-option-modifier 'hyper)
(loop for c from ?0 to ?9 do (add-keys-to-ace-jump-mode "H-" c))
(loop for c from ?a to ?z do (add-keys-to-ace-jump-mode "H-" c))
(loop for c from ?0 to ?9 do (add-keys-to-ace-jump-mode "C-H-" c 'word))
(loop for c from ?a to ?z do (add-keys-to-ace-jump-mode "C-H-" c 'word))


(global-set-key (kbd "C-x C-b") 'ibuffer)
(add-hook 'ibuffer-hook
          (lambda ()
            (ibuffer-vc-set-filter-groups-by-vc-root)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              (ibuffer-do-sort-by-alphabetic))))
(setq ibuffer-formats
      '((mark modified read-only vc-status-mini " "
              (name 18 18 :left :elide)
              " "
              (size 9 -1 :right)
              " "
              (mode 16 16 :left :elide)
              " "
              (vc-status 16 16 :left)
              " "
              filename-and-process)))

(require 'mark-more-like-this)
(global-set-key (kbd "C-<") 'mark-previous-like-this)
(global-set-key (kbd "C->") 'mark-next-like-this)

(require 'el-init)
(el-init-provide)
