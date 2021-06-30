(in-package :ccl-demo-raja)

(defmacro demo-page ((&key title active) &body body)
  `(with-html-output-to-string
       (*standard-output* nil :prologue t :indent t)
     (:html :lang "en"
	    (:head
	     (:meta :charset "utf-8")
	     (:title, title)
	     (:link :href "/styles.css" :rel "stylesheet")
	     )
	    (:body 
	     (:nav
	      (:ul
	       (nav-link (:url "/" :active ,active) "Star Wars")
	       (nav-link (:url "/people" :active ,active) "People")
	       (nav-link (:url "/planets" :active ,active) "Planets")))
	     (:main ,@body)
	     (:script :src "https://unpkg.com/htmx.org@1.4.1")
	     ))))
