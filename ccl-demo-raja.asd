(asdf:defsystem #:ccl-demo-raja
  :description "Describe ccl-demo-raja here"
  :author "Duncan Bayne"
  :license  "GNU Lesser Public License 3.0"
  :version "0.0.1"
  :serial t
  :depends-on (#:hunchentoot #:cl-who #:cl-json #:drakma #:cl-ppcre)
  :components ((:file "package")
               (:file "application")
	       (:file "main")
	       (:module :views
		:serial t
		:components ((:file "home")
			     (:file "people")))))
