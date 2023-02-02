(module fuzz "private/base.rkt"
  (#%require
   (for-syntax '#%kernel  "private/stxcase-scheme.rkt" "private/qqstx.rkt" "private/stx.rkt" "private/norm-define.rkt"
               "private/qq-and-or.rkt"))
  (provide
   macro-bindings
   fuzz:current-macro-id
   fuzz:define-syntax)
  ;; maps macro names (tuple of module-name, macro-name) to id
  (define macro-bindings (make-hash))
  (define macro-id 0)
  (define (fuzz:current-macro-id) macro-id)
  (define (next-macro-id) (begin (set! macro-id (+ macro-id 1)) macro-id))

  (define (store-macro-binding variable-reference macro-name)
    (hash-update! macro-bindings
                  (list (variable-reference->module-source variable-reference) macro-name)
                  (lambda (id) (if (not id)
                                   (next-macro-id)
                                   id))
                  #f))
  (define-syntax (fuzz:define-syntax stx)
    (syntax-case stx ()
      [(_ (name args ...) body ...)
       #'(begin
           (store-macro-binding (#%variable-reference) 'name)
           (define-syntax (name args ...) body ...)
           )]
      [(_ name body ...)
      #'(begin
           (store-macro-binding (#%variable-reference) 'name)
           (define-syntax name body ...))])))
