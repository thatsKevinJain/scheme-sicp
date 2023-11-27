;; Iterative Exponentiation Fast - Exp

(define (even? n)
  		(= (remainder n 2) 0))

(define (exp b n)
	(define (fast-exp b n a)
		(cond ((= n 0) a)
	 		  ((even? n) (fast-exp (* b b) (/ n 2) a))
	   		  (else (fast-exp b (- n 1) (* a b)))
	    )
	)
	(fast-exp b n 1)
)

(newline)

(display (exp 2 0))
(newline)

(display (exp 2 1))
(newline)

(display (exp 2 2))
(newline)

(display (exp 2 3))
(newline)