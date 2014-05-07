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


(define-region-key global-map "\C-w" 'kill-region 'ispell-word)
(define-region-key global-map [C-tab] 'indent-region 'indent-for-tab-command)

(global-set-key "\C-f" 'forward-word)
(global-set-key "\C-b" 'backward-word)


(require 'el-init)
(el-init:provide)
