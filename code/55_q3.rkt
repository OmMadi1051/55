#lang racket/base

; tree-height : tree -> number
; Input:  tree, either '() or (value left right).
; Output: the height of the tree.
; Recursive reading:
;   Base case: the empty tree '() has height 0.
;   Recursive step: a node's height is 1 plus the larger of the
;   heights of its left subtree (cadr) and right subtree (caddr).
(define (tree-height tree)
  (if (null? tree)
      0
      (+ 1 (max (tree-height (cadr tree))
                (tree-height (caddr tree))))))