(in-package :ccl-demo-raja)

;; Config drakma
(push (cons "application" "json") drakma:*text-content-types*)
(setf drakma:*header-stream* *standard-output*)


