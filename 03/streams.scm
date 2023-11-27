;----------------------------------;
;             STREAMS              ;
;----------------------------------;

;------------ Pre-requisites -------------;
(define nil '())
(define true '#t)
(define false '#f)


;------------ Secret-Sauce -------------;

; Memomization
; - Method to improve effiency by avoiding re-evaluation of same procedures
(define (memo-proc proc)
  (let ((already-run? false) (result false))
    (lambda ()
      (if (not already-run?)
          (begin (set! result (proc))
            	 (set! already-run? true)
              	 result)
          result))))

; Delay & Force
; - Revealing the magic :)

; (define (delay <exp>)
;   (memo-proc (lambda () <exp>)))

; (define (force delayed-proc)
;   (delayed-proc))

;------------ Contructors -------------;

(define-syntax cons-stream
  (syntax-rules ()
    ((cons-stream x y)
     (cons x (delay y)))))

(define (stream-car stream) (car stream))

(define (stream-cdr stream) (force (cdr stream)))

(define the-empty-stream '())

(define (stream-null? stream) (null? stream))

;------------ Basic Helper Functions -------------;

; Fetch the Nth-element from stream
(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

; Map
(define (stream-map proc s)
  (if (stream-null? s)
      the-empty-stream
      (cons-stream (proc (stream-car s))
                   (stream-map proc (stream-cdr s)))))

; Filter
(define (stream-filter pred s)
  (cond ((stream-null? s) the-empty-stream)
        ((pred (stream-car s))
         (cons-stream (stream-car s)
                      (stream-filter pred
                                     (stream-cdr s))))
        (else (stream-filter pred (stream-cdr s)))))

; For-each
(define (stream-for-each proc s)
  (if (stream-null? s)
      'done
      (begin (proc (stream-car s))
             (stream-for-each proc (stream-cdr s)))))

; Enumerate - Interval
(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream low
                   (stream-enumerate-interval (+ low 1) high))))

; Integers Starting from - Infinite Series
(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))

; Print
(define (display-line x)
  (display " ")
  (display x))

(define (print-stream s)
  (stream-for-each display-line s))


;------------ Implementations -------------;

; (print-stream (stream-enumerate-interval 1 500))

; (print-stream (integers-starting-from 1))

; (define (divisible? n)
;   (= (remainder n 2) 0))

; (display (stream-ref (stream-filter divisible? (integers-starting-from 1)) 100000))

(define (fibgen a b)
  (cons-stream a (fibgen b (+ a b))))

(define fibs (fibgen 0 1))

(print-stream fibs)


