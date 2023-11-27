;-------------------------------------------------;
;             METACIRCULAR EVALUATOR              ;
;-------------------------------------------------;

; Pre-requisites
(define nil '())
(define true '#t)
(define false '#f)

(define (error val env)
  (newline)
  (display val)
  (display " ---> ")
  (display env)
  (newline))

(define apply-in-underlying-scheme apply)

(define (true? x)
  (not (eq? x false)))
(define (false? x)
  (eq? x false))

; ------------------------------------------------;
;                      EVAL                       ;
; ------------------------------------------------;

(define (meta-eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
        ((let? exp) (eval-let exp env))
        ((begin? exp)
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (meta-eval (cond->if exp) env))
        ((application? exp)
         (meta-apply (actual-value (operator exp) env) ;changed
                     (operands exp)
                     env))
        (else
          (error "Unknown expression type -- EVAL" exp))))

; ------------------------------------------------;
;                      APPLY                      ;
; ------------------------------------------------;
(define (meta-apply procedure arguments env)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure
          procedure
          (list-of-arg-values arguments env)))  ; changed
        ((compound-procedure? procedure)
         (eval-sequence
          (procedure-body procedure)
          (extend-environment
           (procedure-parameters procedure)
           (list-of-delayed-args arguments env) ; changed
           (procedure-environment procedure))))
        (else
         (error
          "Unknown procedure type -- APPLY" procedure))))

; ------------------------------------------------;
;                   PRIMITIVES                    ;
; ------------------------------------------------;

(define (list-of-values operands env)
  (if (no-operands? operands)
      '()
      (cons (meta-eval (first-operand operands) env)
            (list-of-values (rest-operands operands) env))))

(define (eval-if exp env)
  (if (true? (actual-value (if-predicate exp) env)) ;changed
      (meta-eval (if-consequent exp) env)
      (meta-eval (if-alternative exp) env)))

