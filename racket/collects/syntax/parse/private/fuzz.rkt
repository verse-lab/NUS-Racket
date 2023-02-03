#lang racket/base

(require (for-syntax racket/base))
(provide fuzz:save-syntax-object macro-definitions)

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

(define (fuzz:save-syntax-object variable-reference stx-datum id)
  (hash-update! macro-definitions id
                (lambda (data) (cons (list variable-reference stx-datum) data)) '()))
