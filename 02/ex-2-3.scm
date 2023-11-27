; Ex 2.3

(load "./ex-2-2.scm")
(load "../01/ex-1-7.scm")

;; Length of segment

(define (segment-length segment)
  (sqrt (+ (square (- (x-point (end-segment segment))
                      (x-point (start-segment segment))))
           (square (- (y-point (end-segment segment))
                      (y-point (start-segment segment)))))))

;; Perimeter

(define (perimeter seg-1 seg-2)
  (* 2 (+ (segment-length seg-1) (segment-length seg-2))))


;; Area
(define (area seg-1 seg-2)
  (* (segment-length seg-1) (segment-length seg-2)))

;; Test

(display (perimeter (make-segment (make-point 5 10)
		                          (make-point 10 10))
                    (make-segment (make-point 10 10)
		                          (make-point 10 20))))

(newline)

(display (area (make-segment (make-point 5 10)
	                          (make-point 10 10))
	            (make-segment (make-point 10 10)
	                          (make-point 10 20))))