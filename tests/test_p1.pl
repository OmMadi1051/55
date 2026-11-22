:- consult('../code/55_q1.pl').

run_tests :-
    writeln('--- P1.a: main/0 output ---'),
    main,
    writeln('--- P1.b: count_solutions([1..8], N) ---'),
    count_solutions([1,2,3,4,5,6,7,8], N8),
    format('Solutions for clues 1..8: ~w~n', [N8]),
    ( N8 > 0 -> writeln('PASS: N8 > 0') ; writeln('FAIL: N8 should be > 0') ),

    writeln('--- P1.c: count_solutions([1..9], N) ---'),
    count_solutions([1,2,3,4,5,6,7,8,9], N9),
    format('Solutions for clues 1..9: ~w~n', [N9]),
    ( N9 =:= 1 -> writeln('PASS: Unique solution (N = 1)') ; writeln('FAIL: Expected N = 1') ),

    writeln('--- Edge case: no active clues (24^3 = 13824) ---'),
    count_solutions([], N0),
    ( N0 =:= 13824 -> writeln('PASS: Empty clues = 13824') ; format('FAIL: Expected 13824, got ~w~n', [N0]) ).