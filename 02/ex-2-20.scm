;; Same Parity


(define (same-parity x . w)	
	(define (sp-itr list res parity)
	    (if (null? list)
	        res
	        (sp-itr (cdr list)
                (if (= (remainder (car list) 2) parity)
	                (cons res (car list))
		            res)
                parity)))
	(sp-itr w (list x) (remainder x 2)))

;; Test

(display (same-parity 1 2 3 4 5 8 10 11 12 19 31))