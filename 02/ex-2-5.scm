; Ex 2.5

(define (cons a b)
  (* (expt 2 a) (expt 3 b)))

(define (car z)
  (define (car-iter z n)
    (if (> (remainder z 2) 0)
        n
        (car-iter (/ z 2) (+ n 1))))
  (car-iter z 0))

(define (cdr z)
  (define (cdr-iter z n)
    (if (> (remainder z 3) 0)
        n
        (cdr-iter (/ z 3) (+ n 1))))
  (cdr-iter z 0))