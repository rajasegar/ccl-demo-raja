(in-package #:cl-user)

(defmacro demo-page ((&key title script) &body body)
  `(cl-who:with-html-output-to-string
       (*standard-output* nil :prologue t :indent t)
     (:html :lang "en"
	    (:head
	     (:meta :charset "utf-8")
	     (:title, title))
	    (:body
	     (:nav
	      (:ul
	       (:li (:a :href "/" "Home"))
	       (:li (:a :href "/about" "About"))
	       (:li (:a :href "/contact" "Contact"))))
	     (:div :class "container"
		   (:h1 "Demo page")
		   ,@body)))))

(easy-routes:defroute about ("/about" :method :get) ()
  (demo-page (:title "About")
	     (:h1 "About page")))

(easy-routes:defroute contact ("/contact" :method :get) ()
  (demo-page (:title "Contact")
	     (:h1 "Contact page")))

(easy-routes:defroute root ("/" :method :get) ()
  (demo-page (:title "Home")
    (:h1 "Home")))


(defvar *acceptor* nil)

(defun initialize-application (&key port)
  (setf hunchentoot:*dispatch-table*
    `(hunchentoot:dispatch-easy-handlers
       ,(hunchentoot:create-folder-dispatcher-and-handler
          "/" "/static/")))

  (when *acceptor*
    (hunchentoot:stop *acceptor*))

  (setf *acceptor*
    (hunchentoot:start (make-instance 'easy-routes:easy-routes-acceptor :port port))))
