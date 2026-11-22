# P1 Report: Department Puzzle Analysis and Repair

## 1. Solution Count for Clues 1–8 (P1.b)

Running `count_solutions([1,2,3,4,5,6,7,8], N)` on `code/55_q1.pl` yields **`N = 3`** valid assignments.

### Verification Command
```bash
swipl -q -f code/55_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N), writeln(N), forall(solve([1,2,3,4,5,6,7,8], S), writeln(S))" -t halt
```

### All Valid Solutions (Clues 1–8)

| Solution | Alex | Ben | Carla | Dana |
| :--- | :--- | :--- | :--- | :--- |
| **1** | `[design, java, AI]` | `[development, javascript, web]` | `[research, c++, data]` | `[testing, python, embedded]` |
| **2** | `[design, java, embedded]` | `[development, javascript, web]` | `[testing, python, AI]` | `[research, c++, data]` |
| **3** | `[testing, python, embedded]` | `[development, javascript, web]` | `[design, java, AI]` | `[research, c++, data]` |

---

## 2. Why the Original Puzzle Is Under-Constrained

Clues 1–8 uniquely determine **Ben** (`[development, javascript, web]`) and pair the remaining departments with languages (`[design, java]`, `[testing, python]`, and `[research, c++, data]`), but leave two degrees of freedom among Alex, Carla, and Dana:

1. **Dana's department:** Clue 7 allows Dana to work in either `research` or `testing`.
   - If Dana is in `testing` (Solution 1), Carla must take `[research, c++, data]` and Alex must take `[design, java, AI]`.
   - If Dana is in `research` (Solutions 2 and 3), Dana takes `[research, c++, data]`, leaving `[design, java]` and `[testing, python]` for Alex and Carla.
2. **Alex vs. Carla's department:** When Dana is in `research`, Clues 2 and 6 only rule out `development` for Alex and Carla—neither clue distinguishes between `design` and `testing`. Since Clue 1 only requires that the `'AI'` project not belong to `research` or Dana, Carla can pair `'AI'` with either `testing` (Solution 2) or `design` (Solution 3).

---

## 3. Repair: Adding Clue 9 (P1.c)

To make the puzzle uniquely solvable without modifying Clues 1–8, we add **Clue 9**:

> **Clue 9:** The friend who prefers the `'AI'` project works in the `testing` department.

### Prolog Implementation (`code/55_q1.pl`)
```prolog
% CLUE 9: The friend who prefers the AI project works in the testing department.
clue(9, Solution) :-
    member(p(_, testing, _, 'AI'), Solution).
```

### Effect and Verification
- **Eliminates Solution 1:** `'AI'` is assigned to `design` (Alex), not `testing`.
- **Eliminates Solution 3:** `'AI'` is assigned to `design` (Carla), not `testing`.
- **Retains Solution 2:** Carla works in `testing` and prefers `'AI'`.

Running the verification query confirms `1-8: 3` and `1-9: 1`:
```bash
swipl -q -f code/55_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8], N8), count_solutions([1,2,3,4,5,6,7,8,9], N9), format('1-8: ~w~n1-9: ~w~n', [N8, N9])" -t halt
```

### Unique Solution (Clues 1–9)
```text
Alex [design, java, embedded]
Ben [development, javascript, web]
Carla [testing, python, AI]
Dana [research, c++, data]
```