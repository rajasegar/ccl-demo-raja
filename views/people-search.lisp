(in-package :ccl-demo-raja)

;; Search page - people
(hunchentoot:define-easy-handler (search-people :uri "/people/search") (search)
  (setq *search-results* (cl-json:decode-json-from-string
			  (drakma:http-request (concatenate 'string "https://swapi.dev/api/people/?search=" search)
					       :method :get)))
  (format t "~a~%" *search-results*)
  (cl-who:with-html-output-to-string (output nil :prologue nil)
    (loop for p in (rest (assoc :results *search-results*))
	  do
	     ;; (format t "~a~%" (cl-ppcre:scan-to-strings "[0-9]+" (cdr (assoc :url p))))
	     (cl-who:htm (:li
			  (:a :href (concatenate 'string "/people/show?id="  (cl-ppcre:scan-to-strings "[0-9]+" (cdr (assoc :url p))))
			      (cl-who:str (cdr (assoc :name p)))))))))
