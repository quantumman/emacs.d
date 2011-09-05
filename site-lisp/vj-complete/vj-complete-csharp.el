;;; vj-complete-csharp.el --- Context sensitive C# completion

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


(require 'vj-complete)
(require 'vj-complete-util)

;;; Code:
(add-hook 'csharp-mode-hook 'vj-complete-csharp-setup t)

(defvar vj-complete-csharp-filename "c:/vjo/bin/assembly_tags")

(defvar vj-complete-csharp--current-classname nil)
(defvar vj-complete-csharp--current-header nil)
(defvar vj-complete-csharp--current-log-alist nil)
(defvar vj-csharp-namespace nil)
(defvar vj-csharp-using nil)

(defvar vj-complete-csharp-types (make-hash-table :test 'equal)) ;; includes generic types
(defvar vj-complete-csharp-generic-types (make-hash-table :test 'equal))
(defvar vj-complete-csharp-type-list nil)
(defvar vj-complete-csharp-namespace-list nil)
(defvar vj-complete-csharp-namespaces (make-hash-table :test 'equal))
(defvar vj-complete-csharp-top-namespaces (make-hash-table :test 'equal))


 
(defun vj-complete-csharp-setup ()
    "Setup C# completion based on `vj-complete'."
    (interactive)
    (setq vj-complete-get-completions-function
        'vj-complete-get-csharp-completions)
    (setq vj-complete-insert-header-function
        'vj-complete-insert-csharp-header)
    (local-set-key (kbd "C-t") 'vj-complete))


(defun vj-complete-csharp-db-filename ()
    "Return C# function (etc.) database filename."
    (concat vj-complete-csharp-filename ".txt"))

(defun vj-complete-csharp-cla-db-filename ()
    "Return C# class relationship database filename."
    (concat vj-complete-csharp-filename ".cla.txt"))

(defun vj-complete-insert-csharp-header ()
    (when vj-complete-csharp--current-classname
        (insert
            (format "C# %s\n"
                (or
                  (mapconcat
                    (lambda (type)
                      (propertize type 'face 'font-lock-type-face))
                    (csharp-find-class-hierarchy vj-complete-csharp--current-classname)
                    ;;  Nices arrow:  "\x49020\x490fa"
                    "->")
                        
                    "?"))))
    (when vj-complete-csharp--current-header
        (dolist (header-entry vj-complete-csharp--current-header) 
            (insert header-entry))))

(defun vj-complete-get-csharp-completions-begin ()
    (setq vj-complete-csharp--current-classname nil)
 ;;           (vj-csharp-current-classname)
    (setq vj-complete-csharp--current-header nil)
    (setq vj-csharp-namespace (csharp-current-namespace))
    (setq vj-csharp-using (csharp-find-using-declarations))


    (setq vj-complete-current-begin-point
        (save-excursion
            (skip-chars-backward "A-Za-z_0-9" (point-at-bol))
            (point))))


(defun csharp-namespace-p (str)
  ""
  (gethash str vj-complete-csharp-namespaces))

(defun csharp-namespace-prefix-p (str)
  ""
  (let (is-ns)
    (dolist (u (csharp-find-using-declarations))
      (if (csharp-namespace-p (vj-ns u str))
        (setq is-ns t)))
    (or is-ns (csharp-namespace-p str))))


(defun csharp-namespace-prefilter (partial-namespace)
  ""
  (let ((case-fold-search nil))
    (vj-filter
      vj-complete-csharp-namespace-list
      (lambda (s) (string-match partial-namespace s)))))
;;      (lambda (s) (string-match (concat partial-namespace "\\.[^.]+\\'") s)))))

(defun csharp-find-namespace-candidates (fq-ns)
  (vj-filter vj-complete-csharp-namespace-list
    (lambda (cand)
      (string-match (concat fq-ns "\\.[^.]+\\'") cand))))

(defun csharp-find-namespace-completions (partial-namespace)
  ""
  (let (fq-ns partial result types (case-fold-search nil))
    (if (csharp-namespace-p partial-namespace)
      (setq fq-ns partial-namespace)
      ;; else
      (dolist (ns (append (list (csharp-current-namespace)) (csharp-find-using-declarations)))
        (if (csharp-namespace-p (vj-ns ns partial-namespace))
          (setq fq-ns (vj-ns ns partial-namespace)))))

    (dolist (ns (csharp-find-namespace-candidates fq-ns))
      (setq partial (substring ns (1+ (length fq-ns))))
      (add-to-list 'result (list partial "namespace" "T")))
    
    (dolist (cpl (csharp-type-search-with-using (concat fq-ns "\\.[^.]+\\'") t))
      (setq partial (substring (car cpl) (1+ (length fq-ns))))
      (add-to-list 'result (list partial (second cpl)  "T")))

    result))


(defun csharp-find-namespace-completions-old2 (partial-namespace)
  ""
  ;; FIXME add new func  (csharp-namespace-prefix-p "System") => t
  ;; (MUST use using declarations
  ;; eg. (csharp-namespace-prefix-p "File") => t if using System.IO
  
  (let ((using-regex
          (regexp-opt
            (append
              (list (or (csharp-current-namespace) ""))
              (csharp-find-using-declarations)
              (list ""))))
         (types (csharp-type-search-with-using (concat "^" partial-namespace "\\.[^.]+\\'") t))
         partial result)
    (dolist (ns (csharp-namespace-prefilter partial-namespace))
      ;;      (when (string-match (concat "\\(^\\|\\.\\)" using-regex) ns)
      (when (string-match using-regex ns)
        (setq partial (replace-regexp-in-string using-regex "" ns))
        (if (and
              (> (length partial) 0)
              (not (string-match "\\." partial)))
          (add-to-list 'result 
            (list
              (substring partial 1)
              (or
                (car (gethash ns vj-complete-csharp-types))
                (car (gethash ns vj-complete-csharp-generic-types))
                "namespace")
              "T")))))
    
      result))

;; (defun csharp-find-namespace-completions-old2 (class-prefix)
;;   ""
;;   (let (result partial-classname
;;          (current-ns (csharp-current-namespace)))
;;     (dolist (fq-classname (csharp-namespace-prefilter class-prefix))
;;       (dolist (ns (append (list current-ns) (csharp-find-using-declarations) '(nil)))
;;         ;; FIXME do proper begins-with comparison using substring
;;         (when (string-match
;;                 (concat "^" (if ns
;;                               (concat (regexp-quote ns) "\\." class-prefix)
;;                               class-prefix))
;;                 fq-classname)
;;           (if ns
;;             (setq partial-classname (substring fq-classname (1+ (length ns))))
;;             (setq partial-classname fq-classname))
;;           (add-to-list 'result 
;;             (if t
;;               (list
;;                 partial-classname
;;                 (or
;;                   (car (gethash fq-classname vj-complete-csharp-types))
;;                   (car (gethash fq-classname vj-complete-csharp-generic-types))
;;                   "todo")
;;                 "T")
;;               partial-classname)))))
;;     result))



(defun vj-analyze-line (line prefix)
  (let (result chain classname partial-classname generic-type result partial)
    ;; Rewrite line (__new is treated specially)
    ;; "(new Gamma)." => "__gamma.__new."
    (setq line (replace-regexp-in-string (concat "(new *\\(" (ident-re) "\\)([^)]*))\\.") 
                 "\\1.__new." line))

    ;; FIXME new CC(-!-   display ctors "new XX(" -> "XX.ctor
    ;; - On single match only?

    ;; FIXME enum completion

    ;; (var as CC).-!-  => CC.__new.
    (setq line (replace-regexp-in-string 
                 (concat "(" (ident-re) " [ ]*as [ ]*\\(" 
                   (class-re) "\\))\\.") 
                 "\\1.__new." line))

    (setq completions
      (cond
        ;; FIXME looking-at "\\<ident.ident.\\'" "Tools.XMLPayloadDataType."
        ;; and match is namespace (use (member m (csharp-find-using-completions)))

        ;; FIXME "\s+ (is|as) \s+ CLASS"
              
        ((string-match "^[ 	]*\\[\\([A-Za-z_0-9.]*\\)" line) ;; Attribute
          (message "ATTRIBUTE %s" (string-msub line 1))

          (setq vj-complete-current-begin-point
            (save-excursion
              (skip-chars-backward "A-Za-z_0-9." (point-at-bol))
              (point)))

          (csharp-find-attribute-completions (string-msub line 1)))
              
        ;; "using" completion
        ((string-match "^using \\([A-Za-z0-9._]*\\)" line) 
          (setq vj-complete-current-begin-point
            (save-excursion
              (skip-chars-backward ".A-Za-z_0-9" (point-at-bol))
              (point)))

          (vj-cu-make-simpl-completion-records (csharp-find-using-completions)))

        ;; Namespace completion
        ((and (string-match "^[ 	]*\\([A-Z][A-Za-z0-9._]*\\)\\.\\'" line)
           (csharp-namespace-prefix-p (setq partial (string-msub line 1)))) ;; <- broken for partials

          (setq vj-complete-current-begin-point
            (save-excursion
              (skip-chars-backward "A-Za-z_0-9" (point-at-bol))
              (point)))

          (csharp-find-namespace-completions partial))

        ;; "cast" completion
        ((string-match "((\\([A-Za-z0-9._]+\\)\\(<[^>]*>\\)?)[A-Za-z0-9_]+)\\.\\'" line) 
          (message "CAST %s" (string-msub line 1))

          (setq partial-classname (string-msub line 1))
          (setq generic-type (string-msub line 2))
          (setq classname
            (vj-csharp-resolve-partial-class partial-classname
              (if generic-type
                (concat partial-classname "`"
                  (number-to-string (length (split-string generic-type ",")))))))

          (unless classname
            (error "Can't resolve type %s" partial-classname))
          (setq vj-complete-current-begin-point
            (save-excursion
              (skip-chars-backward "A-Za-z_0-9" (point-at-bol))
              (point)))

          (csharp-find-completions classname prefix))

        ;; "C c = -!-"
        ((string-match
           (concat "^[ 	]*\\(" (ident-re) "\\) *" (ident-re) " *=\\([ ]*\\)\\'") 
           line)
          (setq partial-classname (string-msub line 1))
          (setq classname (vj-csharp-resolve-partial-class partial-classname nil))
          (if partial-classname (skip-chars-backward " " (point-at-bol)))
          (mapcar
            (lambda (item)
              (list (concat " new " partial-classname "")
                (nth 1 item)
                (nth 2 item)))
            (csharp-find-completions classname ".ctor")))

        ((setq result (vj-cu-detect-call-chain 5 line))
          (setq chain
            (vj-cu-csharp-chain result 'csharp-find-full-classname))
          (message "CHAIN4 result=%s => chain=%s" result chain)
          (setq  classname (car (last chain)))
          (csharp-find-completions classname prefix))
        ((setq result (vj-cu-detect-call-chain 4 line))
          (setq chain
            (vj-cu-csharp-chain result 'csharp-find-full-classname))
          (message "CHAIN4 result=%s => chain=%s" result chain)
          (setq  classname (car (last chain)))
          (csharp-find-completions classname prefix))
        ((setq result (vj-cu-detect-call-chain 3 line))
          (setq chain
            (vj-cu-csharp-chain result 'csharp-find-full-classname))
          (message "CHAIN3 result=%s => chain=%s" result chain)
          (setq classname (car (last chain)))
          (csharp-find-completions classname prefix))
        ((setq result (vj-cu-detect-call-chain 2 line))
          (setq chain
            (vj-cu-csharp-chain result 'csharp-find-full-classname))
          (message "CHAIN2 result=%s => chain=%s" result chain)
          (setq classname (car (last chain)))
          (csharp-find-completions classname prefix))
        ((setq result (vj-cu-detect-call-chain 1 line))
          (setq chain
            (vj-cu-csharp-chain result 'csharp-find-full-classname))
          (message "CHAIN1 result=%s => chain=%s" result chain)
          (setq classname (car (last chain)))
          (csharp-find-completions classname prefix))

        ;; class completion 
        ((string-match (concat "\\(" (class-re) "\\)\\'") line)

          (setq prefix (string-msub line 1))
          (message "Class or local member")
          (or
            (csharp-find-completions
              (car (vj-cu-find-fq-class-name-at-point))
              prefix)
            (csharp-type-search-with-using prefix t)))
              
        (t (message "DUNNO") 
          nil)
        )
      )
    (if classname 
      (setq vj-complete-csharp--current-classname classname))
            
    completions))


(defun vj-complete-get-csharp-completions ()
  (vj-complete-get-csharp-completions-begin)        
  (let (chain completions (line-and-prefix (vj-analyze-at-point)))
    (setq line (car line-and-prefix))
    (setq prefix (second line-and-prefix))

    ;; --- Add custom completions here ----
    ;; SOM 
    (if (string-match "addField(" line)
      (progn
        (message "Addfield %s" (string-msub line 1))
        (list '("file_key" "doc" "F")))
      (setq completions (vj-analyze-line line prefix)))))

(defun csharp-find-full-classname (classname-re prompt)
    (let ((classnames (csharp-type-search classname-re)))

        (vj-complete-add-to-context 
            (format "csharp-find-full-classname: %s"
                (mapconcat 'identity classnames ", ")))

        (if (> (length classnames) 1)
            (completing-read 
                prompt
                (mapcar (lambda (pair) (cons pair pair)) classnames)
                nil t)
            (car classnames))))


(defun csharp-map-primitives (type)
  ""
  (cond
    ((equal type "string") "System.String")
    ((equal type "int") "System.Int32")
    (t type)))


(defun vj-csharp-current-classname ()
  (interactive)
  (let ((namespace
          (or
            (save-excursion
              (if (re-search-backward "^[ \t]*namespace [ ]*\\([A-Za-z0-9_.]*\\)" nil t)
                (concat (match-string-no-properties 1) ".")))
            ""))
         (classname 
           (or
             (save-excursion
               (if (re-search-backward (concat "[ \t]*class [ ]*\\(" (ident-re)"\\)") nil t)
                 (match-string-no-properties 1)))
             nil)))
    (if classname (concat namespace classname))))


(defun csharp-find-decl (var)
  "Find variable type for VAR."
  (interactive)
  (or
    (if (equal var "this")
      (save-excursion
        (vj-cu-find-fq-class-name-at-point)))
    (let ((fq (vj-csharp-resolve-partial-class var nil))) ;; partial class?
      (if fq (list fq nil nil)))
    (csharp-find-loose-decl var)
    (csharp-find-mem-decl var)))

(defun csharp-find-decl-full (var &optional noerror)
  "Find variable type (fully qualified) for VAR.
Throws error on failure unless noerror is non-nil.
"
  (let* ((classname-list (csharp-find-decl var))
          (partial-classname (csharp-map-primitives (car classname-list)))
          (generic-type (nth 2 classname-list))
          generic-reflection-classname
          )
    (if partial-classname
      (progn
        (if generic-type
          (setq generic-reflection-classname 
            (concat partial-classname "`"
              (number-to-string (length (split-string generic-type ","))))))
        (vj-csharp-resolve-partial-class partial-classname generic-reflection-classname))
      ;; else
      (unless noerror
        (if partial-classname
          (error (format "Could not resolve partial classname `%s'\nfor variable `%s'"
                   partial-classname var))
          (error "Don't know what \"%s\" is" var))))))

(defun csharp-find-loose-decl (var)
  "Find variable type for VAR by looking for local variable.
Return name, special, generics
special can be [] or ?
generics can be <string, int>"
  (interactive)
  (save-excursion
    ;; Handle "t1[] var", "t2? var", "t3 var2, etc
    (vj-find-above
      (concat "\\_<\\([A-Z][A-Za-z_0-9]*\\)\\(\\[?\\]?\\|\\?\\)\\(<[^>]*>\\)? [ ]*\\<" var "\\>"))))


(defun csharp-find-mem-decl (var)
  "Find variable type for VAR."
  (interactive)
  (save-excursion
    (vj-find-above
          (concat
            "^[ \t]*\\(?:public\\|private\\|protected\\)[ ]*" ;; "^\s*+public", etc.
            "\\([A-Z][A-Za-z_0-9]*\\)\\(\\[?\\]?\\|\\?\\)\\(<[^>]*>\\)?[ 	]+"                 ; classname
            var "[ ]*[=;]"
                                        ; varname
            ))))
            

;;(csharp-find-completions "Digit" "")

(defun csharp-find-completions (classname prefix)
    ""
    (assert classname)
    (setq prefix (or prefix ""))
    (let (completions type csharp-type classnames-re str hierarchy-list)
        (setq hierarchy-list (csharp-find-class-hierarchy classname))
        (assert hierarchy-list)
        (setq classnames-re
            (concat "\\("
                (regexp-opt hierarchy-list)
                "\\)"))
        (setq str (concat "\\<"
                      classnames-re
                      "[-=]"
                      "\\(" (regexp-quote prefix) "[A-Za-z._0-9]*\\)"
                      "\\(.*\\)?"
                      ))
        (with-temp-buffer
            (insert-file-contents (vj-complete-csharp-db-filename))
            (goto-char (point-min))
            (while (re-search-forward str nil t)
                (setq csharp-type (buffer-substring-no-properties
                                      (point-at-bol) (1+ (point-at-bol))))
                (if (equal csharp-type "M") (setq type "F"))
                (if (equal csharp-type "P") (setq type "V"))
                (if (equal csharp-type "F") (setq type "V"))
                
                (add-to-list 'completions
                    (list
                        (match-string 2) ;completion "word"
                        (match-string 3) ; doc
                        type             ; completion type
                        (if (equal classname (match-string 1))
                            nil
                            (match-string 1))) ;classname
                    t)
                ))
        ;; return sorted completions
        (sort completions
            (lambda (a b)
                (let ((aa (car a)) (bb (car b)))

                    ;; FIXME (vj-csharp-boring-type-p classname)
                    (when (string-match "^System\\.\\(Object\\|Enum\\)" (or (nth 3 a) ""))
                        (setq aa (concat "ZZZ_" aa)))
                    (when (string-match "^System\\.\\(Object\\|Enum\\)" (or (nth 3 b) ""))
                        (setq bb (concat "ZZZ_" bb)))

                    (string-lessp (downcase aa)(downcase bb)))))
        ))


(defun csharp-find-using-declarations ()
 ""
  (save-excursion
    (let (completions (str "using[ ]*\\([A-Za-z][A-Za-z0-9._]*\\)"))
      (goto-char (point-min))
      (while (re-search-forward str nil t)
        (add-to-list 'completions (match-string-no-properties 1) t))
    completions)))


;; FIXME if too many match System.* replace them all with "System."
;; but only if prefix is not System!
(defun csharp-find-using-completions ()
  ""
  (let (completions (str (concat
                           ":"
                           "\\([A-Za-z][A-Za-z_0-9.]*\\)"
                           "\\."
                           "[A-Za-z][A-Za-z_0-9]*"
                           "[-=]"
                        )))
    (with-temp-buffer
      (insert-file-contents (vj-complete-csharp-db-filename))
      (goto-char (point-min))
      (while (re-search-forward str nil t)
        (add-to-list 'completions (concat (match-string 1) "") t) ; had to ";" -> "" FIXME
        ;;(message "MATCH %s" (match-string 1))
        ))
    completions))

(defun csharp-find-class-hierarchy (classname)
  ""
  (assert classname)
  (let ((hierarchy
          (if (string-match "`" classname) ;; a generic type?
            (gethash classname vj-complete-csharp-generic-types)
            (gethash classname vj-complete-csharp-types))))
    (if hierarchy
      (split-string (car hierarchy) "[ ]*->[ ]*")
      (error "No hierarchy for %s. Unknown type?" classname))))

(defun csharp-type-search (filter-regex)
  "Return all type C# types matching FILTER-REGEX.
Does not use using-declarations from the current buffer."
  (let (found name line
         (case-fold-search nil))
    (dolist (name vj-complete-csharp-type-list)
      (when (string-match filter-regex name)
          (add-to-list 'found name)))
    found))


(defun csharp-generic-type-search (filter-regexp)
  "Look for generic types matching FILTER-REGEXP and returns a list of class names.

Return format (class-name generic-number generic-rest).

Eg. (\"System.Collections.Generic.Dictionary\" \"`2\" \"+Enumerator\")
"
  (let* ((case-fold-search nil)
          found
          (regex (concat "^\\([^ ]*" filter-regexp "\\)" "\\(`[0-9]+\\)\\(+[^ ]*\\)" "\\'")))
    (dolist (name vj-complete-csharp-type-list)
      (if (string-match regex name)
        (add-to-list 'found (list
                              (substring name (match-beginning 1) (match-end 1))
                              (substring name (match-beginning 2) (match-end 2))
                              (substring name (match-beginning 3) (match-end 3))))))
    found))

(defun csharp-reload-tags ()
  "Load assembly tags files using vj-complete-csharp-filename as path prefix."
  (interactive)
  (let (generic-name name line ns top-ns
         (case-fold-search nil))
    (with-temp-buffer
      ;; clear caches
      (clrhash vj-complete-csharp-types)
      (clrhash vj-complete-csharp-generic-types)
      (clrhash vj-complete-csharp-namespaces)
      (clrhash vj-complete-csharp-top-namespaces)
      (setq vj-complete-csharp-type-list nil)
      (setq vj-complete-csharp-namespace-list nil)
      ;; 
      (insert-file-contents (vj-complete-csharp-cla-db-filename))
      (goto-char (point-min))      
      (while (re-search-forward "^\\(\\([^ `]*\\)\\(`[0-9]+\\(?:+[^ ]*\\)?\\)?\\) -> .*" nil t)
        (setq name (match-string 2))
        (setq generic-name (match-string 1))
        (setq line (match-string 0))
        (when (string-match "\\." name)
          (setq ns (replace-regexp-in-string "\\.[^.]*\\'" "" name))
          (setq top-ns (replace-regexp-in-string "\\.[^.]*" "" name))
          (add-to-list 'vj-complete-csharp-namespace-list ns)
          (puthash ns name vj-complete-csharp-namespaces) ;; FIXME add intermediates
          (puthash top-ns name vj-complete-csharp-top-namespaces))
          (add-to-list 'vj-complete-csharp-type-list generic-name)
        (if (equal name generic-name)
          (puthash name (list line name) vj-complete-csharp-types)
          ;; else
          (puthash name (list line generic-name) vj-complete-csharp-types)
          (puthash generic-name (list line nil) vj-complete-csharp-generic-types))))))


(defun csharp-full-type-name-p (classname)
  (gethash classname vj-complete-csharp-types))

(defun csharp-full-generic-type-name-p (classname)
  (gethash classname vj-complete-csharp-generic-types))


(defun vj-ns (ns classname)
  (concat ns (if ns "." "") classname))

(defun vj-csharp-resolve-partial-class (classname
                                         generic-reflection-classname)
  "Return fully qualified class name for a partial class name with the help of using declarations.
For generic types GENERIC-REFLECTION-CLASSNAME must be set to the name
with `1, `2+Enumerator etc."
  (interactive)

  (let (result fq-classname
         (current-ns
           (save-excursion
             (vj-find-above "^namespace[ 	]+\\([A-Z]\\sw*\\)"))))
    
    (dolist (namespace                   ; Include global namespace via (nil)
              (append (list current-ns) (csharp-find-using-declarations) '(nil)))
      (setq fq-classname (vj-ns namespace classname))
      (if (and (not result)
            (csharp-full-type-name-p fq-classname))
        (setq result (if generic-reflection-classname 
                       (vj-ns namespace generic-reflection-classname)
                       fq-classname))))
    result))

;;(csharp-full-type-name-p "System.Collections.Generic.List`1")
;;(csharp-full-generic-type-name-p "System.Collections.Generic.List`1")

;; FIXME csharp-find-return-type-loose ; allow partial classname and don't complain if there is only one match
;; (csharp-find-full-classname (concat "\\<" "HwResourceManager" "\\'")
;;   (format "Find declaration: What type is %s? " ""))


;; FIXME : NOTE return val is not fully qualified !!!
;; (csharp-find-return-type "AnalyzerControl.ServiceLayer.ProcessManager" "Instance")
;; => "ProcessManager"

(defun csharp-find-return-type (classname member)
    (assert  classname)
    (assert (csharp-full-type-name-p classname) nil (concat "csharp-find-return-type " classname " (not FQ)"))
    (let (completions sig
             return-type)
        (setq completions (csharp-find-completions classname member))
        (when completions 
            ;; Uses first completion only FIXME use (dolist completions) ?
            (setq sig (car (cdr (car completions))))

            (when (string-match ":[ ]*\\([^:]*\\)$"  sig)
                (setq return-type (substring sig (match-beginning 1) (match-end 1)))
                ))
        return-type))

(defun csharp-find-attribute-completions (class-prefix)
  ""
  (csharp-type-search-with-using (concat "\\<" class-prefix "[^ ]*Attribute") t))

(defun csharp-find-type-completions (classname-regexp)
  )

(defun csharp-current-namespace ()
  (save-excursion
    (vj-find-above "^namespace[ 	]+\\([A-Z]\\sw*\\)")))

(defun csharp-type-search-with-using (class-prefix cpl)
  ""
  (let (result partial-classname
         (current-ns (csharp-current-namespace)))
    (dolist (fq-classname (csharp-type-search class-prefix))
      (dolist (ns (append (list current-ns) (csharp-find-using-declarations) '(nil)))
        ;; FIXME do proper begins-with comparison using substring
        (when (string-match
                (if ns (concat (regexp-quote ns) "\\." class-prefix) class-prefix)
                fq-classname)
          (if ns
            (setq partial-classname (substring fq-classname (1+ (length ns))))
            (setq partial-classname fq-classname))
          (add-to-list 'result 
            (if cpl
              (list
                partial-classname
                (or
                  (car (gethash fq-classname vj-complete-csharp-types))
                  (car (gethash fq-classname vj-complete-csharp-generic-types))
                  "todo")
                "T")
              partial-classname)))))
    result))



;; (defun csharp-find-type-completions--old (&optional filter-regexp)
;;   ""
;;   (setq filter-regexp (or filter-regexp "."))
;;   (let (completions (str "^TYPE: \\(.*\\), \\([A-Z-][|,A-Za-z._0-9]*\\)?$")
;;          newname name rest
;;          (using-completions-re (regexp-opt (csharp-find-using-completions))))
;;     (setq using-completions-re (concat "\\`\\(?:" using-completions-re
;;                                  "\\)\\."))
;;     (with-temp-buffer
;;       (insert-file-contents (vj-complete-csharp-db-filename))
;;       (goto-char (point-min))      
;;       (while (re-search-forward str nil t)

;;         (setq name (match-string 1))
;;         (setq newname (match-string 1))
;;         (setq rest (match-string 2))

;;         ;; Remove fully qualified part from the using directves
;;         (setq newname (replace-regexp-in-string using-completions-re "" name))
        
;;         ;; Add both full name and shortened name (if any)
;;         (when (string-match filter-regexp newname)
;;           (add-to-list 'completions (list newname rest "I") t))
;;         (when (not (equal name newname))
;;           (when (string-match filter-regexp name)
;;             (add-to-list 'completions (list name rest "I") t)))
;;         ;;        (message "MATCH %s - %s" name (match-string 1))
;;         ))
;;     completions))


(provide 'vj-complete-csharp)

;;; vj-complete-csharp.el ends here
