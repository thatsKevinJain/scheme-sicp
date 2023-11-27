;; Unordered Sets

(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

(define (union s1 s2)
  (cond ((null? s1) s2)
        ((null? s2) s1)
        ((element-of-set? (car s1) s2)
         (union (cdr s1) s2))
        (else (cons (car s1)
                    (union (cdr s1) s2)))))

(newline)
(display (union (list 1 2 3 8 9) (list 3 4 5 8 9 1)))