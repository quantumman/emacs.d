(require 'fsharp)

(defun test ()
  (with-temp-buffer
    (insert "let SplitAtSpaces (text: string) =
    text.Split ' '
    |> Array.toList
    ;;")
    (let ((head-marker (set-marker (make-marker) (point-min)))
	  (tail-marker (set-marker (make-marker) (point-max))))
      (fsharp-eval-region head-marker tail-marker)
      )))