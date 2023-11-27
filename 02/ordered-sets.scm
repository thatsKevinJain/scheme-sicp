;; Ordered Sets

(define (adjoin-set x set)
  (cond ((null? set) (cons x ()))
        ((= x (car set)) set)
        ((< x (car set)
            (cons x set)))
        (else (cons (car set)
                    (adjoin-set x (cdr set))))))

(newline)
(display (adjoin-set 0 (list 1 2 4 5 10 11)))


(newline)
(display (adjoin-set 3 (list 1 2 4 5 10 11)))


(newline)
(display (adjoin-set 6 (list 1 2 4 5 10 11)))


(newline)
(display (adjoin-set 15 (list 1 2 4 5 10 11)))