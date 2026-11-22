#lang racket/base

; my-length : list -> number
; Input:  lst, a proper list (no dotted pairs).
; Output: the number of top-level elements in lst.
; Recursive reading:
;   Uses a helper that carries a count in the accumulator acc.
;   Base case: when the remaining list is '(), the answer is acc.
;   Recursive step: otherwise, call the helper on the rest of the
;   list (cdr) with acc increased by 1. The recursive call is the
;   last thing done, so it is a tail call and uses constant stack.
(define (my-length lst)
  (let loop ((rest lst) (acc 0))
    (if (null? rest)
        acc
        (loop (cdr rest) (+ acc 1)))))


; my-reverse : list -> list
; Input:  lst, a proper list (no dotted pairs).
; Output: a new list with the same elements in the opposite order.
; Recursive reading:
;   Uses a helper that carries the reversed part so far in acc.
;   Base case: when the remaining list is '(), the answer is acc.
;   Recursive step: otherwise, take the first element (car) of the
;   remaining list, cons it onto acc, and recurse on the rest (cdr).
;   The recursive call is the last thing done, so it is a tail call
;   and uses constant stack.
(define (my-reverse lst)
  (let loop ((rest lst) (acc '()))
    (if (null? rest)
        acc
        (loop (cdr rest) (cons (car rest) acc)))))


; my-map : (any -> any) list -> list
; Input:  f, a function of one argument.
;         lst, a proper list (no dotted pairs).
; Output: a list of (f e) for each element e of lst, in the same order.
; Recursive reading:
;   Uses a helper that carries the results so far in acc, newest first.
;   Base case: when the remaining list is '(), the results in acc are
;   in reverse order, so return (my-reverse acc).
;   Recursive step: otherwise, apply f to the first element (car),
;   cons the result onto acc, and recurse on the rest (cdr).
;   The recursive call is the last thing done, so it is a tail call
;   and uses constant stack.
(define (my-map f lst)
  (let loop ((rest lst) (acc '()))
    (if (null? rest)
        (my-reverse acc)
        (loop (cdr rest) (cons (f (car rest)) acc)))))


; list-like? : any -> boolean
; Input:  e, any value (an atom, '(), or a non-empty list).
; Output: #t if e is the empty list '() or a pair, otherwise #f.
; Reading:
;   Not recursive. The built-in list? is not allowed, so test the two
;   shapes a list can have: the empty list (null?) or a pair (pair?).
;   Atoms such as numbers and symbols are neither, so they give #f.
(define (list-like? e)
  (or (null? e) (pair? e)))


; insert-if-short : atom list integer -> list
; Input:  x, an atom to insert.
;         lst, a possibly nested list (atoms and sublists, no dotted pairs).
;         n, an integer with n >= 0.
; Output: lst with x inserted at the front of every list, at every
;         level of nesting, whose original length is less than n.
; Recursive reading:
;   Base cases: an atom is left unchanged (it is handled inside the
;   map below, where list-like? is false). The empty list '() has no
;   elements to process, so my-map returns '(), and it gets x in front
;   only if its length 0 is less than n.
;   Recursive step: first process every element of lst: a sublist is
;   replaced by (insert-if-short x element n), and an atom stays as it
;   is. Then look at the length of the ORIGINAL lst (my-length lst).
;   If it is less than n, cons x onto the front of the processed list;
;   otherwise return the processed list as it is.
(define (insert-if-short x lst n)
  (let ((processed
         (my-map (lambda (e)
                   (if (list-like? e)
                       (insert-if-short x e n)
                       e))
                 lst)))
    (if (< (my-length lst) n)
        (cons x processed)
        processed)))

