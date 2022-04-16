#№ Отчет по лабораторной работе №3
## по курсу "Логическое программирование"

## Решение задач методом поиска в пространстве состояний

### студент: Медведев Д.А.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение

С помощью поиска в пространстве состояний удобно решать задачи, в которых можно построить граф. Вершинами
графа будут являться состояния задачи, а ребрами - переходы между этими состояниями.
Prolog оказывается хорошим языком для решения таких задач, так как Prolog сам по себе построен на переборе
всевозможных вариантов для решения какой-либо задачи, а задача по поиску тоже является перебором с использованием 
определенных алгоритмов.

## Задание

Вариант 5.

Вдоль доски расположено 7 лунок, в которых лежат 3 черных и 3 белых шара. Передвинуть черные шары на место 
белых, а белые - на место черных. Шар можно передвинуть в соседнюю с ним пустую лунку, либо в пустую лунку, 
находящуюся непосредсвенно за ближайшим шаром.

## Принцип решения

Сначала опишем предикаты состояний и переход между ними.

```prolog
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

```

Далее будем использовать алгоритмы поиска в графе: поиск в ширину, поиск в глубину, поиск с итерационным заглублением. 

```prolog
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
```

Чтобы получить ответ, задаём начальное и конечное состояния и с помощью любого алгоритма поиска получаем ответ.


## Результаты

```prolog
?- bfs(['_','black','white','black','white','black','white'], ['_','white','black','white','black','white','black']).
[_,black,white,black,white,black,white]
[black,_,white,black,white,black,white]
[black,white,_,black,white,black,white]
[black,white,black,_,white,black,white]
[black,white,black,white,_,black,white]
[black,white,black,white,black,_,white]
[black,white,black,white,black,white,_]
[black,white,black,white,_,white,black]
[black,white,_,white,black,white,black]
[_,white,black,white,black,white,black]
true.

?- dfs(['_','black','white','black','white','black','white'], ['_','white','black','white','black','white','black']).
[_,black,white,black,white,black,white]
[black,_,white,black,white,black,white]
[black,white,_,black,white,black,white]
[black,white,black,_,white,black,white]
[black,white,black,white,_,black,white]
[black,white,black,white,black,_,white]
[black,white,black,white,black,white,_]
[black,white,black,white,_,white,black]
[black,white,black,_,white,white,black]
[black,white,_,black,white,white,black]
[black,_,white,black,white,white,black]
[_,black,white,black,white,white,black]
[white,black,_,black,white,white,black]
[white,black,black,_,white,white,black]
[white,black,black,white,_,white,black]
[white,black,black,white,white,_,black]
[white,black,black,white,white,black,_]
[white,black,black,white,_,black,white]
[white,black,black,_,white,black,white]
[white,black,_,black,white,black,white]
[white,black,white,black,_,black,white]
[white,black,white,black,black,_,white]
[white,black,white,black,black,white,_]
[white,black,white,black,_,white,black]
[white,black,white,black,white,_,black]
[white,black,white,_,white,black,black]
[white,black,white,white,_,black,black]
[white,black,white,white,black,_,black]
[white,black,white,_,black,white,black]
[white,black,_,white,black,white,black]
[white,_,black,white,black,white,black]
[_,white,black,white,black,white,black]
true.


?- search_id(['_','black','white','black','white','black','white'], ['_','white','black','white','black','white','black']).
[_,black,white,black,white,black,white]
[black,_,white,black,white,black,white]
[black,white,_,black,white,black,white]
[black,white,black,_,white,black,white]
[black,white,black,white,_,black,white]
[black,white,black,white,black,_,white]
[black,white,black,white,black,white,_]
[black,white,black,white,_,white,black]
[black,white,_,white,black,white,black]
[_,white,black,white,black,white,black]
true.
```

Из результатов работы понятно, что дольше всех работает поиск в глубину. А поиск с итерационным заглублением работает чуть 
быстрее, чем поиск в ширину.

! Алгоритм поиска |  Длина найденного первым пути  |
|-----------------|:-------------------------------|
| В глубину       |          32                    |
| В ширину        |          10                    |
| ID              |          10                    |

## Выводы

Я благодарен данной лабораторной работе, так как она научила меня работе с алгоритмами поиска на Prolog. Чтобы сразу найти кратчайший путь, 
нужно использовать поиск в ширину, но в то же время он затрачивает больше памяти, чем поиск в глубину. Также поиск в ширину может 
использоваться для нахождения пути с циклами, в отличие от поиска в глубину. Но самым оптимальным алгоритмом является поиск с 
итерационным заглублением, так как его первое решение - кратчайший путь и затрачивается памяти как в поиске в глубину.



