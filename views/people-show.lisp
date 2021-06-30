(in-package :ccl-demo-raja)

;; People show page
(define-easy-handler (people-show :uri "/people/show") (id)

  (let ((person (decode-json-from-string
		     (http-request (concatenate 'string "https://swapi.dev/api/people/" id)
					  :method :get
					  ))))
  (format t "~a~%" person)

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
			:class (if (string= id (write-to-string i)) "active" nil)
			:href (concatenate 'string "/people/show?id=" (write-to-string i))
			(str (cdr (assoc :name character)))))))))
	  (:div
	   :class "right-panel"
	   (if (assoc :name person)
	       (htm
		(:h2 (get-prop (:name person)))
		(:table
		 (:tr (:td "Height:") (:td (cl-who:str (format-height (cdr (assoc :height person))))))
		 (:tr (:td "Mass:") (:td (cl-who:str (cdr (assoc :mass person)))))
		 (:tr (:td "Hair Color:") (:td (cl-who:str (cdr (assoc :hair--color person)))))
		 (:tr (:td "Skin Color:") (:td (cl-who:str (cdr (assoc :skin--color person)))))
		 (:tr (:td "Eye Color:") (:td (cl-who:str (cdr (assoc :eye--color person)))))
		 (:tr (:td "Birth Year:") (:td (cl-who:str (cdr (assoc :birth--year person)))))
		 (:tr (:td "Gender:") (:td (cl-who:str (cdr (assoc :gender person)))))
		 (:tr (:td "Home world:") (:td (home-world (cdr (assoc :homeworld person)))))
		 (:tr (:td "Films:") (:td (get-films (cdr (assoc :films person)))))
		 (:tr (:td "Species:") (:td (cl-who:str (cdr (assoc :species person)))))
		 (:tr (:td "Vehicles:") (:td (cl-who:str (cdr (assoc :vehicles person)))))
		 (:tr (:td "Starships:") (:td (cl-who:str (cdr (assoc :starships person)))))
		 ))
	       (htm (:h2 "Please select a character"))))))))

