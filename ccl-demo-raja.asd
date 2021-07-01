(asdf:defsystem #:ccl-demo-raja
  :description "Starwars api demo in Common Lisp"
  :author "Rajasegar Chandran"
  :license  "GNU Lesser Public License 3.0"
  :version "0.0.1"
  :serial t
  :depends-on (#:hunchentoot #:cl-who #:cl-json #:drakma #:cl-ppcre)
  :components ((:file "package")
               (:file "config")
	       (:file "main")
	       (:module :src
		:serial t
		:components ((:file "controllers")
			     (:file "utils")))
	       (:module :views
		:serial t
		:components ((:file "layout")
			     (:file "home")
			     (:file "people")
			     (:file "people-show")
			     (:file "planets")
			     (:file "planets-show")
			     (:file "vehicles")
			     (:file "vehicles-show")
			     (:file "starships")
			     (:file "starships-show")
			     (:file "films")
			     (:file "films-show")))))
