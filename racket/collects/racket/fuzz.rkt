(module fuzz "private/base.rkt"
  (#%require
   (for-syntax '#%kernel  "private/stxcase-scheme.rkt" "private/qqstx.rkt" "private/stx.rkt" "private/norm-define.rkt"
               "private/qq-and-or.rkt"))
  (provide
   macro-bindings
   fuzz:define-syntax
   (rename-out [store-macro-binding fuzz:internal-store-macro-binding])
   fuzz:store-macro-binding)

  ;; maps macro names (tuple of module-name, macro-name) to the syntax data
  (define macro-bindings (make-hash))

  (define (store-macro-binding variable-reference macro-name data)
    (hash-set! macro-bindings
                  (list (variable-reference->module-source variable-reference) macro-name)
                  data))

  (define-syntax (fuzz:store-macro-binding stx)
    (syntax-case stx ()
      [(_ macro-name macro-syntax)
       #`(store-macro-binding (#%variable-reference) macro-name macro-syntax)]))

  (define-syntax (fuzz:define-syntax stx)
    (syntax-case stx ()
      [(_ (name args ...) body ...)
       #`(begin
           (fuzz:store-macro-binding 'name '#,(syntax->datum stx))
           (define-syntax (name args ...) body ...))]
      [(_ name body ...)
      #`(begin
           (fuzz:store-macro-binding 'name '#,(syntax->datum stx))
           (define-syntax name body ...))])))
