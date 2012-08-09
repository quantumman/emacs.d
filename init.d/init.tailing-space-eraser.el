;;;; never allow spaces after filled lines.
;; Delete trailing whitespace when siwtching other buffer or window
(defadvice switch-to-buffer (around switch-to-buffer--around activate)
  (delete-trailing-whitespace)
  ad-do-it
  (delete-trailing-whitespace))
(ad-enable-advice 'switch-to-buffer 'around 'switch-to-buffer--around)
(ad-activate 'switch-to-buffer)

(defadvice switch-to-buffer-other-frame (around switch-to-buffer-other-frame--around activate)
  (delete-trailing-whitespace)
  ad-do-it
  (delete-trailing-whitespace))
(ad-enable-advice 'switch-to-buffer-other-frame 'around 'switch-to-buffer-other-frame--around)
(ad-activate 'switch-to-buffer-other-frame)

(defadvice switch-to-buffer-other-window (around switch-to-buffer-other-window--around activate)
  (delete-trailing-whitespace)
  ad-do-it
  (delete-trailing-whitespace))
(ad-enable-advice 'switch-to-buffer-other-window 'around 'switch-to-buffer-other-window--around)
(ad-activate 'switch-to-buffer-other-window)

(defadvice other-window (around other-window--around activate)
  (delete-trailing-whitespace)
  ad-do-it
  (delete-trailing-whitespace))
(ad-enable-advice 'other-window 'around 'other-window--around)
(ad-activate 'other-window)

;; Delete trailing-whitespace with saving
(defun save-buffer--delete-trailing-whitespace ()
  "This deletes trailing whitespace and then save current buffer"
  (interactive)
  (delete-trailing-whitespace)
  (when (not (string-equal (buffer-name) "*scratch*"))
    (save-buffer)))

(global-set-key (kbd "C-x C-s") 'save-buffer--delete-trailing-whitespace)

(provide 'init.tailing-space-eraser)
