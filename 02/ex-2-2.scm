; Ex 2.2

;; Average

(define (average x y)
  (/ (+ x y) 2))

;; Single Point

(define (make-point x y) (cons x y))

(define (x-point point) (car point))

(define (y-point point) (cdr point))


;; Segment (Comprises of two points)

(define (make-segment start end) (cons start end))

(define (start-segment segment) (car segment))

(define (end-segment segment) (cdr segment))


;; Midpoint
(define (midpoint segment)
  (make-point (average (x-point (start-segment segment))
                       (x-point (end-segment segment)))
              (average (y-point (start-segment segment))
                       (y-point (end-segment segment)))))

;; Print
(define (print-point point)
  (newline)
  (display "(")
  (display (x-point point))
  (display ",")
  (display (y-point point))
  (display ")"))

;; Test

; (define segment (make-segment (make-point 1 10) (make-point 5 20)))
; (print-point (midpoint segment))