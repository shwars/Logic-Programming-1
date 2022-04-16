% Task 2: Relational Data
%Вариант 1

% Получить таблицу групп и средний балл по каждой из групп
sum_list([], 0, C) :- C is 0.
sum_list([H|T], Sum, N) :- sum_list(T, Rest, C), Sum is H + Rest, N is C+1.
avg_mark([H|_], ANS) :- findall(Z, grade(H, _, Z), R), sum_list(R, Sum, N), ANS is Sum/N.
all_marks([], RES, N) :- RES is 0, N is 0.
all_marks([H|T], RES, N) :- avg_mark([H], ANS), all_marks(T, Y, K), N is K+1, RES is Y+ANS.
res_in_group(X, L, R) :- bagof(Y, student(X, Y), L), all_marks(L, RES, N), R is RES/N.

% Найти двоечников
bad_mark(S, N) :- bagof(Z, grade(Z, S, 2), N).

% Найти количество двоечников в каждой из групп
count_mark_2_in_group([], C) :- C is 0.
count_mark_2_in_group([H|T], C) :- grade(H, _, 2) -> count_mark_2_in_group(T, N), C is N+1; count_mark_2_in_group(T, N), C is N.
count_mark_2(X, C) :- bagof(Y, student(X, Y), L), count_mark_2_in_group(L, C).

% The line below imports the data
:- ['one.pl'].