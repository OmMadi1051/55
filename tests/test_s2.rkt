;; Tests for S2 (append to 55_q4.rkt when running)

;; PDF Example 1 -> Expected: ((42 1 2) (3 4 5) (42 6) (42))
(display (insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3))
(newline)

;; PDF Example 2 -> Expected: ((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))
(display (insert-if-short 0 '(((1) 2) (3) ((4 5 6) ())) 3))
(newline)

;; PDF Example 3 -> Expected: (7)
(display (insert-if-short 7 '() 3))
(newline)

;; PDF Example 4 -> Expected: ()
(display (insert-if-short 7 '() 0))
(newline)

;; Stress Test 1: 10,000-element flat list (checks tail recursion)
(define big-list
  (let loop ((i 10000) (acc '()))
    (if (= i 0) acc (loop (- i 1) (cons i acc)))))
(display (my-length (insert-if-short 'x big-list 10001))) ;; Expected: 10001
(newline)

;; Stress Test 2: Nesting depth 100
(define deep-list
  (let loop ((d 100) (acc '()))
    (if (= d 0) acc (loop (- d 1) (list acc)))))
(display (car (insert-if-short 'x deep-list 2))) ;; Expected: x
(newline)

;; Stress Test 3: 10,000 empty sublists, n = 1 -> Expected: (10000 (x))
(define many-empties
  (let loop ((i 10000) (acc '()))
    (if (= i 0) acc (loop (- i 1) (cons '() acc)))))
(define many-result (insert-if-short 'x many-empties 1))
(display (list (my-length many-result) (car many-result)))
(newline)

;; Stress Test 4: 10,000-element list that is NOT short -> Expected: (10000 1)
(define big-result (insert-if-short 'x big-list 10000))
(display (list (my-length big-result) (car big-result)))
(newline)

;; Stress Test 5: nesting depth 100, n = 1. Only the innermost () gets x,
;; so x sits 101 levels down -> Expected: (101 x)
(display (let loop ((l (insert-if-short 'x deep-list 1)) (d 0))
           (if (pair? l) (loop (car l) (+ d 1)) (list d l))))
(newline)

;; Stress Test 6: nesting depth 100, n = 2. Every level gets x, so each
;; level has 2 elements except the innermost (x) -> Expected: (2 x)
(define deep-result (insert-if-short 'x deep-list 2))
(display (list (my-length deep-result) (car deep-result)))
(newline)

;; Extra cases

;; n = 0: no length is < 0, so nothing is inserted -> Expected: ((1) ())
(display (insert-if-short 'x '((1) ()) 0))
(newline)

;; n = 1: only empty lists get x -> Expected: ((x) (1) ((x)))
(display (insert-if-short 'x '(() (1) (())) 1))
(newline)

;; Boundary: length equal to n is NOT short -> Expected: (1 2 3)
(display (insert-if-short 'x '(1 2 3) 3))
(newline)

;; Symbols as elements and as x -> Expected: (a b (a c d) e)
(display (insert-if-short 'a '(b (c d) e) 5))
(newline)

;; Large n: every list at every level gets x -> Expected: (9 (9 (9)))
(display (insert-if-short 9 '((())) 10))
(newline)

;; Length is measured on the ORIGINAL list: the top list has 2 elements
;; before insertion -> Expected: (x (x) (x))
(display (insert-if-short 'x '(() ()) 3))
(newline)

;; x equal to existing elements -> Expected: (1 1 1)
(display (insert-if-short 1 '(1 1) 3))
(newline)

;; Only the innermost list is short -> Expected: (1 (2 (3 (4 (x 5)))))
(display (insert-if-short 'x '(1 (2 (3 (4 (5))))) 2))
(newline)

;; A long list nested inside a short one -> Expected: ((1 2 3) (x (1 2 3)) 4)
(display (insert-if-short 'x '((1 2 3) ((1 2 3)) 4) 2))
(newline)

;; Only the innermost () is short -> Expected: ((((q))))
(display (insert-if-short 'q '(((()))) 1))
(newline)

;; --- make-inserter with other length tests ---
(define sample '((1 2) (3) (4 5 6) ((7 8) 9)))

;; Length exactly 2 -> Expected: ((z 1 2) (3) (4 5 6) (z (z 7 8) 9))
(display ((make-inserter 'z (lambda (len) (= len 2))) sample))
(newline)

;; --- my-length and my-map on their own ---

;; Sublists count as one element -> Expected: 3
(display (my-length '(a (b c) d)))
(newline)
;; Expected: ()
(display (my-map (lambda (v) (* v v)) '()))
(newline)
;; Order is preserved -> Expected: (1 4 9 16)
(display (my-map (lambda (v) (* v v)) '(1 2 3 4)))
(newline)

;; --- print-insert-result reading from standard input ---
;; (parameterize / open-input-string are used only here in the tests,
;;  to feed the PDF examples in as standard input.)
;; Expected: ((42 1 2) (3 4 5) (42 6) (42))
(parameterize ((current-input-port (open-input-string "42 ((1 2) (3 4 5) (6) ()) 3")))
  (print-insert-result))
;; Expected: ((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))
(parameterize ((current-input-port (open-input-string "0 (((1) 2) (3) ((4 5 6) ())) 3")))
  (print-insert-result))
;; Expected: (7)
(parameterize ((current-input-port (open-input-string "7 () 3")))
  (print-insert-result))
;; Expected: ()
(parameterize ((current-input-port (open-input-string "7 () 0")))
  (print-insert-result))
