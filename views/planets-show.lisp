(in-package :ccl-demo-raja)

;; Planets show page
(defun planets-show-page ()
  (format t "ID: ~a~%" (get-id-from-uri))
  (let ((planet (cl-json:decode-json-from-string
		 (drakma:http-request (concatenate 'string "https://swapi.dev/api/planets/" (get-id-from-uri))
				      :method :get))))

    (demo-page (:title "Planets - Star Wars" :active "/planets")
      (:div :class "grid"
	    (:div
	     :class "left-panel"
	     (search-box (:url "/planets/search"))
	     (:ul :id "search-results"
		  :class "list"
		  (loop for planet-item in (rest (assoc :results *planets*))
			for i from 1 to 10
			do (htm
			    (:li
			     (:a
			      :class (if (string= (get-id-from-uri) (write-to-string i)) "active" nil)
			      :href (concatenate 'string "/planets/" (write-to-string i))
			      (str (cdr (assoc :name planet-item)))))))))
	    (:div
	     :class "right-panel"
	     (if (assoc :name planet)
		 (htm
		  (:h2 (str (cdr (assoc :name planet))))
		  (:table
		   (:tr (:td "Diameter:") (:td (format-diameter (cdr (assoc :diameter planet)))))
		   (:tr (:td "Rotation Period:") (:td (str (cdr (assoc :rotation--period planet)))))
		   (:tr (:td "Orbital Period:") (:td (str (cdr (assoc :orbital--period planet)))))
		   (:tr (:td "Gravity:") (:td (str (cdr (assoc :gravity planet)))))
		   (:tr (:td "Population:") (:td (str (format-population (cdr (assoc :population planet))))))
		   (:tr (:td "Climate:") (:td (str (cdr (assoc :climate planet)))))
		   (:tr (:td "Terrain:") (:td (str (cdr (assoc :terrain planet)))))
		   (:tr (:td "Surface Water:") (:td (str (cdr (assoc :surface--water planet)))))
		   (:tr (:td "Residents:") (:td (str (cdr (assoc :residents planet)))))
		   (:tr (:td "Films:") (:td (get-films (cdr (assoc :films planet)))))))
		 (htm (:h2 "Please select a planet"))))))))
