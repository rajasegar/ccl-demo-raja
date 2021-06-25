(in-package #:cl-user)

(defmacro demo-page ((&key title) &body body)
  `(cl-who:with-html-output-to-string
       (*standard-output* nil :prologue t :indent t)
     (:html :lang "en"
	    (:head
	     (:meta :charset "utf-8")
	     (:title, title)
	     (:link :href "styles.css" :rel "stylesheet")
	     )
	    (:body
	     (:nav
	      (:ul
	       (:li (:a :href "/" "Home"))
	       (:li (:a :href "/about" "About"))
	       (:li (:a :href "/contact" "Contact"))))
	     (:div :class "container"
		   (:h1 "Demo page")
		   ,@body)))))

(hunchentoot:define-easy-handler (about :uri "/about") ()
  (demo-page (:title "About")
	     (:h1 "About page")))

(hunchentoot:define-easy-handler (contact :uri "/contact") ()
  (demo-page (:title "Contact")
	     (:h1 "Contact page")))

(hunchentoot:define-easy-handler (root :uri "/") ()
  (demo-page (:title "Home")
    (:h1 "Home")))

;; Publish all static content.
(push (hunchentoot:create-static-file-dispatcher-and-handler "/styles.css" "static/styles.css") hunchentoot:*dispatch-table*)


(defvar *acceptor* nil)

(defun initialize-application (&key port)
  (setf hunchentoot:*dispatch-table*
    `(hunchentoot:dispatch-easy-handlers
       ,(hunchentoot:create-folder-dispatcher-and-handler
          "/" "/app/static/")))

  (when *acceptor*
    (hunchentoot:stop *acceptor*))

  (setf *acceptor*
    (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port port))))
