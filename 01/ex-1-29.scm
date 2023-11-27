;; Summation Series from `a` to `b`
;; We will use higher-order procedures
;; i.e., You can pass procedures as return value and also arguments to other procedures

;; Simpsons Method for calculating integrals

(define (sum term a next b n k)
  (if (> k n)
      0
      (+ (term a b n k)
         (sum term (next a) next b n (inc k)))))

(define (identity x) x)

(define (cube x) (* x x x))

(define (inc x) (+ x 1))

(define (calc-yk a b n k)
	(cube (+ a (* k (/ (- b a) n)))))

(define (calc-mult k n)
    (cond ((or (= k 0) (= k n)) 1)
          ((even? k) 2)
          (else 4)))

(define (term a b n k)
	(* (calc-mult k n) (calc-yk a b n k)))

(define (simp-int a b n k)
	(* (sum term a identity b n k)
		(/ (- b a) (* 3 n))))

(newline)
(display (simp-int 0 1 100 0))