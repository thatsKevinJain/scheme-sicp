;; Accumulate - n

(define nil '())

(define sets (list (list 1 2 3) (list 4 5 6) (list 7 8 9)))
; (newline)
; (display sets)

(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence) 
        (accumulate op initial (cdr sequence)))))

; (newline)
; (display (accumulate + 0 (list 1 2 3)))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs)))))

; (newline)
; (display (accumulate-n + 0 (list (list 1 2 3) (list 1 2 3))))