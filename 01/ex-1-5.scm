(define (p) (p))

(define (test x y)
  (if (= x 0)
      0
      y))

; Using applicative-order evaluation, the evaluation of (test 0 (p)) never terminates, because (p) is infinitely expanded to itself:

;  (test 0 (p)) 
  
;  (test 0 (p)) 
  
;  (test 0 (p)) 

; ... and so on.

; Using normal-order evaluation, the expression evaluates, step by step, to 0:

;  (test 0 (p)) 
  
;  (if (= 0 0) 0 (p)) 
  
;  (if #t 0 (p)) 
  
;  0 