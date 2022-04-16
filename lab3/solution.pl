% Вариант 5
% N = 12

% Возможные переходы
move(A,B) :- append(H, ['_','white'|T], A), append(H, ['white','_'|T], B).
move(A,B) :- append(H, ['white','_'|T], A), append(H, ['_','white'|T], B).
move(A,B) :- append(H, ['_','black'|T], A), append(H, ['black','_'|T], B).
move(A,B) :- append(H, ['black','_'|T], A), append(H, ['_','black'|T], B).
move(A,B) :- append(H, ['_','black','white'|T], A), append(H, ['white','black','_'|T], B).
move(A,B) :- append(H, ['_','white','black'|T], A), append(H, ['black','white','_'|T], B).
move(A,B) :- append(H, ['black','white','_'|T], A), append(H, ['_','white','black'|T], B).
move(A,B) :- append(H, ['white','black','_'|T], A), append(H, ['_','black','white'|T], B).

% Поиск перемещений
prolong([A|T], [B,A|T]) :- move(A, B), not(member(B, [A|T])).

% Получение числа
num(1).
num(N) :- num(N1), N is N1 + 1.

% Поиск в глубину
dfs(A, B) :- write(A), ddth([[A]], B, T), print(T), !.
ddth([[H|T]|_], H, [H|T]).
ddth([H|T], A, C) :- findall(W, prolong(H, W), B), append(B, T, E), !, ddth(E, A, C).
ddth([_,T], A, B) :- ddth(T, A, B).

% Поиск в ширину
bfs(A, B) :- write(A), bdth([[A]], B, T), print(T), !.
bdth([[H|T]|_], H, [H|T]).
bdth([H|T], A, B) :- findall(W, prolong(H, W), Z), append(T, Z, E), !, bdth(E, A, B).
bdth([_,T], A, B) :- bdth(T, A, B).

% Поиск с итерационным погружением
search_id(A, B, W, D) :- depth_id([A], B, W, D).
depth_id([H|T], H, [H|T], 0).
depth_id(W, A, B, N) :- N > 0, prolong(W, Z), N1 is N - 1, depth_id(Z, A, B, N1).
search_id(A, B, C) :- num(T), search_id(A, B, C, T).
search_id(A, B) :- write(A), search_id(A, B, C), print(C), !.

% Печать результата
print([_]).
print([H|T]) :- print(T), nl, write(H).