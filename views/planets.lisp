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
	   (list-component (rest (assoc :results *planets*)) "/planets/" :name))
	  (:div
	   :class "right-panel"
	   (:h2 "Please select a planet.")))))

