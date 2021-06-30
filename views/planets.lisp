(in-package :ccl-demo-raja)

;; Planets page
(defun planets-page ()
  
  (setq *planets* (cl-json:decode-json-from-string
		   (drakma:http-request "https://swapi.dev/api/planets/"
					:method :get)))

  (demo-page (:title "Planets - Star Wars" :active "/planets")
    (:div :class "grid"
	  (:div
	   :class "left-panel"
	   (search-box (:url "/planets/search"))
	   (:ul :id "search-results"
		:class "list"
		(loop for planet in (rest (assoc :results *planets*))
		      for i from 1 to 10
		      do (htm
			  (:li
			   (:a
			    :href (concatenate 'string "/planets/" (write-to-string i))
			    (str (cdr (assoc :name planet)))))))))
	  (:div
	   :class "right-panel"
	   (:h2 "Please select a planet.")))))

