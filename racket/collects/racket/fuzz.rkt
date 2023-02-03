(module fuzz "private/base.rkt"
  (#%require
   (for-syntax '#%kernel  "private/stxcase-scheme.rkt" "private/qqstx.rkt" "private/stx.rkt" "private/norm-define.rkt"
               "private/qq-and-or.rkt"))
  (provide
   macro-bindings
   (for-syntax fuzz:current-macro-id)
   fuzz:define-syntax
   (rename-out [store-macro-binding fuzz:internal-store-macro-binding])
   fuzz:store-macro-binding)

  ;; maps macro names (tuple of module-name, macro-name) to id
  (define macro-bindings (make-hash))
  (define-for-syntax macro-id 0)
  (define-for-syntax (fuzz:current-macro-id) macro-id)
  (define-for-syntax (next-macro-id) (begin (set! macro-id (+ macro-id 1)) macro-id))

  (define (store-macro-binding variable-reference macro-name id)
    (hash-set! macro-bindings
                  (list (variable-reference->module-source variable-reference) macro-name)
                  id))

  (define-syntax (fuzz:store-macro-binding stx)
    (syntax-case stx ()
      [(_ macro-name)
       #`(store-macro-binding (#%variable-reference) macro-name #,(next-macro-id))]))

  (define-syntax (fuzz:define-syntax stx)
    (syntax-case stx ()
      [(_ (name args ...) body ...)
       #'(begin
           (fuzz:store-macro-binding 'name)
           (define-syntax (name args ...) body ...))]
      [(_ name body ...)
      #'(begin
           (fuzz:store-macro-binding 'name)
           (define-syntax name body ...))])))
