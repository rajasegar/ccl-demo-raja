(in-package :ccl-demo-raja)

;; Starships page
(defun starships-page ()
  
  (setq *starships* (cl-json:decode-json-from-string
		   (drakma:http-request "https://swapi.dev/api/starships/"
					:method :get)))

  (demo-page (:title "Starships - Star Wars" :active "/starships")
    (:div :class "grid"
	  (:div
	   :class "left-panel"
	   (search-box (:url "/starships/search"))
	   (list-component (rest (assoc :results *starships*)) "/starships/" :name))
	  (:div
	   :class "right-panel"
	   (:h2 "Please select a starship.")))))

