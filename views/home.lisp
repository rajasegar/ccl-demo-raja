(in-package :ccl-demo-raja)

;; Home page
(defun home-page ()
  (demo-page (:title "Star Wars - Common Lisp demo" :active "/")
    (:div :class "home-wrapper"
	  (:h1 "Star Wars demo app in Common Lisp")
	  (:p (:a :href "https://github.com/rajasegar/ccl-demo-raja" "Github Source code"))
	  (:p "Built with: ")
	  (:p (:a :href "https://lisp-lang.org" "Common Lisp"))
	  (:p (:a :href "https://htmx.org" "HTMX"))
	  (:p "Server: " (:a :href "https://edicl.github.io/hunchentoot/" "Hunchentoot"))
	  (:p "API: " (:a :href "https://swapi.dev" "SWAPI.dev"))
	  (:p (:img :src "lisp-logo120x80.png")))))
