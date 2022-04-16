# Отчет по курсовому проекту
## по курсу "Логическое программирование"

### студент: Медведев Д.А.

## Результат проверки

Вариант задания:

 - [x] стандартный, без NLP (на 3)
 - [ ] стандартный, с NLP (на 3-4)
 - [ ] продвинутый (на 3-5)
 
| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*

## Введение

В результате выполнения курсового проекта я хочу ещё лучше освоить язык программирования Prolog, научиться писать более сложные предикаты.
Также в данном курсовом проекте я буду использовать Python, который является моим первым языком программирования, поэтому очень приятно
использовать именно его.

## Задание

  1, 4 и 5 задания у всех одинаковые.

2) Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog с использованием предиката child(ребенок, родитель), 
   male(человек), female(человек).
3) Реализовать предикат проверки/поиска свекрови (матери мужа).

## Получение родословного дерева

Я получил родословное дерево в формате GEDCOM с помощью сайта MyHeritage.com. Выбрал последнюю английскую правящую династию Виндзоров, 
так как будет легче проверять правильность выполненной работы (английские монархи - люди известные). В дереве представлено 47 индивидов.

## Конвертация родословного дерева

Для парсинга файла с форматом GEDCOM я решил выбрать Python, потому что очень хорошо знаю этот язык, многие пишут парсеры на Python,
в Python есть модуль gedcom для работы с форматом GEDCOM, что существенно облегчает парсинг.
С помощью модуля gedcom получаем всех членов королевской семьи. Получаем имена индивидов с помощью метода get_name объекта element 
класса Parser. Я завернул это в функцию grab_name, чтобы дважды код не повторять (для родителей позже тоже надо имена брать).

```python
def grab_name(element):
    (first, last) = element.get_name()
    if last == '':
        return first
    else:
        return first + " " + last
```

Далее узнаем пол индивида с помощью метода get_gender и составляем предикаты male и female.

```python
gender = element.get_gender()
if gender == 'M':
    men.append("male(" + "'" + name + "'" + ').')
else:
    women.append("female(" + "'" + name + "'" + ').')
```

Если у индивида есть родители, то получаем их и формируем предикат child.

```python
 if element.is_child():
    for parent in gedcom_parser.get_parents(element, "ALL"):
       name_parent = grab_name(parent)
       children.append("child(" + "'" + name + "'" + ", " + "'" + name_parent + "'" + ").")
```

Записываем предикаты в файл data.pl.

## Предикат поиска родственника

По заданию я написал предикат нахождения свекрови (матери мужа).

`mother_in_law(Mother_in_law, Wife)`

Реализация:

```prolog
father(M, C) :- child(C, M), male(M).
mother(W, C) :- child(C, W), female(W).
have_child(W, M) :- child(C, W), father(M, C), !.
mother_in_law(B, A) :- female(A), have_child(A, Z), female(B), child(Z, B).
% with repetitions
mother_in_law2(B, A) :- female(A), child(C, A), child(C, M), male(M), mother(B, M).
```

Обе реализации mother_in_law имеют единый принцип: если A является женщиной и имеет детей с мужчиной, то он является её мужем 
(в нашей модели так, в жизни не всегда). Далее просто находим мать мужа. Она и является искомой свекровью. 
Отличия реализаций: в реализации без повторов как только мы находим хотя бы одного ребёнка, то возвращаем мужа из have_child.
Во второй реализации для каждого ребёнка определяется отец (муж A), поэтому и возникают повторы.

Пример работы:
```prolog
?- mother_in_law(Mother_in_law, Wife).
Mother_in_law = 'Diana, Princess of Wales',
Wife = 'Catherine, Duchess of Cambridge' ;
Mother_in_law = 'Elizabeth II',
Wife = 'Diana, Princess of Wales' ;
Mother_in_law = 'Princess Anne',
Wife = 'Autumn Phillips' ;
Mother_in_law = 'Diana, Princess of Wales',
Wife = 'Meghan' ;
Mother_in_law = 'Elizabeth II',
Wife = 'Sarah, Duchess of York' ;
Mother_in_law = 'Elizabeth II',
Wife = 'Sophie, Countess of Wessex' ;
Mother_in_law = 'Mary of Teck',
Wife = 'Elizabeth Bowes-Lyon' ;
Mother_in_law = 'Mary of Teck',
Wife = 'Marina' ;
Mother_in_law = 'Mary of Teck',
Wife = 'Alice Montague' ;
false.
```

