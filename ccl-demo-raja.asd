(asdf:defsystem #:ccl-demo-raja
  :description "Describe ccl-demo-raja here"
  :author "Duncan Bayne"
  :license  "GNU Lesser Public License 3.0"
  :version "0.0.1"
  :serial t
  :depends-on (#:hunchentoot #:cl-who #:easy-routes)
  :components ((:file "package")
               (:file "application")))