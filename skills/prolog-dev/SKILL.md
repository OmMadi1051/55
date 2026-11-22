---
name: prolog-dev
description: Guidelines, conventions, testing commands, and self-review checklist for SWI-Prolog 9.x logic programming tasks in CS F301 Assignment 2.
---

# Prolog Development Skill (SWI-Prolog 9.x)

## Language & Environment
- **Language:** SWI-Prolog 9.x
- **Allowed libraries:** `lists`, `apply`, `yall`, `aggregate` only.
- **Forbidden features:** `assert/1`, `retract/1`, dynamic predicates, global variables (`b_setval/2`, `nb_setval/2`), `halt/0`, and `:- initialization(...)` directives.
- **File structure:** Solution files must contain definitions only. Do not print anything unless explicitly required by the predicate specification.

## Coding Conventions
- **Naming:** Use `snake_case` for all predicate and variable-free atom names; use descriptive `PascalCase` for variables (e.g., `Solution`, `RemainingClues`).
- **Comments & Declarative Reading:** Directly above every predicate, include a `%` comment giving its signature/mode (e.g., `% count_solutions(+Active, -N)`) and a one-line **declarative reading** explaining what relationship holds when the predicate succeeds.
- **Purity & Determinism:** Prefer pure, declarative logic. Avoid unnecessary cuts (`!`) that break backtracking when multiple solutions are needed.

## How to Run & Test
- Run `main/0`:
  ```bash
  swipl -q -f code/id_q1.pl -g main -t halt
  ```
- Run a specific goal:
  ```bash
  swipl -q -f code/id_q2.pl -g "all_equations([4,2,5,3], Es), writeln(Es)" -t halt
  ```
- Run a test file:
  ```bash
  swipl -q -f tests/test_p1.pl -g run_tests -t halt
  ```

## Self-Review Checklist (Apply Before Answering)
1. Did I only implement the single unit of work requested (one predicate/section)?
2. Are all required libraries explicitly loaded with `:- use_module(library(...))` and restricted to `lists`, `apply`, `yall`, `aggregate`?
3. Are there zero `assert`, `retract`, `b_setval`, `nb_setval`, `halt/0`, or `initialization` directives?
4. Does every predicate have a declarative reading comment?
5. Do edge cases (empty lists, single-element lists, division by zero, non-exact division) fail cleanly without throwing exceptions or looping infinitely?
6. Are SWI-Prolog strings (`"..."`) used where strings are required, rather than atoms (`'...'`) or code lists?

## Known AI Failure Modes in Prolog
- **Adding `:- initialization(main).` or `halt/0`:** Breaks automated grading when the grader passes `-g <goal> -t halt`.
- **Confusing atoms and strings:** Returning `'4*2=5+3'` instead of `"4*2=5+3"` (use `atom_string/2`, `number_string/2`, or `string_concat/3`).
- **Unsafe arithmetic:** Using `is` on uninstantiated variables or dividing by `0` without checking `Val =\= 0` and `A mod B =:= 0` first.
- **String-eval hacks:** Building a string and parsing it back into a term to evaluate it—strictly forbidden; build and evaluate an AST instead.
- **Singleton variable warnings:** Leaving unused variables named instead of using `_` or `_Name`.