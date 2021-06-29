(in-package #:cl-user)

;; Config drakma
(push (cons "application" "json") drakma:*text-content-types*)
(setf drakma:*header-stream* *standard-output*)

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

;; People show page
(hunchentoot:define-easy-handler (people-show :uri "/people/show") (id)

  (setq *character* (cl-json:decode-json-from-string
		   (drakma:http-request (concatenate 'string "https://swapi.dev/api/people/" id)
					:method :get
					)))

  (demo-page (:title "People - Star Wars" :active "/people")
(:div :class "grid"
	  (:div
	   :class "left-panel"
	   (search-box (:url "/people/search"))
	   (:ul
	    :id "search-results"
	    :class "list"
		     (loop for character in (rest (assoc :results *people*))
			   for i from 1 to 10
			   do (cl-who:htm
			       (:li
				(:a
				 :class (if (string= id (write-to-string i)) "active" nil)
				 :href (concatenate 'string "/people/show?id=" (write-to-string i))
				 (cl-who:str (cdr (assoc :name character)))))))))
	  (:div
	   :class "right-panel"
		(if (assoc :name *character*)
		    (cl-who:htm
		     (:h2 (get-prop (:name *character*)))
		     (:table
		      (:tr (:td "Height:") (:td (cl-who:str (format-height (cdr (assoc :height *character*))))))
		      (:tr (:td "Mass:") (:td (cl-who:str (cdr (assoc :mass *character*)))))
		      (:tr (:td "Hair Color:") (:td (cl-who:str (cdr (assoc :hair--color *character*)))))
		      (:tr (:td "Skin Color:") (:td (cl-who:str (cdr (assoc :skin--color *character*)))))
		      (:tr (:td "Eye Color:") (:td (cl-who:str (cdr (assoc :eye--color *character*)))))
		      (:tr (:td "Birth Year:") (:td (cl-who:str (cdr (assoc :birth--year *character*)))))
		      (:tr (:td "Gender:") (:td (cl-who:str (cdr (assoc :gender *character*)))))
		      (:tr (:td "Home world:") (:td (cl-who:str (cdr (assoc :home--world *character*)))))
		      (:tr (:td "Films:") (:td (get-films (cdr (assoc :films *character*)))))
		      (:tr (:td "Species:") (:td (cl-who:str (cdr (assoc :species *character*)))))
		      (:tr (:td "Vehicles:") (:td (cl-who:str (cdr (assoc :vehicles *character*)))))
		      (:tr (:td "Starships:") (:td (cl-who:str (cdr (assoc :starships *character*)))))
		      ))
		    (cl-who:htm (:h2 "Please select a character")))))))


;; People page
(hunchentoot:define-easy-handler (people :uri "/people") ()

  (setq *people* (cl-json:decode-json-from-string
		   (drakma:http-request "https://swapi.dev/api/people/"
					:method :get
					)))
  (demo-page (:title "People - Star Wars" :active "/people")
(:div :class "grid"
	  (:div
	   :class "left-panel"
	   (search-box (:url "/people/search"))
	   (:ul
	    :id "search-results"
	    :class "list"
		     (loop for character in (rest (assoc :results *people*))
			   for i from 1 to 10
			   do (cl-who:htm
			       (:li
				(:a
				 :href (concatenate 'string "/people/show?id=" (write-to-string i))
				 (cl-who:str (cdr (assoc :name character)))))))))
	  (:div
	   :class "right-panel"
	   (:h2 "Please select a character")))))



;; Planets show page
(hunchentoot:define-easy-handler (planets-show :uri "/planets/show") (id)
  (format t "ID: ~a~%" id)
  (setq *planet* (cl-json:decode-json-from-string
		   (drakma:http-request (concatenate 'string "https://swapi.dev/api/planets/" id)
					:method :get
					)))

  (demo-page (:title "Planets - Star Wars" :active "/planets")
    (:div :class "grid"
	  (:div
	   :class "left-panel"
	   (search-box (:url "/planets/search"))
	   (:ul :id "search-results"
	    :class "list"
		     (loop for planet in (rest (assoc :results *planets*))
			   for i from 1 to 10
			   do (cl-who:htm
			       (:li
				(:a
				 :class (if (string= id (write-to-string i)) "active" nil)
				 :href (concatenate 'string "/planets/show?id=" (write-to-string i))
				 (cl-who:str (cdr (assoc :name planet)))))))))
	  (:div
	   :class "right-panel"
		(if (assoc :name *planet*)
		    (cl-who:htm
		     (:h2 (cl-who:str (cdr (assoc :name *planet*))))
		     (:table
		      (:tr (:td "Diameter:") (:td (format-diameter (cdr (assoc :diameter *planet*)))))
		      (:tr (:td "Rotation Period:") (:td (cl-who:str (cdr (assoc :rotation--period *planet*)))))
		      (:tr (:td "Orbital Period:") (:td (cl-who:str (cdr (assoc :orbital--period *planet*)))))
		      (:tr (:td "Gravity:") (:td (cl-who:str (cdr (assoc :gravity *planet*)))))
		      (:tr (:td "Population:") (:td (cl-who:str (format-population (cdr (assoc :population *planet*))))))
		      (:tr (:td "Climate:") (:td (cl-who:str (cdr (assoc :climate *planet*)))))
		      (:tr (:td "Terrain:") (:td (cl-who:str (cdr (assoc :terrain *planet*)))))
		      (:tr (:td "Surface Water:") (:td (cl-who:str (cdr (assoc :surface--water *planet*)))))
		      (:tr (:td "Residents:") (:td (cl-who:str (cdr (assoc :residents *planet*)))))
		      (:tr (:td "Films:") (:td (get-films (cdr (assoc :films *planet*)))))))
		    (cl-who:htm (:h2 "Please select a planet")))))))


;; Planets page
(hunchentoot:define-easy-handler (planets :uri "/planets") ()
  
  (setq *planets* (cl-json:decode-json-from-string
		   (drakma:http-request "https://swapi.dev/api/planets/"
					:method :get
					)))

  (demo-page (:title "Planets - Star Wars" :active "/planets")
    (:div :class "grid"
	  (:div
	   :class "left-panel"
	   (search-box (:url "/planets/search"))
	   (:ul :id "search-results"
	    :class "list"
		     (loop for planet in (rest (assoc :results *planets*))
			   for i from 1 to 10
			   do (cl-who:htm
			       (:li
				(:a
				 :href (concatenate 'string "/planets/show?id=" (write-to-string i))
				 (cl-who:str (cdr (assoc :name planet)))))))))
	  (:div
	   :class "right-panel"
	   (:h2 "Please select a planet.")))))

;; Home page
(hunchentoot:define-easy-handler (root :uri "/") ()
  (demo-page (:title "Star Wars - Common Lisp demo" :active "/")
    (:div :class "home-wrapper"
	(:h1 "Star Wars demo app in Common Lisp")
	(:p (:a :href "https://github.com/rajasegar/ccl-demo-raja" "Github Source code"))
	(:p "Built with: ")
	(:p (:a :href "https://lisp-lang.org" "Common Lisp"))
	(:p (:a :href "https://htmx.org" "HTMX"))
	(:p "Server: " (:a :href "https://edicl.github.io/hunchentoot/" "Hunchentoot"))
	(:p "API: " (:a :href "https://swapi.dev" "SWAPI.dev")))))

;; Search page - people
(hunchentoot:define-easy-handler (search-people :uri "/people/search") (search)
(setq *search-results* (cl-json:decode-json-from-string
		   (drakma:http-request (concatenate 'string "https://swapi.dev/api/people/?search=" search)
					:method :get
					)))
  (format t "~a~%" *search-results*)
  (cl-who:with-html-output-to-string (output nil :prologue nil)
    (loop for p in (rest (assoc :results *search-results*))
	  do
	    ;; (format t "~a~%" (cl-ppcre:scan-to-strings "[0-9]+" (cdr (assoc :url p))))
	     (cl-who:htm (:li
			  (:a :href (concatenate 'string "/people/show?id="  (cl-ppcre:scan-to-strings "[0-9]+" (cdr (assoc :url p))))
			   (cl-who:str (cdr (assoc :name p)))))))))

;; Search page - planets
(hunchentoot:define-easy-handler (search-planets :uri "/planets/search") (search)
(setq *search-results* (cl-json:decode-json-from-string
		   (drakma:http-request (concatenate 'string "https://swapi.dev/api/planets/?search=" search)
					:method :get
					)))
  (format t "~a~%" *search-results*)
  (cl-who:with-html-output-to-string (output nil :prologue nil)
    (loop for p in (rest (assoc :results *search-results*))
	  do
	    ;; (format t "~a~%" (cl-ppcre:scan-to-strings "[0-9]+" (cdr (assoc :url p))))
	     (cl-who:htm (:li
			  (:a :href (concatenate 'string "/planets/show?id="  (cl-ppcre:scan-to-strings "[0-9]+" (cdr (assoc :url p))))
			   (cl-who:str (cdr (assoc :name p)))))))))



(defvar *acceptor* nil)

(defun initialize-application (&key port)

    ;; Publish all static content.
    (push (hunchentoot:create-static-file-dispatcher-and-handler "/styles.css" "static/styles.css") hunchentoot:*dispatch-table*)

  (when *acceptor*
    (hunchentoot:stop *acceptor*))

  ;; Checking port numbers with different getenv
  (format t "uiop => ~a~%" (uiop:getenv "PORT"))
  (format t "asdf => ~a~%" (asdf:getenv "PORT"))
  (format t "ccl => ~a~%" (ccl:getenv "PORT"))

  (setf *acceptor*
    (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port port))))
