(in-package #:cl-user)

(defvar *acceptor* nil)

(defun initialize-application (&key port)

  (when *acceptor*
    (hunchentoot:stop *acceptor*))

  (setf *acceptor*
	(hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port port))))
