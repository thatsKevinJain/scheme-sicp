;; Ex 2.37

(load "./ex-2-36.scm")

;; Matrix Calculations

(define matrix (list (list 1 2 3 4)
                     (list 4 5 6 6)
                     (list 6 7 8 9)))

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

;; Test
; (newline)
; (display (dot-product (list 1 2 3) (list 1 2 3)))

(define (matrix-*-vector m v)
  (map (lambda (x) (dot-product x v)) m))

; (display (matrix-*-vector matrix (list 1 2 3 4)))

(define (transpose m)
  (accumulate-n cons nil m))

; (display (transpose matrix))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (x)
           (map (lambda (y)
                (dot-product x y))
           cols))
         m)))

(display (matrix-*-matrix matrix (transpose matrix)))