%Задание для N = 12  
%предикат нахождения длины списка
list_length([], 0):-!.
list_length([_Head|Tail], Length):-
    list_length(Tail, TailLength),
    Length is TailLength + 1.

%предикат наличия элемента в списке
list_member(Elem, [Elem|_Tail]).
list_member(Elem, [_Head|Tail]):-
   list_member(Elem, Tail).

%предикат конкатенации двух списков
list_append([], List2, List2).
list_append([Head|Tail], List2, [Head|Tailresult]):-
   list_append(Tail, List2, Tailresult).

%предикат проверки вложенности списков слева
sub_start([], _List):-!.
sub_start([Head|TailSub], [Head|TailList]):-
   sub_start(TailSub, TailList).
sublist(Sub, List):-
   sub_start(Sub, List), !.
sublist(Sub, [_Head|Tail]):-
   sublist(Sub, Tail).

%предикат удаления элементов
list_remove(Elem, [Elem|Tail], Tail).
list_remove(Elem, [Head|Tail], [Head|TailResult]):-
    list_remove(Elem, Tail, TailResult).

%предикат перестановок списка
permute([],[]).
permute(List, [Head|Tail]):-
   list_remove(Head, List, R),
   permute(R, Tail).

%нахождение элемента списка, следующего за данным
list_next(Elem , List, NextElem):- % 1 способ
   list_append(_,[Elem, NextElem|_], List).

list_next_s(Elem, List, NextElem):- % 2 способ
   append(_, [Elem,NextElem|_], List).
   
                               % 3 способ
list_next_el([A,B|_], A, B).
list_next_el([_|T], A, B):- list_next_el(T, A, B).



%разделение списка на два по принципу четности элементов
parity_partition([],[],[]).  % 1 способ
parity_partition([A|B], [A|X], Y):- 0 is A mod 2, parity_partition(B,X,Y).
parity_partition([A|B], X, [A|Y]):- 1 is A mod 2, parity_partition(B,X,Y).

:- use_module(library(clpfd)). % 2 способ
list_evens_odds([], [], []).
list_evens_odds([E|Zs], [E|Es], Os) :- 0 #= E mod 2, list_evens_odds(Zs, Es, Os).
list_evens_odds([E|Zs], Es, [E|Os]) :- 1 #= E mod 2, list_evens_odds(Zs, Es, Os).

% совместное использование
remove_next_elem(A, Elem, X) :- list_next(Elem, A, Next_Elem), list_remove(Next_Elem, A, X).