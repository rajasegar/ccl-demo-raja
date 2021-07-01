(in-package :ccl-demo-raja)

;; Define hunchentoot dispatch table
(setq *dispatch-table*
      (list
       (create-regex-dispatcher "^/$" 'home-page)
       (create-regex-dispatcher "^/planets$" 'planets-page)
       (create-regex-dispatcher "^/planets/search$" 'planets-search)
       (create-regex-dispatcher "^/planets/[0-9]+$" 'planets-show-page)
       (create-regex-dispatcher "^/people$" 'people-page)
       (create-regex-dispatcher "^/people/search$" 'people-search)
       (create-regex-dispatcher "^/people/[0-9]+$" 'people-show-page)
       (create-regex-dispatcher "^/vehicles$" 'vehicles-page)
       (create-regex-dispatcher "^/vehicles/search$" 'vehicles-search)
       (create-regex-dispatcher "^/vehicles/[0-9]+$" 'vehicles-show-page)
       (create-regex-dispatcher "^/starships$" 'starships-page)
       (create-regex-dispatcher "^/starships/search$" 'starships-search)
       (create-regex-dispatcher "^/starships/[0-9]+$" 'starships-show-page)
       (create-regex-dispatcher "^/films$" 'films-page)
       (create-regex-dispatcher "^/films/search$" 'films-search)
       (create-regex-dispatcher "^/films/[0-9]+$" 'films-show-page)
       (create-static-file-dispatcher-and-handler "/styles.css"  "static/styles.css")
       (create-static-file-dispatcher-and-handler "/lisp-logo120x80.png"  "static/lisp-logo120x80.png")))

(defun planets-search ()
  (let ((search (parameter "search")))
    (search-page search "planets")))

(defun people-search ()
  (let ((search (parameter "search")))
    (search-page search "people")))

(defun vehicles-search ()
  (let ((search (parameter "search")))
    (search-page search "vehicles")))

(defun starships-search ()
  (let ((search (parameter "search")))
    (search-page search "starships")))

(defun films-search ()
  (let ((search (parameter "search")))
    (search-page search "films")))

;; Search page
(defun search-page (query resource)
  (setq *search-results* (cl-json:decode-json-from-string
			  (drakma:http-request (concatenate 'string "https://swapi.dev/api/" resource "/?search=" query)
					       :method :get)))
  (format t "~a~%" *search-results*)
  (cl-who:with-html-output-to-string (output nil :prologue nil)
    (loop for p in (rest (assoc :results *search-results*))
	  do
	     (cl-who:htm (:li
			  (:a :href (concatenate 'string "/" resource "/"  (cl-ppcre:scan-to-strings "[0-9]+" (cdr (assoc :url p))))
			      (cl-who:str (cdr (assoc :name p)))))))))
