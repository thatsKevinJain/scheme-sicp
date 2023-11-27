;;; Recursive 
(define (f n)
	(cond ((< n 3) n) 
		 (else (+ (f (- n 1)) 
				  (* 2 (f (- n 2))) 
				  (* 3 (f (- n 3))))))) 

;;; Iterative 

(define (f n)
	(define (f-i a b c count)
	 (cond ((< n 3) n)
		   ((<= count 0) a)
		   (else (f-i (+ a (* 2 b) (* 3 c)) a b (- count 1)))))
	(f-i 2 1 0 (- n 2)))

; Think of the above solution by finding a 3x3 matrix