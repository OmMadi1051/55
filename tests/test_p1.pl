:- consult('../code/55_q1.pl').

% check(+Label, :Goal)
% Prints PASS when Goal succeeds, and FAIL when it fails or throws.
check(Label, Goal) :-
    (   catch(Goal, _, fail)
    ->  format('PASS: ~w~n', [Label])
    ;   format('FAIL: ~w~n', [Label])
    ).

% main_line_solution(+Name, +Line, -P)
% True when Line is exactly "Name = [Dept, Lang, Project]" and P is the matching p/4 term.
main_line_solution(Name, Line, p(Name, Dept, Lang, Project)) :-
    format(string(Prefix), '~w = [', [Name]),
    string_concat(Prefix, Rest, Line),
    string_concat(Inner, "]", Rest),
    split_string(Inner, ",", "", [DeptStr, LangStr0, ProjectStr0]),
    string_concat(" ", LangStr, LangStr0),
    string_concat(" ", ProjectStr, ProjectStr0),
    atom_string(Dept, DeptStr),
    atom_string(Lang, LangStr),
    atom_string(Project, ProjectStr).

% main_output_solution(-Solution)
% True when main/0 prints exactly four correctly formatted lines, parsed into Solution.
main_output_solution([P1, P2, P3, P4]) :-
    with_output_to(string(Out), main),
    split_string(Out, "\n", "", [L1, L2, L3, L4, ""]),
    main_line_solution('Alex',  L1, P1),
    main_line_solution('Ben',   L2, P2),
    main_line_solution('Carla', L3, P3),
    main_line_solution('Dana',  L4, P4).

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
    ( N0 =:= 13824 -> writeln('PASS: Empty clues = 13824') ; format('FAIL: Expected 13824, got ~w~n', [N0]) ),

    writeln('--- Extra: main/0 output format ---'),
    check('main/0 prints 4 lines "Name = [dept, lang, project]"', main_output_solution(_)),
    check('main/0 solution satisfies clues 1..8',
          ( main_output_solution(MainSol), check_clues([1,2,3,4,5,6,7,8], MainSol) )),

    writeln('--- Extra: exact counts ---'),
    check('clues 1..8 give exactly 3 solutions', N8 =:= 3),
    check('clue 3 alone = 3456', count_solutions([3], 3456)),
    check('clue 4 alone = 2592', count_solutions([4], 2592)),
    check('clue 7 alone = 5184', count_solutions([7], 5184)),
    check('clues [3,5] = 1152', count_solutions([3,5], 1152)),
    check('clue order does not matter', count_solutions([8,7,6,5,4,3,2,1], N8)),
    check('repeated clue numbers do not matter', count_solutions([3,3,5,5,3], 1152)),
    check('unknown clue number gives 0', count_solutions([10], 0)),

    writeln('--- Extra: clue 9 ---'),
    check('unique solution for clues 1..9 is the expected one',
          ( findall(S, solve([1,2,3,4,5,6,7,8,9], S), Unique),
            Unique == [[ p('Alex',  design,      java,       embedded),
                         p('Ben',   development, javascript, web),
                         p('Carla', testing,     python,     'AI'),
                         p('Dana',  research,    'c++',      data) ]] )),
    check('clue 9 is false in the other solutions of clues 1..8',
          ( findall(S, (solve([1,2,3,4,5,6,7,8], S), \+ clue(9, S)), Others),
            length(Others, NOthers),
            NOthers =:= N8 - 1 )),

    writeln('--- Extra: clue/2 on the layout example from the PDF ---'),
    Layout = [ p('Alex',  research,    python,     'AI'),
               p('Ben',   development, java,       web),
               p('Carla', design,      'c++',      embedded),
               p('Dana',  testing,     javascript, data) ],
    check('layout example satisfies exactly clues 2, 4 and 7',
          ( findall(N, (between(1, 9, N), clue(N, Layout)), Holding),
            Holding == [2, 4, 7] )).
