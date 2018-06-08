(asdf:defsystem #:heroku-app-clozure-common-lisp
  :description "Describe heroku-app-clozure-common-lisp here"
  :author "Duncan Bayne"
  :license  "GNU Lesser Public License 3.0"
  :version "0.0.1"
  :serial t
  :depends-on (#:hunchentoot #:cl-who)
  :components ((:file "package")
               (:file "application")))
