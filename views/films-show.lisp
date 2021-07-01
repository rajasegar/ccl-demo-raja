(in-package :ccl-demo-raja)

(setq *films* '(("https://swapi.dev/api/films/1/" . "https://m.media-amazon.com/images/M/MV5BYTRhNjcwNWQtMGJmMi00NmQyLWE2YzItODVmMTdjNWI0ZDA2XkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_SY999_SX666_AL_.jpg")
		("https://swapi.dev/api/films/2/" . "https://m.media-amazon.com/images/M/MV5BMDAzM2M0Y2UtZjRmZi00MzVlLTg4MjEtOTE3NzU5ZDVlMTU5XkEyXkFqcGdeQXVyNDUyOTg3Njg@._V1_SY999_CR0,0,659,999_AL_.jpg")
		("https://swapi.dev/api/films/3/" . "https://m.media-amazon.com/images/M/MV5BNTc4MTc3NTQ5OF5BMl5BanBnXkFtZTcwOTg0NjI4NA@@._V1_SY1000_SX750_AL_.jpg")
		("https://swapi.dev/api/films/4/" . "https://m.media-amazon.com/images/M/MV5BNzVlY2MwMjktM2E4OS00Y2Y3LWE3ZjctYzhkZGM3YzA1ZWM2XkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_.jpg")
		("https://swapi.dev/api/films/5/" . "https://m.media-amazon.com/images/M/MV5BYmU1NDRjNDgtMzhiMi00NjZmLTg5NGItZDNiZjU5NTU4OTE0XkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SY1000_CR0,0,641,1000_AL_.jpg")
		("https://swapi.dev/api/films/6/" . "https://m.media-amazon.com/images/M/MV5BOWZlMjFiYzgtMTUzNC00Y2IzLTk1NTMtZmNhMTczNTk0ODk1XkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_SY999_CR0,0,644,999_AL_.jpg")
		("https://swapi.dev/api/films/7/" . "https://m.media-amazon.com/images/M/MV5BOTAzODEzNDAzMl5BMl5BanBnXkFtZTgwMDU1MTgzNzE@._V1_SY1000_CR0,0,677,1000_AL_.jpg")
		("https://swapi.dev/api/films/8/" . "https://m.media-amazon.com/images/M/MV5BMjQ1MzcxNjg4N15BMl5BanBnXkFtZTgwNzgwMjY4MzI@._V1_SY1000_CR0,0,675,1000_AL_.jpg")))


;; Films show page
(defun films-show-page ()

  (let ((film (cl-json:decode-json-from-string
		     (drakma:http-request (concatenate 'string "https://swapi.dev/api/films/" (get-id-from-uri))
					  :method :get))))
  (format t "~a~%" film)

  (demo-page (:title "Films - Star Wars" :active "/films")
    (:div :class "grid"
	  (:div
	   :class "left-panel"
	   (list-component (rest (assoc :results *film-results*)) "/films/" :title))
	  (:div
	   :class "right-panel"
	   (if (assoc :title film)
	       (htm
		(:h2 (get-prop (:title film)))
		(:table
		 (:tr (:td "Episode:") (:td (get-prop (:episode--id film))))
		 (:tr (:td "Director:") (:td (get-prop (:director film))))
		 (:tr (:td "Producer:") (:td (get-prop (:producer film))))
		 (:tr (:td "Release Date:") (:td (get-prop (:release--date film)))))
		(:p
		 (:img
		  :width "500"
		  :src (cdr (assoc (cdr (assoc :url film)) *films* :test #'string=)))))
	       (htm (:h2 "Please select a character"))))))))

