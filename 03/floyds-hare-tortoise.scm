;; Flyod's Hare & Tortoise Algorithm

;; SENPAI taught us this => https://www.youtube.com/watch?v=pKO9UjSeLew

;; Helpers
(define (append! x y)
  (set-cdr! (last-pair x) y)
  x)
; getting the last pair of the list
(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define (circular? x)
  (define (iter tortoise hare)
    (cond ((or (null? (cdr tortoise))
               (or (null? (cdr hare))
                   (null? (cddr hare))))
           #f)
          ((eq? tortoise hare) #t)
          (else
            (iter (cdr tortoise) (cddr hare)))))
  (iter x (cdr x)))


(newline)
(display (circular? (list 1 2 3)))

(newline)
(define first (cons 1 2))
(define second (cons 1 2))
(define third (cons 1 2))
(define forth (cons 1 2))
(define fifth (cons 1 2))

(set-cdr! first second)
(set-cdr! second third)
(set-cdr! third forth)
(set-cdr! forth fifth)
(set-cdr! fifth second)

(display (circular? first))