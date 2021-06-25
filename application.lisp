(in-package #:cl-user)

;; Config drakma
(push (cons "application" "json") drakma:*text-content-types*)
(setf drakma:*header-stream* *standard-output*)

(defmacro demo-page ((&key title) &body body)
  `(cl-who:with-html-output-to-string
       (*standard-output* nil :prologue t :indent t)
     (:html :lang "en"
	    (:head
	     (:meta :charset "utf-8")
	     (:title, title)
	     (:link :href "/styles.css" :rel "stylesheet")
	     )
	    (:body :hx-boost "true"
	     (:nav
	      (:ul
	       (:li (:a :href "/" "Star Wars"))
	       (:li (:a :href "/people" "People"))
	       (:li (:a :href "/planets" "Planets"))))
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


;; People show page
(hunchentoot:define-easy-handler (people-show :uri "/people/show") (id)

  (setq *character* (cl-json:decode-json-from-string
		   (drakma:http-request (concatenate 'string "https://swapi.dev/api/people/" id)
					:method :get
					)))

  (demo-page (:title "People - Star Wars")
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
		(if (assoc :name *character*)
		    (cl-who:htm
		     (:h2 (cl-who:str (cdr (assoc :name *character*))))
		     (:table
		      (:tr (:td "Height:") (:td (cl-who:str (cdr (assoc :height *character*)))))
		      (:tr (:td "Mass:") (:td (cl-who:str (cdr (assoc :mass *character*)))))
		      (:tr (:td "Hair Color:") (:td (cl-who:str (cdr (assoc :hair--color *character*)))))
		      (:tr (:td "Skin Color:") (:td (cl-who:str (cdr (assoc :skin--color *character*)))))
		      (:tr (:td "Eye Color:") (:td (cl-who:str (cdr (assoc :eye--color *character*)))))
		      (:tr (:td "Birth Year:") (:td (cl-who:str (cdr (assoc :birth--year *character*)))))
		      (:tr (:td "Gender:") (:td (cl-who:str (cdr (assoc :gender *character*)))))
		      (:tr (:td "Home world:") (:td (cl-who:str (cdr (assoc :home--world *character*)))))
		      (:tr (:td "Films:") (:td (cl-who:str (cdr (assoc :films *character*)))))
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
  (demo-page (:title "People - Star Wars")
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

  (demo-page (:title "Planets - Star Wars")
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
		(if (assoc :name *planet*)
		    (cl-who:htm
		     (:h2 (cl-who:str (cdr (assoc :name *planet*))))
		     (:table
		      (:tr (:td "Diameter:") (:td (cl-who:str (cdr (assoc :diameter *planet*)))))
		      (:tr (:td "Rotation Period:") (:td (cl-who:str (cdr (assoc :rotation--period *planet*)))))
		      (:tr (:td "Orbital Period:") (:td (cl-who:str (cdr (assoc :orbital--period *planet*)))))
		      (:tr (:td "Gravity:") (:td (cl-who:str (cdr (assoc :gravity *planet*)))))
		      (:tr (:td "Population:") (:td (cl-who:str (cdr (assoc :population *planet*)))))
		      (:tr (:td "Climate:") (:td (cl-who:str (cdr (assoc :climate *planet*)))))
		      (:tr (:td "Terrain:") (:td (cl-who:str (cdr (assoc :terrain *planet*)))))
		      (:tr (:td "Surface Water:") (:td (cl-who:str (cdr (assoc :surface--water *planet*)))))
		      (:tr (:td "Residents:") (:td (cl-who:str (cdr (assoc :residents *planet*)))))
		      (:tr (:td "Films:") (:td (cl-who:str (cdr (assoc :films *planet*)))))))
		    (cl-who:htm (:h2 "Please select a planet")))))))


;; Planets page
(hunchentoot:define-easy-handler (planets :uri "/planets") ()
  
  (setq *planets* (cl-json:decode-json-from-string
		   (drakma:http-request "https://swapi.dev/api/planets/"
					:method :get
					)))

  (demo-page (:title "Planets - Star Wars")
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
  (demo-page (:title "Star Wars - Common Lisp demo")
    (:h1 "Home")
    (:p "This is a Starwars demo swapi demo")
    ))

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

  (setf *acceptor*
    (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port port))))
