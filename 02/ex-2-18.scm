;; Reverse
(define nil '())

(define (reverse list)
  (define (rev-itr list rev)
    (if (null? list)
        rev
        (rev-itr (cdr list)
                 (cons (car list) rev))))
  (rev-itr list nil))

;; Test
(newline)
(display (reverse (list 1 2 3 4 5)))