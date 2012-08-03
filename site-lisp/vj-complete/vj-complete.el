;;; vj-complete.el --- Generic in-buffer completion system

;; Copyright (C) 2007  Vagn Johansen

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; Usage:
;;
;; Bind vj-complete to a key eg. C-t.
;; Repeated C-t calls will cycle through the completions.
;; Direct selection can be done with a numeric argument eg. C-7 C-t.
;;
;; See http://ozymandias.dk/emacs/emacs.html for screenshost and
;; additional documentation.
;;
;;
;; How to support new modes:
;;
;; (add-hook 'foo-mode-hook 'vj-complete-foo-setup)
;;
;; (defun vj-complete-foo-setup ()
;;     (setq vj-complete-get-completions-function
;;         'vj-complete-get-foo-completions)
;;     (local-set-key (kbd "C-t") 'vj-complete))
;;
;; ;; Return a list of completion records (COMPLETION DOCLINE CODE)
;; ;; You can do anything here, But you MUST set vj-complete-current-begin-point
;; (defun vj-complete-get-foo-completions ()
;;   (setq vj-complete-current-begin-point
;;     (save-excursion
;;       (skip-chars-backward "A-Za-z_0-9-" (point-at-bol))
;;       (point)))
;;   ;; -- your code here --
;;   (list '("name" "doc" "F") '("name2" "doc2" "V")))
;;
;; Optional "hook": vj-complete-insert-header-function: called after creating
;; the completion buffer.
;;
;; Interface to dropdown-list:
;;
;;   Bind the functio vj-complete-dropdown to a key
;;
;; When there a more than 9 "hits" press 0 to call vj-complete


;;; Code:


(defgroup vj-complete nil
  "Generic in-buffer completion system."
  :link  '(url-link "http://ozymandias.dk/emacs/emacs.html")
  :group 'convenience)

(defface vj-complete-index-face
  '((t (:foreground "darkgreen" :background "dark sea green")))
  "Face for documentation lines."
  :group 'vj-complete)

(defface vj-complete-doc-face
  '((t (:foreground "#304040" :family "times new roman")))
  "Face for documentation lines."
  :group 'vj-complete)


(defvar vj-complete-debug-level 0)

(defvar vj-complete-current-list nil)
(make-variable-buffer-local 'vj-complete-current-list)

(defvar vj-complete-current-index nil)
(make-variable-buffer-local 'vj-complete-current-index)

(defvar vj-complete-current-begin-point nil)
(make-variable-buffer-local 'vj-complete-current-begin-point)

(defvar vj-complete-current-end-point nil)
(make-variable-buffer-local 'vj-complete-current-end-point)

(defvar vj-complete-get-completions-function nil)
(make-variable-buffer-local 'vj-complete-get-completions-function)

(defvar vj-complete-insert-header-function nil)
(make-variable-buffer-local 'vj-complete-insert-header-function)



(defvar vj-complete-context nil)

(defun vj-complete-add-to-context (value)
  "For debugging."
  (setq vj-complete-context
    (append vj-complete-context (list value))))


(defun vj-complete (&optional  index)
  "Begin or continue context sensitive completion.

If previous command was vj-complete then the the next completion
will be inserted. Otherwise collect a new set of completions.

With INDEX select specific completion.
With zero INDEX restore original window configuration."
    (interactive "P")
    (if (and index (zerop index))
      (progn ;; restore window configuration
        (if (get-buffer-window "*vj-complete*")
          (delete-window (get-buffer-window "*vj-complete*")))
        (jump-to-register ?C))

        (if (or
              (eq last-command 'vj-complete)
              (eq last-command 'vj-complete-dropdown))
            (vj-complete-next index)
            (vj-complete-list))))

(defun vj-complete-indent-or-complete ()
  "Complete if point is at end of a word, otherwise indent line."
  (interactive)
  (if (< (point) (save-excursion (back-to-indentation) (point)))
      (indent-according-to-mode)
      (vj-complete)))

(defun vj-complete-next (&optional index)
    (when (listp vj-complete-current-list)
        (setq vj-complete-current-index
            (if (equal vj-complete-current-index
                    (length vj-complete-current-list))
                1                       ;wrap
                (1+ vj-complete-current-index))) ;advance index
        ;; Maybe override with external index
        (when index
            (setq vj-complete-current-index
                (if (<= index (length vj-complete-current-list))
                    index
                    (error (format "bad index %d <= %d" index (length vj-complete-current-list))))))

        (when (and (listp vj-complete-current-list)
                  (<= vj-complete-current-index (length vj-complete-current-list)))
            (message "%d - %s" vj-complete-current-index
                (nth 1 (nth  (1- vj-complete-current-index)
                             vj-complete-current-list)))
            (goto-char vj-complete-current-begin-point)
            (vj-complete-insert-completion))
        ;; When selecting specific completion, we remove the completion buffer
        (when index
          ;; FIXME use restore window configuration
          (delete-window (get-buffer-window "*vj-complete*")))
      ))


(defun vj-complete-list ()
    (setq vj-complete-context nil) ;; not buffer local
    (setq vj-complete-current-index 0)
    (setq vj-complete-current-end-point (point))
    (setq vj-complete-current-begin-point nil)

    ;; Don't store window-configuration in ?C if one of the windows is "*vj-complete*"
    (setq vj-complete-store-wc t)

  (dolist (window (window-list))
    (if (equal (buffer-name (window-buffer window)) "*vj-complete*")
      (setq vj-complete-store-wc nil)))

    (if vj-complete-store-wc
      (window-configuration-to-register ?C))


    ;;setq line-prefix (buffer-substring-no-properties (point-at-bol) (point))

    (let ((source-window (get-buffer-window (current-buffer)))
          word all-completions i completions type (prefix "")
             (insert-header-function vj-complete-insert-header-function)
             (window (get-buffer-window "*vj-complete*")))

      (if window
        (delete-window window))

        (setq all-completions (funcall vj-complete-get-completions-function))
        (if (and all-completions
              (not vj-complete-current-begin-point))
          (error "vj-complete-get-completions-function did not set vj-complete-current-begin-point")
          ;; else
          (setq prefix (buffer-substring-no-properties
                         vj-complete-current-begin-point (point))))

        ;; Make empty buffer
        (switch-to-buffer-other-window (get-buffer-create "*vj-complete*") t)
        (delete-region (point-min) (point-max))


        (dolist (completion-record all-completions)
            (when (string-match
                   (concat "^" (replace-regexp-in-string
                                "_" ".*" (regexp-quote prefix)))
                   (nth 0 completion-record))
                (add-to-list 'completions completion-record t)))

        ;; Insert completion help
        (setq vj-complete-current-list nil)
;;        (insert (format "Completions for prefix \"%s\"\n" prefix))
        ;; insert header

        (if (> vj-complete-debug-level 0)
            (dolist (entry vj-complete-context)
                (insert entry)
                (insert "\n")))

        (when insert-header-function
            (funcall insert-header-function))

        (if (equal (length completions) 1)
            (vj-complete-insert-completion-record (car completions) 1)
            ;; else
            (setq i 1)
            (dolist (completion-record completions)
                (vj-complete-insert-completion-record completion-record i)
                (setq i (1+ i))))

        (local-set-key [mouse-2]
            (function
                (lambda (event)
                    (interactive "e")
                  ;; FIXME switch to buffer  (with-current-buffer (get-buffer "*vj-complete*")
                    (goto-char (posn-point (event-end event)))
                    (message "AT %s type=<%s>" (current-word)
                        (or (get-text-property  (point) 'vj-complete-type) "")
                        ))))



        ;; Window handling Length
        (goto-char (point-min))
        (shrink-window-if-larger-than-buffer)

       ;; Go back to original buffer
        (select-window source-window)

        ;; Insert first completion
        (setq vj-complete-current-list completions)
        (when (and (not buffer-read-only) vj-complete-current-list)
            (if (< (length completions) 3)
                (progn
                    (setq vj-complete-current-index 0)
                    (vj-complete-insert-completion)
                    )
                ;; else
                (progn
                    (delete-region
                        vj-complete-current-begin-point
                        vj-complete-current-end-point)
                    (insert (vj-complete-get-common-prefix completions))
                    (setq vj-complete-current-end-point (point)))))))


(defun vj-complete-get-common-prefix (completions)
  (or
    (try-completion ""
      (mapcar (lambda (c) (cons (car c) nil)) completions))
    ""))

(defun vj-complete-insert-completion ()
    (assert 'vj-complete-current-begin-point t "(wrong buffer?)")
    (assert 'vj-complete-current-end-point)
    (delete-region
        vj-complete-current-begin-point
        vj-complete-current-end-point)
    (insert (car (nth (1- vj-complete-current-index) vj-complete-current-list)))
    (setq vj-complete-current-end-point (point)))



(defun vj-complete-insert-completion-record (completion-record i)
    (let
        ((word (nth 0 completion-record))
          (doc (nth 1 completion-record))
          (type (nth 2 completion-record))
            (classname (nth 3 completion-record))
            )
        (insert (propertize (format "%-02s" i) 'face 'vj-complete-index-face))


        (cond
          ((equal type "F")
            (insert (propertize "f" 'face 'font-lock-function-name-face
                      'vj-complete-type type)))
          ((equal type "V")
            (insert (propertize "v" 'face 'font-lock-variable-name-face
                      'vj-complete-type type)))
          ((equal type "I")
            (insert (propertize "i" 'face 'font-lock-comment-face
                      'vj-complete-type type)))
          ((equal type "T")
            (insert (propertize "t" 'face 'font-lock-type-face
                      'vj-complete-type type)))
          ((equal type "-") nil)
          (t (insert (propertize "?" 'face 'font-lock-warning-face
                       'vj-complete-type type))))

        (insert " ")
        (when classname
            (insert (propertize classname 'face 'font-lock-type-face 'vj-complete-type type) "."))
        (insert (propertize word 'face 'bold 'vj-complete-type type))

        (insert (format " %s"
                        (if (get-text-property 0 'face (or doc ""))
                            doc
                          (propertize
                           (or doc "(nth 1 completion-record) is nil\n!\n")
                           'face 'vj-complete-doc-face))) )

        (insert "\n")
        ))

(eval-after-load "dropdown-list"
  '(defun vj-complete-dropdown ()
     (interactive)
     (let* ((completions (mapcar
                           (lambda (x) (car x))
                           (funcall vj-complete-get-completions-function)))
             (prefix (buffer-substring-no-properties
                       vj-complete-current-begin-point (point)))
             (selected
               (dropdown-list
                 (if (> (length completions) 9)
                   (append
                     (butlast completions (-  (length completions) 9))
                     `(,(format "... (%d) " (length completions))))
                   completions))))
       (if (not selected)
         (call-interactively 'vj-complete)
         ;; else
         (insert (substring (nth selected completions ) (length prefix)))))))

(provide 'vj-complete)

;;; vj-complete.el ends here
