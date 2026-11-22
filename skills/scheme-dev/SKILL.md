---
name: scheme-dev
description: Guidelines, strict built-in restrictions, testing commands, and self-review checklist for Racket 8.x (#lang racket/base) Scheme tasks in CS F301 Assignment 2.
---

# Scheme Development Skill (Racket 8.x)

## Language & Environment
- **Language:** Racket 8.x, starting every file with `#lang racket/base`.
- **File structure:** Definitions only. Do not call functions or print anything at the top level (the grader appends its own calls to the end of the file).
- **Strictly Allowed Built-ins:**
  - Core forms: `define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`, `quote` (`'`).
  - Pairs & Lists: `cons`, `car`, `cdr`, `list`, `c...r` compositions up to 4 levels (`cadr`, `cddr`, `caddr`, `cadddr`, etc.), `null?`, `pair?`, `eq?`, `assq`, `assoc`.
  - Math & Comparison: `+`, `-`, `*`, `/`, `<`, `>`, `<=`, `>=`, `=`, `max`.
  - I/O: `display`, `newline` (and `read` in S2 only).
- **Forbidden:** `set!` (and all mutation), vectors, hash tables, strings, loops (`do`, `for`), and built-in list helpers (`length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, `list-tail`). Write custom helpers (`my-length`, `my-map`, `my-reverse`, etc.) instead.

## Coding Conventions
- **Naming:** Use `kebab-case` for all functions and variables (e.g., `my-length`, `tree-height`). Prefix custom replacements for standard helpers with `my-`.
- **Comments & Recursive Reading:** Above every function, include a `;` comment stating its inputs, output, and **recursive reading** (base case and recursive step).
- **Tail Recursion:** Prefer tail-recursive helpers (using accumulators or named `let`) for list processing so large inputs (e.g., 10,000 elements) do not overflow the stack. Pass all state through function arguments.

## How to Run & Test
- Run a solution file (should produce no output on its own):
  ```bash
  racket code/55_q3.rkt
  ```
- Run a test file. Build a temporary combined file, run it, and compare the output with the `;; Expected:` comments:
  ```bash
  cat code/55_q3.rkt tests/test_s1.rkt > run_s1.rkt
  racket run_s1.rkt
  ```
  ```bash
  cat code/55_q4.rkt tests/test_s2.rkt > run_s2.rkt
  racket run_s2.rkt
  ```
- Test stdin-based functions (S2):
  ```bash
  (cat code/55_q4.rkt; echo "(print-insert-result)") > run_stdin.rkt
  echo "42 ((1 2) (3 4 5) (6) ()) 3" | racket run_stdin.rkt
  ```
- Delete the temporary `run_*.rkt` files afterwards; do not commit them.

## Self-Review Checklist (Apply Before Answering)
1. Did I only implement the single unit of work requested (one function/helper)?
2. Does the file start with `#lang racket/base` and contain zero top-level function calls or prints?
3. Did I check every single identifier against the strictly allowed built-ins list (no `length`, `append`, `reverse`, `map`, `set!`, `let-values`, etc.)?
4. Does every function have a comment explaining its base case and recursive step?
5. Are list-traversing helpers (`my-length`, `my-reverse`, `my-map`) tail-recursive to handle 10,000-element lists safely?
6. Does every print function end with `(newline)` and print no extra prompts or spaces?

## Known AI Failure Modes in Scheme
- **Sneaking in forbidden built-ins:** AI models frequently use `append`, `reverse`, `map`, `length`, or `list?` by habit. Note that `list?` is NOT on the allowed list—use `(or (null? x) (pair? x))` to test if an element is a list.
- **Non-tail-recursive `my-map` / `my-length`:** Standard recursive `my-map` can hit stack limits on 10,000-element lists; use a tail-recursive accumulator + `my-reverse`.
- **Top-level test expressions:** Leaving `(print-inorder t1)` at the bottom of the file breaks grading.
- **Extra prompts in `read`:** Printing `"Enter x: "` before `(read)` fails automated stdin/stdout grading.