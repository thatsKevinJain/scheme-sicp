;; Last Pair

(define (last-pair list)
  (if (null? (cdr list))
      (car list)
      (last-pair (cdr list))))

;; Test
(newline)
(display (last-pair (list 1 2 3 4 5 6)))