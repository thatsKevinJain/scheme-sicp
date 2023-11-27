;; Unique Pairs

(define nil ())
(load "./ex-2-36.scm")
(load "./extras.scm")


(define (enumerate-interval x y)
  (if (> x y)
      nil
      (cons x (enumerate-interval (+ x 1) y))))


(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

(define (unique-pairs n)
 (flatmap (lambda (i)
          (map (lambda (j) (list i j))
                 (enumerate-interval 1 (- i 1))))
        (enumerate-interval 1 n)))

(define (prime-sum-pairs n)
  (map make-pair-sum
         (filter prime-sum? (unique-pairs n))))

(newline)
(display (prime-sum-pairs 10))