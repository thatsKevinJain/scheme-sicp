;; Ex 2.54

; (define (equal? a b)
;   (cond (and
;           (null? a)
;           (null? b)
;           true)
;         ((eq? (car a) (car b))
;          (equal? (cdr a) (cdr b)))
;         (else false)))

  
 (define (equal? a b)
   (or
    (eq? a b)
     (and
	     (pair? a)
	     (pair? b)
	     (equal? (car a) (car b))
	     (equal? (cdr a) (cdr b))
     )
   )
)

 
(newline)
(display (equal? (list '(hello world)) (list '(hello world))))