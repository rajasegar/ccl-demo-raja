(in-package :ccl-demo-raja)

;; Starships show page
(defun starships-show-page ()

  (let ((starship (cl-json:decode-json-from-string
		     (drakma:http-request (concatenate 'string "https://swapi.dev/api/starships/" (get-id-from-uri))
					  :method :get))))
  (format t "~a~%" starship)

  (demo-page (:title "Starships - Star Wars" :active "/starships")
    (:div :class "grid"
	  (:div
	   :class "left-panel"
	   (search-box (:url "/starships/search"))
	   (list-component (rest (assoc :results *starships*)) "/starships/" :name))
	  (:div
	   :class "right-panel"
	   (if (assoc :name starship)
	       (htm
		(:h2 (get-prop (:name starship)))
		(:table
		 (:tr (:td "Model:") (:td (get-prop (:model starship))))
		 (:tr (:td "Starship Class:") (:td (get-prop (:starship--class starship))))
		 (:tr (:td "Manufacturer:") (:td (get-prop (:manufacturer starship))))
		 (:tr (:td "Length:") (:td (get-prop (:length starship))))
		 (:tr (:td "Cost in credits:") (:td (format-number (cdr (assoc :cost--in--credits starship)))))
		 (:tr (:td "Crew:") (:td (get-prop (:crew starship))))
		 (:tr (:td "Passengers:") (:td (get-prop (:passengers starship))))
		 (:tr (:td "Max. Atmosphering Speed:") (:td (get-prop (:max--atmosphering--speed starship))))
		 (:tr (:td "Hyperdrive rating:") (:td (get-prop (:hyperdrive--rating starship))))
		 (:tr (:td "MGLT:") (:td (get-prop (:mglt starship))))
		 (:tr (:td "Cargo capacity:") (:td (format-number (cdr (assoc :cargo--capacity starship)))))
		 (:tr (:td "Consumables:") (:td (get-prop (:consumables starship))))
		 (:tr (:td "Films:") (:td (get-films (cdr (assoc :films starship)))))
		 (:tr (:td "Pilots:") (:td (get-residents (cdr (assoc :pilots starship)))))))
	       (htm (:h2 "Please select a starship"))))))))

