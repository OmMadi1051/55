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


; leaf-count : tree -> number
; Input:  tree, either '() or (value left right).
; Output: the number of leaves in the tree.
; Recursive reading:
;   Base case 1: the empty tree '() has 0 leaves.
;   Base case 2: a node whose left and right subtrees are both '()
;   is a leaf, so it counts as 1.
;   Recursive step: otherwise, the leaf count is the leaf count of the
;   left subtree (cadr) plus the leaf count of the right subtree (caddr).
(define (leaf-count tree)
  (cond ((null? tree) 0)
        ((and (null? (cadr tree)) (null? (caddr tree))) 1)
        (else (+ (leaf-count (cadr tree))
                 (leaf-count (caddr tree))))))


; inorder-acc : tree list -> list
; Input:  tree, either '() or (value left right).
;         acc, the list that the result is placed in front of.
; Output: the values of tree in inorder (left, node, right),
;         followed by the elements of acc.
; Recursive reading:
;   Base case: the empty tree '() adds nothing, so the result is acc.
;   Recursive step: first build the inorder list of the right subtree
;   in front of acc, then cons the node's value onto that, then build
;   the inorder list of the left subtree in front of the result.
(define (inorder-acc tree acc)
  (if (null? tree)
      acc
      (inorder-acc (cadr tree)
                   (cons (car tree)
                         (inorder-acc (caddr tree) acc)))))