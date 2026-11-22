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



; make-inserter : atom (number -> boolean) -> (list -> list)
; Input:  x, an atom to insert.
;         len-ok?, a function taking one number and returning a boolean.
; Output: a function of one argument (a possibly nested list) that
;         inserts x at the front of every list, at every level of
;         nesting, whose original length satisfies len-ok?.
; Recursive reading (of the returned function, called insert):
;   Base cases: an atom is left unchanged (list-like? is false for it),
;   and the empty list '() has nothing to process, so my-map returns
;   '(); it gets x in front only if (len-ok? 0) is true.
;   Recursive step: first process every element of lst: a sublist is
;   replaced by (insert element), and an atom stays as it is. Then
;   test the length of the ORIGINAL lst with (len-ok? (my-length lst)).
;   If it is true, cons x onto the front of the processed list;
;   otherwise return the processed list as it is.
(define (make-inserter x len-ok?)
  (letrec ((insert
            (lambda (lst)
              (let ((processed
                     (my-map (lambda (e)
                               (if (list-like? e)
                                   (insert e)
                                   e))
                             lst)))
                (if (len-ok? (my-length lst))
                    (cons x processed)
                    processed)))))
    insert))


; insert-if-short : atom list integer -> list
; Input:  x, an atom to insert.
;         lst, a possibly nested list (no dotted pairs).
;         n, an integer with n >= 0.
; Output: lst with x inserted at the front of every list, at every
;         level of nesting, whose original length is less than n.
; Reading:
;   Not recursive itself. Build an inserter with make-inserter, where
;   len-ok? is a function that checks whether a length is less than n,
;   then apply that inserter to lst. All the recursion over nested
;   lists happens inside the function that make-inserter returns.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))


; print-insert-result : -> void
; Input:  none. Reads three values from standard input with read, in
;         this order: x (an atom), lst (a possibly nested list), n (an
;         integer).
; Output: prints the result of (insert-if-short x lst n) on one line
;         using display, followed by a newline. Prints no prompts or
;         other text.
; Reading:
;   Not recursive. Read x, then lst, then n, in that order, then
;   display the result and end the line. let* is used so the three
;   reads happen one after another, left to right.
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))

