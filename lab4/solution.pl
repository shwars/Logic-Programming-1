% N = 12
% Рекурсивный подсчет арифметического выражения
calculate([N], N) :- number(N).
calculate(Seq, Ans) :- append(A, ['-'|B], Seq), calculate(A, X), calculate(B, Y), !, Ans is X - Y.
calculate(Seq, Ans) :- append(A, ['+'|B], Seq), calculate(A, X), calculate(B, Y), !, Ans is X + Y.
calculate(Seq, Ans) :- append(A, ['*'|B], Seq), calculate(A, X), calculate(B, Y), !, Ans is X * Y.
calculate(Seq, Ans) :- append(A, ['/'|B], Seq), calculate(A, X), calculate(B, Y), !, Y \= 0, Ans is X / Y.
calculate(Seq, Ans) :- append(A, ['^'|B], Seq), calculate(A, X), calculate(B, Y), !, Ans is X ** Y.