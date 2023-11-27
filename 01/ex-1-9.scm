; Process 1
(define (+ a b)
  (if (= a 0)
      b
      (inc (+ (dec a) b))))

(+ 4 5)
(inc (+ (dec 4) 5))
(inc (+ 3 5))
(inc ((inc (+ (dec 3) 5))))
(inc ((inc (+ 2 5))))
(inc ((inc ((inc (+ (dec 2) 5))))))
(inc ((inc ((inc (+ 1 5))))))
(inc ((inc ((inc ((inc (+ (dec 1) 5))))))))
(inc ((inc ((inc ((inc (+ 0 5))))))))
(inc ((inc ((inc ((inc 5)))))))
(inc ((inc ((inc (6))))))
(inc ((inc (7))))
(inc (8))
9

; Process 2
(define (+ a b)
  (if (= a 0)
      b
      (+ (dec a) (inc b))))

(+ 4 5)
(+ (dec 4) (inc 5))
(+ 3 6)
(+ (dec 3) (inc 6))
(+ 2 7)
....
...
9

; Process 1 is recursive & Process 2 is iterative
; The easiest way to spot that the first process is recursive (without writing out the substitution) 
; is to note that the "+" procedure calls itself at the end while nested in another expression; 
; the second calls itself, but as the top expression.