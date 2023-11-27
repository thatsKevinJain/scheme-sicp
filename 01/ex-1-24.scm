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

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))

(define (prime? n)
  (fast-prime? n 500))

;;

(define (timed-prime-test n)
  (start-prime-test n (runtime)))

(define (report-prime n elapsed-time)
  (newline)
  (display n)
  (display " *** ")
  (display elapsed-time)
  1)

(define (start-prime-test n start-time)
  (cond ((prime? n) (report-prime n (- (runtime) start-time)))
  		(else 0)))

(newline)
(display (timed-prime-test 5))

;;;
(define (search-for-primes n)
  (consec-primes n 3))

(define (consec-primes n count)
  (cond ((= count 0) 0)
        ((= (timed-prime-test n) 1) (consec-primes (+ n 2) (- count 1)))
        (else (consec-primes (+ n 2) count))))
;;;
(newline)
(display (search-for-primes 10000000000001))


(newline)
(display (search-for-primes 10000000000000001))

(newline)
(display (search-for-primes 10000000000000000001))

;;;