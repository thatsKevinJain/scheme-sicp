; ex-1.44

(define (repeated f n)
  (lambda (x)
    (define (iter i result)
      (if (= i n)
          result
          (iter (+ i 1) (f result))))
    (iter 1 (f x))))

(define (smooth f)
  (lambda (x)
    (average-of-3 (f x) (f (- x dx)) (f (+ x dx)))))

(define (average-of-3 a b c)
  (/ (+ a b c) 3))

(define (n-fold-smooth f n)
  ((repeated smooth n) f))

(define dx 0.00001)


