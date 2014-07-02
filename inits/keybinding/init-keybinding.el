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
  "C-w"
  :default     (ispell-word)
  :region      kill-region
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

(defun point-to-top ()
  "Put point to top line of window."
  (interactive)
  (move-to-window-line 0))
(global-set-key "\C-t" 'point-to-top) ;; C-t = pointer moves to top of window


(defun point-to-bottom ()
  "Put point to bottom line of window."
  (interactive)
  (move-to-window-line -1))
(global-set-key "\C-b" 'point-to-bottom) ;; C-b = pointer moves to bottom of window


(global-set-key "\C-f" 'forward-word)
(global-set-key "\C-b" 'backward-word)


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
(loop for c from ?0 to ?9 do (add-keys-to-ace-jump-mode "H-M-" c 'word))
(loop for c from ?a to ?z do (add-keys-to-ace-jump-mode "H-M-" c 'word))


(require 'el-init)
(el-init:provide)
