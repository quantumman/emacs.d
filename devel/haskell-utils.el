(defun haskell-sort-functions-in-module ()
  (save-excursion
    (ghc-goto-module-position)
    (while (re-search-backward "^import \\([ \t.]\\|\\w\\)+(" nil t)
      (goto-char (match-end 0))
      (let ((begin (match-end 0))
            (end (line-end-position)))
        (save-match-data
          (sort-regexp-fields nil "\\w+" "\\&" begin end)))
      (goto-char (match-beginning 0))
      )))

(defun haskell-add-module ()
  (interactive)
  (ghc-insert-module)
  (ghc-sort-lines (haskell-module-begin-point)
                  (haskell-module-end-point))
  (haskell-sort-functions-in-module))

(defun haskell-module-begin-point ()
  (save-excursion
    (goto-char (point-min))
    (while (re-search-backward "^import" nil t))
    (point-to-beginnnig-line)))

(defun haskell-module-end-point ()
  (save-excursion
    (ghc-goto-module-position)
    (point)))

(require' el-expectations)

(expectations
  (desc "haskell-sort-functions-in-module")
  (expect "import Data.ByteString (append, concat, cons, snoc)"
    (with-temp-buffer
      (insert "import Data.ByteString (concat, snoc, append, cons)")
      (haskell-sort-functions-in-module)
      (buffer-string)
      ))
  (expect "import qualified Network.HTTP as HTTP (HttpMethod(..), StatusCode(..))"
    (with-temp-buffer
      (insert "import qualified Network.HTTP as HTTP (StatusCode(..), HttpMethod(..))")
      (haskell-sort-functions-in-module)
      (buffer-string)
      ))
  (expect "import qualified Network.HTTP as HTTP (HttpMethod(GET, POST), StatusCode(..)"
    (with-temp-buffer
      (insert "import qualified Network.HTTP as HTTP (StatusCode(..), HttpMethod(GET, POST))")
      (haskell-sort-functions-in-module)
      (buffer-string)
      ))
  )
