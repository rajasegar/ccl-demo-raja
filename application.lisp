(in-package :ccl-demo-raja)

;; Config drakma
(push (cons "application" "json") drakma:*text-content-types*)
(setf drakma:*header-stream* *standard-output*)

;; Publish all static content.
(push (hunchentoot:create-static-file-dispatcher-and-handler "/styles.css"  (asdf:system-relative-pathname 'ccl-demo-raja "static/styles.css")) hunchentoot:*dispatch-table*)
(push (hunchentoot:create-static-file-dispatcher-and-handler "/lisp-logo120x80.png"  (asdf:system-relative-pathname 'ccl-demo-raja "static/lisp-logo120x80.png")) hunchentoot:*dispatch-table*)

(defmacro nav-link ((&key url active) &body body)
  `(cl-who:htm
    (:li (:a :href ,url :class (if (string= ,active ,url) "active" nil) ,@body))))

(defmacro demo-page ((&key title active) &body body)
  `(cl-who:with-html-output-to-string
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

(defmacro search-box ((&key url))
  `(cl-who:htm
    (:div
     :class "search-wrapper"
     (:label :for "search-box" "Search:")
     (:div
      :class "search-box"
      (:input
       :id "search-box"
       :name "search"
       :class "search-field"
       :type "text"
       :hx-post, url 
       :hx-trigger "keyup changed delay:500ms"
       :hx-target "#search-results"
       :hx-indicator ".htmx-indicator")))
    (:div :id "loading-search" :class "htmx-indicator" "Loading...")))

(setq *films* '(("https://swapi.dev/api/films/1/" . "https://m.media-amazon.com/images/M/MV5BYTRhNjcwNWQtMGJmMi00NmQyLWE2YzItODVmMTdjNWI0ZDA2XkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_SY999_SX666_AL_.jpg")
		("https://swapi.dev/api/films/2/" . "https://m.media-amazon.com/images/M/MV5BMDAzM2M0Y2UtZjRmZi00MzVlLTg4MjEtOTE3NzU5ZDVlMTU5XkEyXkFqcGdeQXVyNDUyOTg3Njg@._V1_SY999_CR0,0,659,999_AL_.jpg")
		("https://swapi.dev/api/films/3/" . "https://m.media-amazon.com/images/M/MV5BNTc4MTc3NTQ5OF5BMl5BanBnXkFtZTcwOTg0NjI4NA@@._V1_SY1000_SX750_AL_.jpg")
		("https://swapi.dev/api/films/4/" . "https://m.media-amazon.com/images/M/MV5BNzVlY2MwMjktM2E4OS00Y2Y3LWE3ZjctYzhkZGM3YzA1ZWM2XkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_.jpg")
		("https://swapi.dev/api/films/5/" . "https://m.media-amazon.com/images/M/MV5BYmU1NDRjNDgtMzhiMi00NjZmLTg5NGItZDNiZjU5NTU4OTE0XkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SY1000_CR0,0,641,1000_AL_.jpg")
		("https://swapi.dev/api/films/6/" . "https://m.media-amazon.com/images/M/MV5BOWZlMjFiYzgtMTUzNC00Y2IzLTk1NTMtZmNhMTczNTk0ODk1XkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_SY999_CR0,0,644,999_AL_.jpg")
		("https://swapi.dev/api/films/7/" . "https://m.media-amazon.com/images/M/MV5BOTAzODEzNDAzMl5BMl5BanBnXkFtZTgwMDU1MTgzNzE@._V1_SY1000_CR0,0,677,1000_AL_.jpg")
		("https://swapi.dev/api/films/8/" . "https://m.media-amazon.com/images/M/MV5BMjQ1MzcxNjg4N15BMl5BanBnXkFtZTgwNzgwMjY4MzI@._V1_SY1000_CR0,0,675,1000_AL_.jpg")))

(defmacro get-films (films)
  `(loop for film in ,films 
	 do (cl-who:htm
	     (:img :width "100" :style "margin:1em;" :src (cdr (assoc film *films* :test #'string=))))))


(defmacro get-prop ((key obj))
  `(cl-who:str (cdr (assoc ,key ,obj))))

(defun format-height (height)
  (concatenate 'string height " cm (" (write-to-string (* (parse-integer height) 0.0328084)) " ft)"))

(defmacro format-diameter (diameter)
  `(cl-who:str
    (concatenate 'string ,diameter " Kilometers (" (write-to-string (* (parse-integer ,diameter) 0.621371)) " Miles)")))

(defun format-population (population)
  (if (string= "unknown" population)
      "unknown"
      (concatenate 'string population " (" (format nil "~r" (parse-integer population)) ")")))

(defmacro home-world (url)
  `(let ((homeworld (cl-json:decode-json-from-string
		    (drakma:http-request ,url :method :get))))
     (cl-who:htm (:a
		  :href (concatenate 'string "/planets/show?id=" (cl-ppcre:scan-to-strings "[0-9]+" ,url))
		  (cl-who:str (cdr (assoc :name homeworld)))))))






