; Newton's Method of finding Cube Root

(define (abs x)
  (if (>= x 0)
      x
      (- 0 x)))

(define (sqaure x)
  (* x x))

(define (good-enough? old-guess guess)
  (< (abs (- old-guess guess)) 0.001))

(define (average x y)
  (/ (+ (/ x (square y)) 
        (* 2 y)) 
     3))

(define (improve guess x)
  (average x guess))

(define (cube-root-iter guess x) 
  (if (good-enough? guess (improve guess x))
      guess
      (cube-root-iter (improve guess x)
                 x)))

(define (cube-root x)
  (cube-root-iter 1.0 x))