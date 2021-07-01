(in-package :ccl-demo-raja)

;; Films page
(defun films-page ()

  (setq *film-results* (cl-json:decode-json-from-string
		  (drakma:http-request "https://swapi.dev/api/films/"
				       :method :get)))
  (demo-page (:title "Films - Star Wars" :active "/films")
    (:div :class "grid"
	  (:div
	   :class "left-panel"
	   (list-component (rest (assoc :results *film-results*)) "/films/" :title))
	  (:div
	   :class "right-panel"
	   (:h2 "Please select a film.")))))

