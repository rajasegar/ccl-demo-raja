(in-package :ccl-demo-raja)

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

