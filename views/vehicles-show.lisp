(in-package :ccl-demo-raja)

;; Vehicles show page
(defun vehicles-show-page ()

  (let ((vehicle (cl-json:decode-json-from-string
		     (drakma:http-request (concatenate 'string "https://swapi.dev/api/vehicles/" (get-id-from-uri))
					  :method :get))))
  (format t "~a~%" vehicle)

  (demo-page (:title "Vehicles - Star Wars" :active "/vehicles")
    (:div :class "grid"
	  (:div
	   :class "left-panel"
	   (search-box (:url "/vehicles/search"))
	   (list-component (rest (assoc :results *vehicles*)) "/vehicles/" :name))
	  (:div
	   :class "right-panel"
	   (if (assoc :name vehicle)
	       (htm
		(:h2 (get-prop (:name vehicle)))
		(:table
		 (:tr (:td "Model:") (:td (get-prop (:model vehicle))))
		 (:tr (:td "Vehicle Class:") (:td (get-prop (:vehicle--class vehicle))))
		 (:tr (:td "Manufacturer:") (:td (get-prop (:manufacturer vehicle))))
		 (:tr (:td "Length:") (:td (get-prop (:length vehicle))))
		 (:tr (:td "Cost in credits:") (:td (format-number (cdr (assoc :cost--in--credits vehicle)))))
		 (:tr (:td "Crew:") (:td (get-prop (:crew vehicle))))
		 (:tr (:td "Passengers:") (:td (get-prop (:passengers vehicle))))
		 (:tr (:td "Max. Atmosphering Speed:") (:td (get-prop (:max--atmosphering--speed vehicle))))
		 (:tr (:td "Cargo capacity:") (:td (get-prop (:cargo--capacity vehicle))))
		 (:tr (:td "Consumables:") (:td (get-prop (:consumables vehicle))))
		 (:tr (:td "Films:") (:td (get-films (cdr (assoc :films vehicle)))))
		 (:tr (:td "Pilots:") (:td (get-people (cdr (assoc :pilots vehicle)))))))
	       (htm (:h2 "Please select a vehicle"))))))))

