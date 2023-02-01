#lang racket/base

(require (for-syntax racket/base))
(provide save-syntax-object macro-definitions)

(define macro-definitions (make-hash))

(define (variable-reference->module-name variable-reference)
  (define module-source (variable-reference->module-source variable-reference))
  (define module-name
    (cond
      [(symbol? module-source)
       module-source]
      [(path? module-source)
       (let-values ([(_base name _) (split-path module-source)])
         (path-replace-extension name ""))]))
  (format "macro-fuzz-~a" module-name))

(define (save-syntax-object variable-reference stx-datum)
  (hash-update! macro-definitions (variable-reference->module-name variable-reference)
                (lambda (data) (cons stx-datum data)) '()))

(define-syntax (save-at-toplevel stx)
  (syntax-local-lift-expression
   #`(save-syntax-object (#%variable-reference) '#,(syntax->datum stx)))
  #'(void))
