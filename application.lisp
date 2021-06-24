;; TODO: duncan@bayne.id.au: make the Buildpack aware of the app package name
(in-package #:cl-user)
(djula:add-template-directory (asdf:system-relative-pathname "heroku-app-clozure-common-lisp" "templates/"))

(defparameter +about.html+ (djula:compile-template* "about.html"))



(easy-routes:defroute about ("/about" :method :get) ()
  (djula:render-template* +about.html+ nil 
                        :title "Ukeleles"
                        :project-name "Ukeleles"
                        :mode "welcome"))


(easy-routes:defroute root ("/" :method :get) ()
  (cl-who:with-html-output-to-string (s nil :prologue t)
    (:html
      (:body
        (:p "Hello, World!")
	(:p (:a :href "/about" "About"))
        (:img :src "/lisp-logo120x80.png")))))


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
