;; Normal test for prime

(define (divides? a b)
  (= (remainder b a) 0))

(define (smallest-divisor n)
  (find-divisor n 2))

(define (next x)
  (if (= x 2)
      3
      (+ x 2)))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (next test-divisor)))))

(define (prime? n)
  (= n (smallest-divisor n)))


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
(display (search-for-primes 1000000001))


(newline)
(display (search-for-primes 10000000001))

(newline)
(display (search-for-primes 100000000001))

;;;