:- consult('../code/55_q2.pl').

% check(+Label, :Goal)
% Prints PASS when Goal succeeds, and FAIL when it fails or throws.
check(Label, Goal) :-
    (   catch(Goal, _, fail)
    ->  format('PASS: ~w~n', [Label])
    ;   format('FAIL: ~w~n', [Label])
    ).

% check_all(+List, +Expected)
% Checks that all_equations/2 and count_equations/2 agree with Expected for List.
check_all(List, Expected) :-
    length(Expected, Len),
    format(string(Label), '~w gives ~w equation(s)', [List, Len]),
    check(Label, ( all_equations(List, Es), Es == Expected,
                   count_equations(List, C), C =:= Len )).

run_tests :-
    % PDF Example 1: [4,2,5,3]
    all_equations([4,2,5,3], Es1),
    Expected1 = ["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3", "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"],
    ( Es1 == Expected1 -> writeln('PASS: [4,2,5,3] all_equations') ; format('FAIL [4,2,5,3]: ~w~n', [Es1]) ),
    count_equations([4,2,5,3], C1),
    ( C1 =:= 7 -> writeln('PASS: [4,2,5,3] count = 7') ; format('FAIL count: ~w~n', [C1]) ),

    % PDF Example 2: [2,3,4] (no solution)
    all_equations([2,3,4], Es2),
    ( Es2 == [] -> writeln('PASS: [2,3,4] empty') ; format('FAIL [2,3,4]: ~w~n', [Es2]) ),
    ( \+ generate_equation([2,3,4], _) -> writeln('PASS: [2,3,4] generate fails') ; writeln('FAIL: [2,3,4] should fail') ),

    % PDF Example 3: [2,4,8]
    all_equations([2,4,8], Es3),
    ( Es3 == ["2*4=8"] -> writeln('PASS: [2,4,8]') ; format('FAIL [2,4,8]: ~w~n', [Es3]) ),

    % Edge cases: empty list, single element, zero (division-by-zero safety)
    ( \+ generate_equation([], _) -> writeln('PASS: [] fails') ; writeln('FAIL: [] should fail') ),
    ( \+ generate_equation([5], _) -> writeln('PASS: [5] fails') ; writeln('FAIL: [5] should fail') ),
    all_equations([1,0,1], EsZero),
    ( member("1+0=1", EsZero), member("1-0=1", EsZero) -> writeln('PASS: [1,0,1] safe with 0') ; format('FAIL [1,0,1]: ~w~n', [EsZero]) ),

    writeln('--- Extra: short lists ---'),
    check_all([], []),
    check_all([0], []),
    check_all([1,1], ["1=1"]),
    check_all([12,12], ["12=12"]),
    check_all([1,2], []),
    check_all([1,2,3], ["1+2=3"]),
    check_all([6,3,2], ["6/3=2", "6=3*2"]),
    check_all([10,2,5], ["10/2=5", "10=2*5"]),

    writeln('--- Extra: zero (no division by zero) and exact division ---'),
    check_all([5,0,5], ["5+0=5", "5-0=5", "5=0+5"]),
    check_all([0,0,0], ["0*0=0", "0+0=0", "0-0=0", "0=0*0", "0=0+0", "0=0-0"]),
    check_all([7,2,3], []),
    check_all([5,2,2], []),
    check_all([1,2,3,0], ["1+(2-3)=0", "1+2-3=0", "1+2=3+0", "1+2=3-0"]),
    check('generate_equation fails when division is not exact',
          \+ generate_equation([7,2,3], _)),
    check('generate_equation fails for [1,2]',
          \+ generate_equation([1,2], _)),

    writeln('--- Extra: negative sub-expressions and parentheses ---'),
    check_all([3,5,2,4], ["(3+5)/2=4", "3+5=2*4", "3-5=2-4", "3=5+(2-4)", "3=5+2-4"]),
    check_all([2,3,4,5], ["2-3=4-5", "2=3+(4-5)", "2=3+4-5"]),
    check_all([1,2,3,6],["1*(2*3)=6", "1*2*3=6", "1+(2+3)=6", "1+2+3=6", "1=2*3/6"]),
    check_all([8,4,2,1], ["8/(4*2)=1", "8/4/2=1", "8/4=2*1", "8/4=2/1",
                          "8=4*(2*1)", "8=4*(2/1)", "8=4*2*1", "8=4*2/1"]),

    writeln('--- Extra: longer lists (counts only) ---'),
    check('[1,2,3,4,5] count = 14', count_equations([1,2,3,4,5], 14)),
    check('[1,2,3,4,5,6] count = 101', count_equations([1,2,3,4,5,6], 101)),

    writeln('--- Extra: output format ---'),
    check('generate_equation returns a string',
          ( once(generate_equation([4,2,5,3], E1)), string(E1) )),
    check('no equation contains a space',
          ( all_equations([8,4,2,1], EsF),
            forall(member(E, EsF), \+ sub_string(E, _, _, _, " ")) )),
    check('all_equations is sorted and has no duplicates',
          ( all_equations([1,1,1,1,1], EsS), sort(EsS, EsS) )),
    check('first generate_equation answer is one of all_equations',
          ( once(generate_equation([4,2,5,3], E2)),
            all_equations([4,2,5,3], EsA),
            memberchk(E2, EsA) )),
    check('all generate_equation answers = all_equations',
          ( findall(E, generate_equation([3,5,2,4], E), Gen),
            sort(Gen, GenSet),
            all_equations([3,5,2,4], GenSet) )).
