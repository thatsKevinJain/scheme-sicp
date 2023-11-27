;; Normal test for prime

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m))
                    m))
        (else
         (remainder (* base (expmod base (- exp 1) m))
                    m))))

; based on this Fermat test is

(define (fermat-test n a)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it a))

(define (fast-prime? n a)
  (cond ((= a n) true)
        ((fermat-test n a)
           (fast-prime? n (+ a 1)))
        (else 
          (display a)
          (newline)
          false)))

(define (prime? n)
  (fast-prime? n 2))

;;;
(newline)
(display (prime? 561))


(newline)
(display (prime? 1105))

(newline)
(display (prime? 1729))

(newline)
(display (prime? 2465))

(newline)
(display (prime? 2821))

(newline)
(display (prime? 6601))

(newline)
(display (prime? 6600))

;;;