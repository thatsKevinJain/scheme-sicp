;; Cesaro Test for estimating PI

(define (estimate-pi trials)
  (sqrt (/ 6 (monte-carlo trials cesaro))))

(define (cesaro)
  (= (gcd (rand) (rand)) 1))

(define (monte-carlo trials experiment)
  (define (iter remaining passed)
    (cond ((= remaining 0) (/ passed trials))
          ((experiment)
           (iter (- remaining 1) (+ passed 1)))
          (else
            (iter (- remaining 1) passed))))
  (iter trials 0))

; (define rand
;   (let ((x random-init))
;     (lambda ()
;       (set! x (random-update x))
;       x)))

; (define random-init)

; (define (random-update x))

(define rand
  (lambda () (random 10000000)))

(newline)
(display (estimate-pi 1000000))