:- use_module(library(lists)).

% split_nonempty(+List, -Left, -Right)
% True when List is the concatenation of two non-empty contiguous sublists Left and Right.
split_nonempty(List, Left, Right) :-
    append(Left, Right, List),
    Left = [_ | _],
    Right = [_ | _].

% apply_op(-Op, +LVal, +RVal, -Val)
% True when applying binary arithmetic operator Op to LVal and RVal yields exact integer Val.
apply_op(+, LVal, RVal, Val) :-
    Val is LVal + RVal.
apply_op(-, LVal, RVal, Val) :-
    Val is LVal - RVal.
apply_op(*, LVal, RVal, Val) :-
    Val is LVal * RVal.
apply_op(/, LVal, RVal, Val) :-
    RVal =\= 0,
    LVal mod RVal =:= 0,
    Val is LVal // RVal.

% build_expr(+Nums, -Tree, -Val)
% True when Tree is a valid binary expression tree over non-empty list Nums (in order) evaluating to Val.
build_expr([N], num(N), N).
build_expr(Nums, op(Op, LTree, RTree), Val) :-
    split_nonempty(Nums, LNums, RNums),
    build_expr(LNums, LTree, LVal),
    build_expr(RNums, RTree, RVal),
    apply_op(Op, LVal, RVal, Val).




% prec(+Op, -Prec)
% True when arithmetic operator Op has precedence level Prec.
prec(+, 1).
prec(-, 1).
prec(*, 2).
prec(/, 2).

% wrap_parens(+Inner, -Wrapped)
% True when Wrapped is the string Inner enclosed in parentheses.
wrap_parens(Inner, Wrapped) :-
    string_concat("(", Inner, Temp),
    string_concat(Temp, ")", Wrapped).

% format_left(+Tree, +ParentPrec, -Str)
% True when Str is the canonical string for left operand Tree under ParentPrec.
format_left(num(N), _, Str) :-
    number_string(N, Str).
format_left(op(LOp, L, R), ParentPrec, Str) :-
    prec(LOp, LPrec),
    expr_to_string(op(LOp, L, R), InnerStr),
    (   LPrec < ParentPrec
    ->  wrap_parens(InnerStr, Str)
    ;   Str = InnerStr
    ).

% format_right(+Tree, +ParentPrec, -Str)
% True when Str is the canonical string for right operand Tree under ParentPrec.
format_right(num(N), _, Str) :-
    number_string(N, Str).
format_right(op(ROp, L, R), ParentPrec, Str) :-
    prec(ROp, RPrec),
    expr_to_string(op(ROp, L, R), InnerStr),
    (   RPrec =< ParentPrec
    ->  wrap_parens(InnerStr, Str)
    ;   Str = InnerStr
    ).

% expr_to_string(+Tree, -Str)
% True when Str is the canonical SWI-Prolog string representation of expression tree Tree.
expr_to_string(num(N), Str) :-
    number_string(N, Str).
expr_to_string(op(Op, L, R), Str) :-
    prec(Op, ParentPrec),
    format_left(L, ParentPrec, LStr),
    format_right(R, ParentPrec, RStr),
    atom_string(Op, OpStr),
    string_concat(LStr, OpStr, LeftOp),
    string_concat(LeftOp, RStr, Str).



% generate_equation(+List, -Equation)
% True when Equation is a canonical SWI-Prolog string representing a valid arithmetic equation over List.
generate_equation(List, Equation) :-
    split_nonempty(List, Left, Right),
    build_expr(Left, LTree, LVal),
    build_expr(Right, RTree, RVal),
    LVal =:= RVal,
    expr_to_string(LTree, LStr),
    expr_to_string(RTree, RStr),
    string_concat(LStr, "=", LeftEq),
    string_concat(LeftEq, RStr, Equation).

% all_equations(+List, -Equations)
% True when Equations is the sorted, duplicate-free list of all valid equation strings for List.
all_equations(List, Equations) :-
    findall(Eq, generate_equation(List, Eq), RawEquations),
    sort(RawEquations, Equations).

% count_equations(+List, -N)
% True when N is the number of distinct valid equations for List.
count_equations(List, N) :-
    all_equations(List, Equations),
    length(Equations, N).
