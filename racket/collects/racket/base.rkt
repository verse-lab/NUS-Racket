(module base "private/base.rkt"
  (provide (except-out
            (all-from-out "private/base.rkt")
            define-syntax)
           (rename-out
            [fuzz:define-syntax define-syntax])
           fuzz:current-macro-id)
  (require "fuzz.rkt")
  (module reader syntax/module-reader
    racket/base))
