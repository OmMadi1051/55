:- use_module(library(lists)).

% generate_solution(-Solution)
% True when Solution is a valid candidate assignment of unique departments,
% favorite languages, and project preferences to Alex, Ben, Carla, and Dana in order.
generate_solution(Solution) :-
    permutation([research, development, design, testing], [D1, D2, D3, D4]),
    permutation([python, java, 'c++', javascript], [L1, L2, L3, L4]),
    permutation(['AI', web, embedded, data], [P1, P2, P3, P4]),
    Solution = [
        p('Alex',  D1, L1, P1),
        p('Ben',   D2, L2, P2),
        p('Carla', D3, L3, P3),
        p('Dana',  D4, L4, P4)
    ].



% clue(+N, +Solution)
% True when clue number N holds for the fully instantiated assignment Solution.

clue(1, Solution) :-
    member(p(Name, Dept, _, 'AI'), Solution),
    Dept \= research,
    Name \= 'Dana'.

clue(2, Solution) :-
    member(p('Alex', Dept, Lang, _), Solution),
    Dept \= development,
    Lang \= 'c++'.

clue(3, Solution) :-
    member(p(_, testing, python, _), Solution).

clue(4, Solution) :-
    member(p('Ben', Dept, _, web), Solution),
    Dept \= testing.

clue(5, Solution) :-
    member(p(_, design, java, _), Solution).

clue(6, Solution) :-
    member(p('Carla', Dept, _, Project), Solution),
    Project \= embedded,
    Dept \= development.

clue(7, Solution) :-
    member(p('Dana', Dept, Lang, _), Solution),
    Lang \= java,
    (Dept = research ; Dept = testing).

clue(8, Solution) :-
    member(p(_, research, Lang, data), Solution),
    Lang \= javascript.



% check_clues(+Active, +Solution)
% True when every clue number in Active holds for Solution.
check_clues([], _).
check_clues([ClueNum | Rest], Solution) :-
    clue(ClueNum, Solution),
    check_clues(Rest, Solution).

% solve(+Active, -Solution)
% True when Solution is a valid candidate assignment that satisfies all clues in Active.
solve(Active, Solution) :-
    generate_solution(Solution),
    check_clues(Active, Solution).

% print_solution(+Solution)
% True after printing each friend's assignment in Solution on its own line.
print_solution([]).
print_solution([p(Name, Dept, Lang, Project) | Rest]) :-
    format('~w [~w, ~w, ~w]~n', [Name, Dept, Lang, Project]),
    print_solution(Rest).

% main
% True after finding one solution satisfying clues 1 through 8 and printing it.
main :-
    once(solve([1, 2, 3, 4, 5, 6, 7, 8], Solution)),
    print_solution(Solution).
