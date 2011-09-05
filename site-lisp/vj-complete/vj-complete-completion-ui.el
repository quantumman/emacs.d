;;; vj-complete-completion-ui.el --- vj-complete to completion-ui adapter

;; Copyright (C) 2008 Vagn Johansen

;; Author: Vagn Johansen <gonz808@hotmail.com>
;; Keywords: completion, ui, user interface
;; URL: http://www.ozymandias.dk/emacs/emacs.html


;; This file is NOT part of Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
;; MA 02110-1301, USA.

;;; Commentary:
;;
;; This package makes it possible to use the completion interface in
;; completion-ui.el to access completions generated via vj-complete.
;;
;; Supported modes: emacs-lisp-mode, csharp-mode
;;
;; Installation:
;; 
;;   (require 'vj-complete-completion-ui)
;;  
;; Enable the completion-ui interface in a buffer with
;;
;;   M-x auto-completion-mode
;;
;; predictive-mode is used inside comments if predictive mode has been
;; activated.  This is checked by calling fboundp on predictive-complete
;;

;;; Code:

(require 'vj-complete-elisp)
(require 'completion-ui)

(defcustom vj-complete-completion-ui-min-prefix 3
  "Minimum prefix length before activating completion-ui.el."
  :type 'integer
  :group 'vj-complete)

(defun vj-complete-completion-ui-get-prefix ()
  "Get prefix for completion (obsolete)."
  (if (looking-back (cond
                      ((equal major-mode 'emacs-lisp-mode) "\\_<[a-z0-9-]+")
                      (t "\\_<[a-zA-Z0-9_]+")))
    (match-string-no-properties 0)))

(defun vj-complete-completion-ui-setup ()
  "Configure completion-ui.el."
  (setq completion-function 'vj-complete-completion-ui-adapter)
  (setq completion-prefix-function 'vj-complete-completion-ui-get-prefix)
  )

(defun vj-complete-completion-ui-adapter (prefix max)
  "Return predictive-mode or vj-complete completions.

If inside comment return predictive-mode completions otherwise
return vj-complete based completions

See `completion-function' for description of PREFIX and MAX."
  (or
    ;; try predictive mode if inside comment
    (and
      (equal (get-text-property (1- (point)) 'face) font-lock-comment-face)
      (fboundp 'predictive-complete)
      (predictive-complete prefix max))
    ;; else try predictive vj-complete
    (vj-complete-completion-ui-adapter-raw prefix max)))

(defun vj-complete-completion-ui-adapter-raw (prefix max)
  "Get vj-complete results and convert to completion-ui.el format.

See variable `completion-function' for a description of PREFIX and MAX."
  (if (and
        (>= (length prefix) vj-complete-completion-ui-min-prefix)
        (not (looking-at "[a-zA-z0-9]")))
    (let* ((prefix-length (length prefix))
            (completions
              (mapcar
                (lambda (s) (substring (car s) prefix-length))
                ;; Call does NOT use prefix but examines context at point
                (funcall vj-complete-get-completions-function))))
;;      (if (> (length completions) 0) (add-to-list 'completions ""))
      ;; Return only MAX completion candidates
      (if (> (length completions) (or max 9999))
        (butlast completions (-  (length completions) max))
        completions))))


(add-hook 'emacs-lisp-mode-hook 'vj-complete-completion-ui-setup)
(add-hook 'csharp-mode-hook 'vj-complete-completion-ui-setup)

(provide 'vj-complete-completion-ui)

(provide 'vj-complete-completion-ui)

;;; vj-complete-completion-ui.el ends here
