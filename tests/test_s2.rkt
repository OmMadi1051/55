;; Tests for S2 (append to id_q4.rkt when running)

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