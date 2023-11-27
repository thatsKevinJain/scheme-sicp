;;;;;;;;;;;;;;;;;;;;;;
;; N-Queens Problem ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Extras
(define nil ())
(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))
(define (enumerate-interval x y)
  (if (> x y)
      nil
      (cons x (enumerate-interval (+ x 1) y))))
(define (accumulate op initial sequence)
  (if (null? sequence)
    initial
    (op (car sequence) 
        (accumulate op initial (cdr sequence)))))

;; Empty Board
(define empty-board nil)

;; Add a new position to board
(define (adjoin-position row col positions)
   (append positions (list (make-position row col))))

;; Extract Row and Column from a position
(define (make-position row col)
   (cons row col))

(define (position-row position)
   (car position))

(define (position-col position)
   (cdr position))

;; Rest

(define (queens board-size)
  (define (queen-cols k)  
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row k rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))

(define (safe? col positions)
   (let ((kth-queen (list-ref positions (- col 1)))
         (other-queens (filter (lambda (q)
                                 (not (= col (position-col q))))
                               positions)))
   (define (attacks? q1 q2)
     (or (= (position-row q1) (position-row q2))
         (= (abs (- (position-row q1) (position-row q2)))
            (abs (- (position-col q1) (position-col q2))))))

   (define (iter q board)
     (or (null? board)
         (and (not (attacks? q (car board)))
              (iter q (cdr board)))))
   (iter kth-queen other-queens)))


