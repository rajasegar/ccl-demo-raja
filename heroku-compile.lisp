;; TODO: duncan@bayne.id.au: HACK: fix this
(mapcar 'print (directory (make-pathname :directory '(:relative ".") :name :wild))
(load "./system.asd")
(ql:quickload :heroku-app-common-lisp)
