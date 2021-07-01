(in-package :ccl-demo-raja)

;; People show page
(defun people-show-page ()

  (let ((person (cl-json:decode-json-from-string
		     (drakma:http-request (concatenate 'string "https://swapi.dev/api/people/" (get-id-from-uri))
					  :method :get))))
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
			:class (if (string= (get-id-from-uri) (write-to-string i)) "active" nil)
			:href (concatenate 'string "/people/" (write-to-string i))
			(str (cdr (assoc :name character)))))))))
	  (:div
	   :class "right-panel"
	   (if (assoc :name person)
	       (htm
		(:h2 (get-prop (:name person)))
		(:table
		 (:tr (:td "Height:") (:td (cl-who:str (format-height (cdr (assoc :height person))))))
		 (:tr (:td "Mass:") (:td (get-prop (:mass person))))
		 (:tr (:td "Hair Color:") (:td (get-prop (:hair--color person))))
		 (:tr (:td "Skin Color:") (:td (get-prop (:skin--color person))))
		 (:tr (:td "Eye Color:") (:td (get-prop (:eye--color person))))
		 (:tr (:td "Birth Year:") (:td (get-prop (:birth--year person))))
		 (:tr (:td "Gender:") (:td (get-prop (:gender person))))
		 (:tr (:td "Home world:") (:td (home-world (cdr (assoc :homeworld person)))))
		 (:tr (:td "Films:") (:td (get-films (cdr (assoc :films person)))))
		 (:tr (:td "Species:") (:td (get-species (cdr (assoc :species person)))))
		 (:tr (:td "Vehicles:") (:td (get-vehicles (cdr (assoc :vehicles person)))))
		 (:tr (:td "Starships:") (:td (get-starships (cdr (assoc :starships person)))))))
	       (htm (:h2 "Please select a character"))))))))

