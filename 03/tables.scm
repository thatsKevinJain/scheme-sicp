;; Implementation of TABLES in Scheme

(define false #f)

(define (lookup key table)
  (let ((record (assoc key (cdr table))))
    (if record
        (cdr record)
        false)))
(define (assoc key records)
  (cond ((null? records) false)
        ((equal? key (caar records)) (car records))
        (else (assoc key (cdr records)))))

(define (insert! key value table)
  (let ((record (assoc key (cdr table))))
    (if record
        (set-cdr! record value)
        (set-cdr! table
                  (cons (cons key value) (cdr table)))))
  'ok)

(define (make-table)
  (list '*table*))

(newline)
(define a (make-table))

(newline)
(display a)

(newline)
(insert! 'fname 'kevin a)
(insert! 'lname 'jain a)
(insert! 'age 23 a)
(display a)

(newline)
(display (lookup 'fname a))

(newline)
(display (lookup 'desg a))
(newline)