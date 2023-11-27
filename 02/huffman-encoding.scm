;; Huffman Encoding

(define (make-leaf symbol weight)
  (list 'leaf symbol weight))

(define (leaf? object)
  (eq? (car object) 'leaf))

(define (symbol-leaf object)
  (cadr object))

(define (weight-leaf object)
  (caddr object))

; General tree node will be a set of left and right branches, list of
; symbols and combined weight of all the symbols

(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right))
        (+ (weight left) (weight right))))

; and some selectors on the tree

(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))

(define (symbols tree)
  (if (leaf? tree)
    (list (symbol-leaf tree))
    (caddr tree)))

(define (weight tree)
  (if (leaf? tree)
    (weight-leaf tree)
    (cadddr tree)))

;;;

(define (decode bits tree)
  (define (decode-inner bits current-branch)
    (if (null? bits)
      '()
      (let ((next-branch (choose-branch (car bits) current-branch)))
        (if (leaf? next-branch)
          (cons (symbol-leaf next-branch)
                (decode-inner (cdr bits) tree))
          (decode-inner (cdr bits) next-branch)))))
  (decode-inner bits tree))

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
        (else (error "Something is wrong in your bits -- CHOOSE BRANCH"))))


; Similar to Exercise 2.61 we can make ordered set of symbols by their
; weights, since we'll have to compare them a lot during merging

(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) (cons x set))
        (else (cons (car set)
                    (adjoin-set x (cdr set))))))

; The following procedure takes a list of symbol-frequency pairs such as
; ((A 4) (B 2) (C 1) (D 1)) and constructs an initial ordered set of
; leaves, ready to be merged according to the Huffman algorithm:

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-set (make-leaf (car pair)    ; symbol
                               (cadr pair))  ; frequency
                    (make-leaf-set (cdr pairs))))))

;; Ex 2.67
(define sample-tree
  (make-code-tree (make-leaf 'A 4)
                  (make-code-tree
                   (make-leaf 'B 2)
                   (make-code-tree (make-leaf 'D 1)
                                   (make-leaf 'C 1)))))

(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

; (display (decode sample-message sample-tree))

;; Ex 2.68
(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))


(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree))))

; required procedure to make a solution
(define (encode-symbol symbol tree)
  (if (leaf? tree)
    '()
    (cond ((element-of-set? symbol (symbols (right-branch tree)))
           (cons 1 (encode-symbol symbol (right-branch tree))))
          (else (cons 0 (encode-symbol symbol (left-branch tree)))))))

; (define sample-message '(A D A B B C A))

; (display (encode sample-message sample-tree))

;; 2.69

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define (successive-merge set)
  (cond ((null? set) '())
        ((null? (cdr set)) (car set))
        (else (successive-merge
               (adjoin-set (make-code-tree (car set) (cadr set))
                           (cddr set))))))

; (display (generate-huffman-tree '((A 4) (B 2) (C 1) (D 1))))


(define text
  (list
    '(Get a job)
    '(Sha na na na na na na na na)
    '(Get a job)
    '(Sha na na na na na na na na)
    '(Wah yip yip yip yip yip yip yip yip yip)
    '(Sha boom)))

(define symbol-list
  (list (list 'a 2)
        (list 'na 16)
        (list 'boom 1)
        (list 'Sha 3)
        (list 'Get 2)
        (list 'yip 9)
        (list 'job 2)
        (list 'Wah 1)))

(define h-tree (generate-huffman-tree symbol-list))

(define (encode-symbol-list symbols tree)
  (if (null? symbols)
    '()
    (append (encode (car symbols) tree)
            (encode-symbol-list (cdr symbols) tree))))

(define res (encode-symbol-list symbol-list h-tree))

(newline)
(display res)

(newline)
(display (length res))

(newline)
(display h-tree)























