;; Tests for S1 (append to id_q3.rkt when running)

(define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))
(define t-empty '())
(define t-single '(9 () ()))

;; Expected: (1 2 3 4 5 6 7)
(print-inorder t1)

;; Expected: (1 2 3 4 5 6 7) / (4 2 1 3 6 5 7) / (1 3 2 5 7 6 4)
(print-all-traversals t1)
;; Expected: (3 4)
(print-height-and-leaves t1)

;; Expected: (1 2 3) / (1 2 3) / (3 2 1) and (3 1)
(print-all-traversals t2)
(print-height-and-leaves t2)

;; Expected: (b a c) / (a b c) / (b c a) and (2 2)
(print-all-traversals t3)
(print-height-and-leaves t3)

;; Edge case: empty tree -> () / () / () and (0 0)
(print-inorder t-empty)
(print-all-traversals t-empty)
(print-height-and-leaves t-empty)

;; Edge case: single node -> (9) / (9) / (9) and (1 1)
(print-all-traversals t-single)
(print-height-and-leaves t-single)