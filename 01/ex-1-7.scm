;; Newton's Method of finding Sqaure Root

; (define (abs x)
;   (if (>= x 0)
;       x
;       (- 0 x)))

; (define (sqaure x)
;   (* x x))

; (define (good-enough? guess x)
;   (< (abs (- (sqaure guess) x)) 0.001))

; (define (average x y)
;   (/ (+ x y) 2))

; (define (improve guess x)
;   (average guess (/ x guess)))

; (define (sqrt-iter guess x) 
;   (if (good-enough? guess x)
;       guess
;       (sqrt-iter (improve guess x)
;                  x)))

; (define (sqrt x)
;   (sqrt-iter 1.0 x))

;; Newton's Method of finding Sqaure Root (With the Adjusted Method)

; (define (abs x)
;   (if (>= x 0)
;       x
;       (- 0 x)))

; (define (sqaure x)
;   (* x x))

; (define (good-enough? old-guess guess)
;   (< (abs (- old-guess guess)) 0.001))

; (define (average x y)
;   (/ (+ x y) 2))

; (define (improve guess x)
;   (average guess (/ x guess)))

; (define (sqrt-iter guess x) 
;   (if (good-enough? guess (improve guess x))
;       guess
;       (sqrt-iter (improve guess x)
;                  x)))

; (define (sqrt x)
;   (sqrt-iter 1.0 x))

;; Newton's Method of finding Sqaure Root (With the Adjusted Method) (With Nested Definitions)

(define (sqrt x)
  (define (abs x)
    (if (>= x 0)
        x
        (- 0 x)))
  (define (good-enough? old-guess guess)
    (< (abs (- old-guess guess)) 0.001))
  (define (average x y)
    (/ (+ x y) 2))
  (define (improve guess)
    (average guess (/ x guess)))
  (define (sqrt-iter guess) 
    (if (good-enough? guess (improve guess))
        guess
        (sqrt-iter (improve guess))))
  (sqrt-iter 1.0))