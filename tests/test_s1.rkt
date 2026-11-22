;; Tests for S1 (append to 55_q3.rkt when running)

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

;; Left-skewed chain (mirror of t2)
(define t-left '(3 (2 (1 () ()) ()) ()))
;; Expected: (1 2 3)
(print-inorder t-left)
;; Expected: (1 2 3) / (3 2 1) / (1 2 3) and (3 1)
(print-all-traversals t-left)
(print-height-and-leaves t-left)

;; Zig-zag chain: every node has exactly one child, alternating sides
(define t-zigzag '(1 (2 () (3 (4 () ()) ())) ()))
;; Expected: (2 4 3 1) / (1 2 3 4) / (4 3 2 1) and (4 1)
(print-all-traversals t-zigzag)
(print-height-and-leaves t-zigzag)

;; Root with only a left child: the root is not a leaf
(define t-onekid '(5 (3 () ()) ()))
;; Expected: (3 5)
(print-inorder t-onekid)
;; Expected: (3 5) / (5 3) / (3 5) and (2 1)
(print-all-traversals t-onekid)
(print-height-and-leaves t-onekid)

;; Unbalanced tree, multi-digit values, nodes with 0, 1 and 2 children
(define t-uneven
  '(8 (3 (1 () ()) (6 (4 () ()) (7 () ())))
      (10 () (14 (13 () ()) ()))))
;; Expected: (1 3 4 6 7 8 10 13 14)
(print-inorder t-uneven)
;; Expected: (1 3 4 6 7 8 10 13 14) / (8 3 1 6 4 7 10 14 13) / (1 4 7 6 3 13 14 10 8)
(print-all-traversals t-uneven)
;; Expected: (4 4)
(print-height-and-leaves t-uneven)

;; Symbols only, full tree of height 3
(define t-sym '(d (b (a () ()) (c () ())) (f (e () ()) (g () ()))))
;; Expected: (a b c d e f g) / (d b a c f e g) / (a c b e g f d) and (3 4)
(print-all-traversals t-sym)
(print-height-and-leaves t-sym)

;; Numbers and symbols mixed
(define t-mixed '(x (1 () ()) (y () (2 () ()))))
;; Expected: (1 x y 2) / (x 1 y 2) / (1 2 y x) and (3 2)
(print-all-traversals t-mixed)
(print-height-and-leaves t-mixed)

;; Full tree of height 4 (15 nodes, 8 leaves)
(define t-full4
  '(8 (4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ())))
      (12 (10 (9 () ()) (11 () ())) (14 (13 () ()) (15 () ())))))
;; Expected: (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)
;;         / (8 4 2 1 3 6 5 7 12 10 9 11 14 13 15)
;;         / (1 3 2 5 7 6 4 9 11 10 13 15 14 12 8)
(print-all-traversals t-full4)
;; Expected: (4 8)
(print-height-and-leaves t-full4)

;; Stress: left chain of 10,000 nodes with values 1..10000 (root is 10000)
(define t-chain
  (let loop ((i 1) (acc '()))
    (if (> i 10000) acc (loop (+ i 1) (list i acc '())))))
;; Expected: (10000 1)
(print-height-and-leaves t-chain)
