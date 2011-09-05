;;; vj-complete-util.el --- Helper functions

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

(defsubst ident-re () "[A-Za-z_][A-Za-z_0-9]*")

(defsubst class-re () "[A-Za-z_][A-Za-z_0-9.]*")

(defsubst modifier-re () "public[ 	]\\|private[ 	]\\|protected[ 	]")

(defsubst string-msub (string number)
    "Return last text match NUMBER via string-match in STRING."
    (and (match-beginning number) 
        (substring string (match-beginning number) (match-end number))))



(defun vj-cu-call-re (allow-empty-match)
    "Create a regexp that will match brace/parenthesis pairs.

E.g. [1] (1,2,3) [index1]

ALLOW-EMPTY-MATCH if true then the regexp will match the empty string
"
    (concat 
        "\\(?:"
                                        ; nothing 
        (if allow-empty-match "\\|" "")
        "([^)]*)"                       ; ( .. stuff .. )
        "\\|"
        "\\[[^]]*\\]"                   ; [ .. stuff .. ]
        "\\)"
        ))


(defun vj-cu-generate-chained-re (count)
    "Generate a regexp that matches aa.bb. cc.dd. (for count=2).
Match up to the dot is captured.
"
    (let ((re (concat "\\(" (ident-re) "" (vj-cu-call-re t))))
        (dotimes (var (1- count))
            (setq re (concat 
                         re
                         "\\.[A-Za-z_][A-Za-z_0-9]*"
                         (vj-cu-call-re t))))
        (concat re "\\)\\.\\'")))


(defun vj-cu-detect-call-chain (count line)
    (let (chain)
        (if (string-match (vj-cu-generate-chained-re count) line)
            (progn
                (setq chain (string-msub line 1))
                (setq chain (replace-regexp-in-string (vj-cu-call-re nil) "" chain))
                chain
                )
            nil)))

(defun vj-analyze-at-point ()
    "Return variable prefix and line up to prefix"
    (let (prefix line result (init-point (point)))
        (save-excursion 
            (skip-chars-backward "A-Za-z0-9_" (point-at-bol))
            (if (save-excursion (backward-char 1) (looking-at "\\."))
                (progn
                    (setq line (buffer-substring-no-properties (point-at-bol) (point)))
                    (setq prefix (buffer-substring-no-properties (point) init-point)))
                ;; no dot and prefix
                (setq line (buffer-substring-no-properties (point-at-bol) init-point))
                (setq prefix nil))

            )
        (list line prefix)))


(defun vj-cu-make-simpl-completion-records (strings &optional second third)
    "Make completion-records list from a list names"
    (mapcar
        (lambda (symbol)
            (list symbol (or second "") (or third "")))
        strings))



(defun vj-cu-csharp-chain (chain call-chain-resolver)
    (let* ((chain-list (split-string chain "\\."))
              (first (car chain-list)) (rest (cdr chain-list))
              (classname (csharp-find-decl-full first t))
              return-type first-classname result)
        (when (equal (car rest) "__new") ;FIXME HACK
            (setq classname (csharp-find-full-classname 
                                (concat "\\<" first "\\'")
                                "(new) What type is %s? "))
            (setq rest  (cdr rest)))
        (if classname                   ;FIRST was a variable name 
            (vj-complete-add-to-context 
                (format "`%s' is a variable of type `%s'" first classname))
            ;; else: Assume FIRST is a class
            (setq classname (funcall call-chain-resolver 
                                (concat "\\<" first "\\'")
                              (format "Resolve chain: What type is `%s'? " first))))
        ;;(assert classname nil (format "variable or class is not known: %s" first))
      (when classname
        (setq first-classname classname)
        (setq result (list first-classname))
        (dolist (member rest) ;; MEMBER can be method, property, etc.

          ;; check that classname is full
          ;; (csharp-find-return-type "DurationConst" "ProcessTime")
          ;; double processTime = DurationConst.Instance().ProcessTime.

          ;; FIXME use csharp specific function!!!
          (setq return-type (csharp-find-return-type classname member))
          (if (not return-type)
            (error "no return type"))
          (if (equal (downcase return-type) "void")
            (error (format "class for return value is void: %s.%s" 
                     classname member)))
          (setq result (append result (list member return-type)))
          (setq classname return-type)

          (vj-complete-add-to-context 
            (format "vj-cu-csharp-chain: member=%s return-type=%s" 
              member return-type))


          ))
        result))

;; (defun vj-doit ()
;;     (let (chain (line-and-prefix (vj-analyze-at-point)))
;;         (setq line (car line-and-prefix))
;;         (setq prefix (second line-and-prefix))
;;         (setq chain (vj-cu-analyze-line line prefix))
;;         chain))


(defun vj-capture-count (regex)
  "Count \\\\( captures but ignore \\\\(?: ."
  (let ((i -1) (count 0)  p)
    (while i
      (setq i (string-match "\\\\(\\([^?][^:]\\|[^?]$\\|$\\)" regex (1+ i)))
      (if i (setq count (1+ count))))
    count))

(defun vj-find-above (regex)
  "Look for REGEX above point and return captures as string (for one capture) or list.
Does NOT restore point."
  (let ((c (vj-capture-count regex))
         (case-fold-search nil))
    (when (re-search-backward regex nil t)
      (cond
        ((equal c 1) (match-string-no-properties 1))
        ((equal c 2) (list (match-string-no-properties 1) (match-string-no-properties 2)))
        ((equal c 3) (list (match-string-no-properties 1)
                       (match-string-no-properties 2) (match-string-no-properties 3)))
        ((equal c 4) (list (match-string-no-properties 1)
                       (match-string-no-properties 2)
                       (match-string-no-properties 3)
                       (match-string-no-properties 4)))
        ((equal c 5) (list (match-string-no-properties 1)
                       (match-string-no-properties 2)
                       (match-string-no-properties 3)
                       (match-string-no-properties 4)
                       (match-string-no-properties 5)))
        (t (error "vj-find-above: bad regex %s" regex))))))


(defun vj-cu-find-fq-class-name-at-point ()
  "Find the fully qualified name of the class the point is in."
  (save-excursion
    (let* ((regex (concat "^[ 	]*\\(" (modifier-re) "\\)?[ 	]*class +\\(" (ident-re) "\\)\\(<[^>]*>\\)?"))
            (class-name (cadr (vj-find-above regex)))
            (generics (match-string-no-properties 3))
            (namespace (vj-find-above "^namespace[ 	]+\\([A-Z]\\sw*\\)")))
      (if namespace
        (list (concat namespace "." class-name) nil generics)
        (if class-name
          (list class-name nil generics))))))


(provide 'vj-complete-util)

