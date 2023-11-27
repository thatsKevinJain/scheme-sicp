;; Multi Dimensional Tables

(define (make-table)

  (define (assoc key records)
    (cond ((null? records) '#f)
          ((equal? key (caar records)) (car records))
          (else (assoc key (cdr records)))))


  (let ((local-table (list '*table*)))

    (define (lookup keys) 
      (define (lookup-recursive keys table)
        (let ((record (assoc (car keys) (cdr table))))
          (if record
            (if (null? (cdr keys)) ;; to check if we have reached the last key
              (cdr record)
              (if (pair? (cdr record))
                (lookup-recursive (cdr keys) record)
                '#f))
            '#f)))
      (lookup-recursive keys local-table))

    (define (insert! keys value)
      (define (insert-recursive! keys table)
        (let ((record (assoc (car keys) (cdr table))))
          (if record
            (if (null? (cdr keys))
              (set-cdr! record value)
              (if (pair? (cdr record))
                (insert-recursive! (cdr keys) record)
                ; this can be abstracted in recursive make
                (begin
                  (set-cdr! record
                            (cons (cons (cadr keys) '()) '()))
                  (insert-recursive! (cdr keys) record))))
            ; no record found
            (if (null? (cdr keys))
              (set-cdr! table
                        (cons (cons (car keys) value) (cdr table)))
              ; this can be abstracted in a recursive make
              (begin 
                (set-cdr! table
                          (cons (cons (car keys) '()) (cdr table)))
                (insert-recursive! keys table))))))
      (insert-recursive! keys local-table))

    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation -- TABLE" m))))

    dispatch))