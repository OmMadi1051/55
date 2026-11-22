:- consult('../code/55_q2.pl').

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
    ( member("1+0=1", EsZero), member("1-0=1", EsZero) -> writeln('PASS: [1,0,1] safe with 0') ; format('FAIL [1,0,1]: ~w~n', [EsZero]) ).