(define (eval-sequence exps env)
  (cond ((last-exp? exps) (meta-eval (first-exp exps) env))
        (else (meta-eval (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))

(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
                       (meta-eval (assignment-value exp) env)
                       env)
  'ok)

(define (eval-definition exp env)
  (define-variable! (definition-variable exp)
                    (meta-eval (definition-value exp) env)
                    env)
  'ok)

; new

(define (actual-value exp env)
  (force-it (meta-eval exp env)))

(define (list-of-arg-values exps env)
  (if (no-operands? exps)
      '()
      (cons (actual-value (first-operand exps) env)
            (list-of-arg-values (rest-operands exps)
                                env))))
(define (list-of-delayed-args exps env)
  (if (no-operands? exps)
      '()
      (cons (delay-it (first-operand exps) env)
            (list-of-delayed-args (rest-operands exps)
                                  env))))

; ------------------------------------------------;
;              REPRESENTING EXPRESSIONS           ;
; ------------------------------------------------;
(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

; ------------------------------------------------;
(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        (else false)))

; ------------------------------------------------;
(define (variable? exp) (symbol? exp))

; ------------------------------------------------;
(define (quoted? exp) (tagged-list? exp 'quote))

(define (text-of-quotation exp) (cadr exp))

; ------------------------------------------------;
(define (assignment? exp)
  (tagged-list? exp 'set!))

(define (assignment-variable exp) (cadr exp))

(define (assignment-value exp) (caddr exp))

; ------------------------------------------------;
(define (definition? exp)
  (tagged-list? exp 'define))

(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))

(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp)		; formal params
                   (cddr exp))))	; body

; ------------------------------------------------;
(define (lambda? exp)
  (tagged-list? exp 'lambda))

(define (lambda-parameters exp) (cadr exp))

(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

; ------------------------------------------------;
(define (if? exp)
  (tagged-list? exp 'if))

(define (if-predicate exp) (cadr exp))

(define (if-consequent exp) (caddr exp))

(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

; ------------------------------------------------;
(define (begin? exp)
  (tagged-list? exp 'begin))

(define (begin-actions exp) (cdr exp))

(define (last-exp? seq) (null? (cdr seq)))

(define (first-exp seq) (car seq))

(define (rest-exps seq) (cdr seq))

(define (make-begin seq)
  (cons 'begin seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))

; ------------------------------------------------;
(define (application? exp) (pair? exp))

(define (operator exp) (car exp))

(define (operands exp) (cdr exp))
      
(define (no-operands? ops) (null? ops))
                            
(define (first-operand ops) (car ops))

(define (rest-operands ops) (cdr ops))

; ------------------------------------------------;
(define (eval-let exp env)
  (meta-eval (let->combination exp) env))

(define (let->combination exp)
  (make-application ((make-lambda (let-variables exp)
                      			  (let-body exp))
                     let-exps)))

(define (let? exp) (tagged-list? exp 'let))

(define (let-variables exp)
  (define (iter-variables variables)
    (if ((null? variables) '())
        (cons (caar variables)
              (iter-variables (cdr variables)))))
  (iter-variables (cadr exp)))

(define (let-exps exp)
  (define (iter-exps exps)
    (if ((null? exps) '())
        (cons (cadar exps)
              (iter-exps (cdr exps)))))
  (iter-exps (cadr exp)))

(define (let-body exp) (cddr exp))

; ------------------------------------------------;
;              THUNKS                             ;
; ------------------------------------------------;
(define (delay-it exp env)
  (list 'thunk exp env))

(define (thunk? obj)
  (tagged-list? obj 'thunk))

(define (thunk-exp thunk) (cadr thunk))

(define (thunk-env thunk) (caddr thunk))

(define (evaluated-thunk? obj)
  (tagged-list? obj 'evaluated-thunk))

(define (thunk-value evaluated-thunk) (cadr evaluated-thunk))

(define (force-it obj)
  (cond ((thunk? obj)
         (let ((result (actual-value
                        (thunk-exp obj)
                        (thunk-env obj))))
           (set-car! obj 'evaluated-thunk)
           (set-car! (cdr obj) result)  ; replace exp with its value
           (set-cdr! (cdr obj) '())     ; forget unneeded env
           result))
        ((evaluated-thunk? obj)
         (thunk-value obj))
        (else obj)))


; ------------------------------------------------;
;              DERIVED EXPRESSIONS                ;
; ------------------------------------------------;
(define (cond? exp) (tagged-list? exp 'cond))

(define (cond-clauses exp) (cdr exp))

(define (cond-predicate clause) (car clause))

(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))

(define (cond-actions clause) (cdr clause))
; (define (cond-actions clause)
;   (if (eq? (cdr clause) '=>)
;       ((caddr clause) (car clause))
;       (cdr clause)))

(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))

(define (expand-clauses clauses)
  (if (null? clauses)
      'false
      (let ((first (car clauses))
            (rest (cdr clauses)))
        (if (cond-else-clause? first)
            (if (null? rest)
                (sequence->exp (cond-actions first))
                (error "ELSE clause isn't last -- COND->IF" clauses))
            (make-if (cond-predicate first)
                     (sequence->exp (cond-actions first))
                     (expand-clauses rest))))))

; ------------------------------------------------;
;                   STREAMS                       ;
; ------------------------------------------------;

; (define (list-ref items n)
;   (if (= n 0)
;       (car items)
;       (list-ref (cdr items) (- n 1))))

; (define (map proc items)
;   (if (null? items)
;       '()
;       (cons (proc (car items))
;             (map proc (cdr items)))))

; (define (scale-list items factor)
;   (map (lambda (x) (* x factor))
;        items))

; (define (add-lists list1 list2)
;   (cond ((null? list1) list2)
;         ((null? list2) list1)
;         (else (cons (+ (car list1) (car list2))
;                     (add-lists (cdr list1) (cdr list2))))))

; (define ones (cons 1 ones))

; (define integers (cons 1 (add-lists ones integers)))

; ------------------------------------------------;
;                   ENVIORNMENT                   ;
; ------------------------------------------------;
(define (make-procedure parameters body env)
  (list 'procedure parameters body env))

(define (compound-procedure? p)
  (tagged-list? p 'procedure))

(define (procedure-parameters p) (cadr p))

(define (procedure-body p) (caddr p))

(define (procedure-environment p) (cadddr p))

(define (enclosing-environment env) (cdr env))

(define (first-frame env) (car env))

(define the-empty-environment '())

(define (make-frame variables values)
  (cons variables values))

(define (frame-variables frame) (car frame))

(define (frame-values frame) (cdr frame))

(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
          (error "Too many arguments supplied" vars vals)
          (error "Too few arguments supplied" vars vals))))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (car vals))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable -- SET!" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
             (add-binding-to-frame! var val frame))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame)
          (frame-values frame))))

; ------------------------------------------------;
;               SETUP ENVIORNMENT                 ;
; ------------------------------------------------;
(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))

(define (primitive-implementation proc) (cadr proc))

(define primitive-procedures
  (list (list 'null? null?)
        (list '> >)
        (list '+ +)
        (list '= =)
        (list '/ /)
        (list 'display display)))

(define (primitive-procedure-names)
  (map car
       primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
   (primitive-implementation proc) args))

(define (setup-environment)
  (let ((initial-env
         (extend-environment (primitive-procedure-names)
                             (primitive-procedure-objects)
                             the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))

(define input-prompt ";;; Lazy-Eval input:")
(define output-prompt ";;; Lazy-Eval value:")

(define (cons x y)
  (lambda (m) (m x y)))

(define (car z)
  (z (lambda (p q) p)))

(define (cdr z)
  (z (lambda (p q) q)))

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (actual-value input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))
    
      ;     (newline)
      ; (user-print the-global-environment)))

(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))

(define (announce-output string)
  (newline) (display string) (newline))

(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compound-procedure
                     (procedure-parameters object)
                     (procedure-body object)
                     '<procedure-env>))
      (display object)))

(define the-global-environment (setup-environment))
(driver-loop)

;--------------------------------------------------;





