;;;; elscreen
(require 'elscreen)
(elscreen-start)
(global-set-key (kbd "C-z C-o")
		'(lambda () (interactive)
		   (anything 'anything-c-source-elscreen)))
(defmacro elscreen-create-automatically (ad-do-it)
  `(if (not (elscreen-one-screen-p))
       ,ad-do-it
     (elscreen-create)
     (elscreen-notify-screen-modification 'force-immediately)
     (elscreen-message "New screen is automatically created")))

(defadvice elscreen-next
  (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))

(defadvice elscreen-previous
  (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))

(defadvice elscreen-toggle
  (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))

(defun elscreen-frame-title-update ()
  (when (elscreen-screen-modified-p 'elscreen-frame-title-update)
    (let* ((screen-list (sort (elscreen-get-screen-list) '<))
	   (screen-to-name-alist (elscreen-get-screen-to-name-alist))
	   (title (mapconcat
		   (lambda (screen)
		     (format "%d%s %s"
			     screen (elscreen-status-label screen)
			     (get-alist screen screen-to-name-alist)))
		   screen-list " ")))
      (if (fboundp 'set-frame-name)
	  (set-frame-name title)
	(setq frame-title-format title)))))

(eval-after-load "elscreen"
  '(add-hook 'elscreen-screen-update-hook 'elscreen-frame-title-update))


(provide 'init.elscreen)
