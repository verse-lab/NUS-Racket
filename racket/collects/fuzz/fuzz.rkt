#lang racket/base

(require (for-syntax racket/base))

(define-syntax (lookup-macro-definition stx)
  (syntax-case stx ()
    ((_ id)
     #`(displayln (format "hello ~s" #,(syntax->datum #'id)))
     )
    )
  )
