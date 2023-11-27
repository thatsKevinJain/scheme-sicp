;; Deep Reverse

(load "./ex-2-18.scm")

(define (deep-reverse list)
  (define (rev-itr list rev)
    (cond ((null? list) rev)
          ((not (pair? list)) (car list))
          (else (rev-itr (cdr list)
                 		 (cons (reverse (car list)) rev)))))
  (rev-itr list nil))

;; Test

(newline)
(display (reverse (list (list 1 2) (list 3 4))))

(newline)
(display (deep-reverse (list (list 1 2) (list (list 3) (list 4)) (list 5))))