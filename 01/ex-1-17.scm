;; Iterative Multiplication - Logarithmic

(define (even? n)
  		(= (remainder n 2) 0))

(define (mult a b)
	(define (fast-mult a b prod)
		(cond ((= b 0) prod)
	 		  ((even? b) (fast-mult (+ a a) (/ b 2) prod))
	   		  (else (fast-mult a (- b 1) (+ prod a)))
	    )
	)
	(fast-mult a b 0)
)

(newline)

(display (mult 2 0))
(newline)

(display (mult 2 1))
(newline)

(display (mult 2 2))
(newline)

(display (mult 2 3))
(newline)