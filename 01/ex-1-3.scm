(define (sum-of-squares x y) (+ (* x x) (* y y)))

(define (larger-numbers a b c) 
  (cond ((and (>= a c) (>= b c)) (sum-of-squares a b))
        ((and (>= b a) (>= c a)) (sum-of-squares b c))
        ((and (>= c b) (>= a b)) (sum-of-squares a c))))
