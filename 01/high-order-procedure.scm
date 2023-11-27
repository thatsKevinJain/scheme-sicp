;; Summation Series from `a` to `b`
;; We will use higher-order procedures
;; i.e., You can pass procedures as return value and also arguments to other procedures

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

(define (cube x) (* x x x))

(define (inc x) (+ x 1))

(define (sum-cubes a b)
  (sum cube a inc b))

(newline)
(display (sum-cubes 1 10))