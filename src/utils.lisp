(in-package :ccl-demo-raja)

(defun get-id-from-uri ()
  "Returns the ID from the URI request."
  (car (cl-ppcre:all-matches-as-strings "[0-9]+" (request-uri *request*))))

(defmacro nav-link ((&key url active) &body body)
  "Nav link component"
  `(htm
    (:li (:a :href ,url :class (if (string= ,active ,url) "active" nil) ,@body))))

(defmacro search-box ((&key url))
  "Search box component"
  `(htm
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
	 do (htm
	     (:img :width "100" :style "margin:1em;" :src (cdr (assoc film *films* :test #'string=))))))


(defmacro get-prop ((key obj))
  `(str (cdr (assoc ,key ,obj))))

(defun format-height (height)
  (concatenate 'string height " cm (" (write-to-string (* (parse-integer height) 0.0328084)) " ft)"))

(defmacro format-diameter (diameter)
  `(str
    (concatenate 'string ,diameter " Kilometers (" (write-to-string (* (parse-integer ,diameter) 0.621371)) " Miles)")))

(defmacro format-number (n)
  `(str (if (string= "unknown" ,n)
      "unknown"
      (concatenate 'string ,n " (" (format nil "~r" (parse-integer ,n)) ")"))))

(defmacro home-world (url)
  `(htm (:a
	   :_ (concatenate 'string "on load fetch " ,url " as json put it.name into my.innerHTML") 
	   :href (concatenate 'string "/planets/" (cl-ppcre:scan-to-strings "[0-9]+" ,url))
	   "Loading...")))

(defmacro get-vehicles (vehicles)
  `(loop for url in ,vehicles
	 do (htm
	       (:p
		(:a
		 :_ (concatenate 'string "on load fetch " url " as json put it.name into my.innerHTML") 
		 :href (concatenate 'string "/vehicles/" (cl-ppcre:scan-to-strings "[0-9]+" url)) "Loading...")))))

(defmacro get-starships (starships)
  `(loop for url in ,starships
	 do (htm
	       (:p
		(:a
		 :_ (concatenate 'string "on load fetch " url " as json put it.name into my.innerHTML") 
		 :href (concatenate 'string "/starships/" (cl-ppcre:scan-to-strings "[0-9]+" url)) "Loading...")))))

(defmacro get-species (species)
  `(loop for url in ,species
	 do (htm
	       (:p
		(:a
		 :_ (concatenate 'string "on load fetch " url " as json put it.name into my.innerHTML") 
		 :href (concatenate 'string "/species/" (cl-ppcre:scan-to-strings "[0-9]+" url)) "Loading...")))))



(defmacro get-people (people)
  `(loop for url in ,people
	 do (htm
	       (:p
		(:a
		 :_ (concatenate 'string "on load fetch " url " as json put it.name into my.innerHTML") 
		 :href (concatenate 'string "/people/" (cl-ppcre:scan-to-strings "[0-9]+" url)) "Loading...")))))

(defmacro list-component (items url name)
  `(htm (:ul :id "search-results"
	     :class "list"
	     (loop for item in ,items
		   do 
		      (let ((id (cl-ppcre:scan-to-strings "[0-9]+" (cdr (assoc :url item)))))
			(htm
			 (:li
			  (:a
			   :class (if (string= (get-id-from-uri) id) "active" nil)
			   :href (concatenate 'string ,url id)
			   (str (cdr (assoc ,name item)))))))))))
