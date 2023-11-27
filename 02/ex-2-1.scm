; Ex 2.1

(define (make-rat n d)
  (cond ((< d 0) (cons (- n) (- d)))
        (else (cons n d))))

(define (print-rat rat)
  (newline)
  (display (num rat))
  (display "/")
  (display (deno rat)))


(define (num rat) (car rat))

(define (deno rat) (cdr rat))

(print-rat (make-rat 1 10))
(print-rat (make-rat -1 10))
(print-rat (make-rat 1 -10))
(print-rat (make-rat -1 -10))