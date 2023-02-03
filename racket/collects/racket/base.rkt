(module base "private/base.rkt"
  (provide (except-out
            (all-from-out "private/base.rkt")
            define-syntax)
           (rename-out
            [fuzz:define-syntax define-syntax]
            [macro-bindings fuzz:macro-bindings])
           fuzz:store-macro-binding
           fuzz:internal-store-macro-binding)
  (require "fuzz.rkt")
  (module reader syntax/module-reader
    racket/base))