## Определение степени родства

Сначала определим предикаты для определения родства индивидов. Несложно понять, что будет достаточно 6 отношений родства: father,
mother, sister, brother, son, daughter, так как, имея эти отношения, мы сможем сделать move во все стороны от любого индивида.
Предикаты жена, муж следуют из того, что если индивид - A отец сына индивида B (ниже написано, как работает программа), следовательно, 
А - муж B.

```prolog
common_father(A, B) :- child(A, F), child(B, F), male(F), A \= B.
son(C, P) :- child(C, P), male(C).
daughter(C, P) :- child(C, P), female(C).
brother(A, B) :- common_father(A, B), male(A).
sister(A, B) :- common_father(A, B), female(A).

relation('father', M, C) :- father(M, C).
relation('mother', F, C) :- mother(F, C).
relation('son', C, P) :- son(C, P).
relation('daughter', C, P) :- daughter(C, P).
relation('brother', A, B) :- brother(A, B).
relation('sister', A, B) :- sister(A, B).

move(A, B) :- child(A, B).
move(A, B) :- child(B, A).
move(A, B) :- sister(A, B).
move(A, B) :- brother(A, B).
``` 

Предикат common_father помогает избегать повторы для предикатов sister и brother.

Чтобы определить степень родства двух произвольных индивидуумов в дереве, я решил воспользоваться поиском с итерационным заглублением.
Если нашлась связь между людьми, то мы, выходя из рекурсии, получаем список отношений между людьми, которые были на пути. Если же связь 
не нашлась, то мы делаем следующий шаг, и рекурсивно ищем относительно нового человека. 

```prolog
search_id(Path, A, B, N) :- N = 1, relation(Type, A, B), Path = [Type].
search_id(Path, A, B, N) :- N > 1, move(A, C), N1 is N - 1, search_id(Res, C, B, N1), relation(Type, A, C), append([Type], Res, Path).
``` 

Далее рассмотрим 2 вида запросов. Чтобы найти степень родства, нужно просто выполнить поиск с итерационным заглублением и вывести 
результат в нужном формате. А если нужно по степени родства определить индивидов, тогда форматируем её в список и ищем двух разных
людей, между которыми расстояние равно длине списка.

```prolog
:- op(200, xfy, of).

format(A of B, [A|C]) :- format(B, C).
format(A, [A]).

for(1).
for(M):- for(N), (N < 12 -> M is N+1; !, fail).

relative(Res, A, B) :- var(Res), for(N), N < 12, search_id(Path, A, B, N), B \= A, format(Res, Path).
relative(Res, A, B) :- nonvar(Res), format(Res, Path), length(Path, N), search_id(Path, A, B, N), B \= A.
``` 

Предикат for нужен, чтобы увеличивать N на единицу. Ограничением на N является 12, так как в родословном дереве представлено 6 
поколений. Предикаты op и format нужны для того, что получить путь в нужном формате. 

Пример работы:

```prolog
?- relative(Rel, 'George VI', 'George V').
Rel = son ;
Rel = brother of son ;
Rel = brother of son ;
Rel = brother of daughter ;
Rel = brother of son ;
Rel = brother of son ;
Rel = son of father of son

?- relative(father of father, X, Y).
X = 'Prince Charles, Prince of Wales',
Y = 'Prince George' ;
X = 'Prince Charles, Prince of Wales',
Y = 'Princess Charlotte' ;
X = 'Prince Charles, Prince of Wales',
Y = 'Prince Louis'
``` 

Читается, как "George VI является братом сына George V".
 


## Выводы

Таким образом, данная работа научила меня многим вещам. 
В ходе работы я узнал про DCG нотацию, которая значительно упростила работу с предложениями. Ещё я повторил поиск несколькими способами в Prolog, так как
здесь нужно было использовать его, что безусловно укрепило мои знания. Я благодарен данной курсовой работе за новый опыт.