(in-package :ccl-demo-raja)

;; Vehicles page
(defun vehicles-page ()
  
  (setq *vehicles* (cl-json:decode-json-from-string
		   (drakma:http-request "https://swapi.dev/api/vehicles/"
					:method :get)))

  (demo-page (:title "Vehicles - Star Wars" :active "/vehicles")
    (:div :class "grid"
	  (:div
	   :class "left-panel"
	   (search-box (:url "/vehicles/search"))
	   (list-component (rest (assoc :results *vehicles*)) "/vehicles/" :name))
	  (:div
	   :class "right-panel"
	   (:h2 "Please select a vehicle.")))))

