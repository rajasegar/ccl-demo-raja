(in-package :ccl-demo-raja)

;; People page
(define-easy-handler (people :uri "/people") ()

  (setq *people* (decode-json-from-string
		  (http-request "https://swapi.dev/api/people/"
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
		  do (htm
		      (:li
		       (:a
			:href (concatenate 'string "/people/show?id=" (write-to-string i))
			(str (cdr (assoc :name character)))))))))
	  (:div
	   :class "right-panel"
	   (:h2 "Please select a character")))))

