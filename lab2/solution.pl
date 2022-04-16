% Place your solution here
% N = 12

colour('green').
colour('blue').
colour('white').

different_shoes(Ann, Natasha, Valya) :- Natasha = 'green', colour(Valya), Valya \= 'white', Valya \= Natasha, colour(Ann), Ann \= Natasha, Ann \= Valya.
different_dresses(Ann, Natasha, Valya) :- colour(Valya), Valya \= 'white', colour(Ann), Ann \= Valya, colour(Natasha), Natasha \= Ann, Natasha \= Valya.
same_colour(Colour, Colour):- colour(Colour).
green_plus_white(Colour, Another_colour):- (same_colour(Colour, 'green'), same_colour(Another_colour, 'white')) ;
(same_colour(Another_colour, 'green'), same_colour(Colour, 'white')).


solve(Ann_shoes, Ann_dress, Natasha_shoes, Natasha_dress, Valya_shoes, Valya_dress):- different_dresses(Ann_dress, Natasha_dress, Valya_dress),
different_shoes(Ann_shoes, Natasha_shoes, Valya_shoes), same_colour(Ann_shoes, Ann_dress), not(same_colour(Natasha_shoes, Natasha_dress)),
not(same_colour(Valya_shoes, Valya_dress)), not(green_plus_white(Ann_shoes, Ann_dress)), not(green_plus_white(Natasha_shoes, Natasha_dress)),
not(green_plus_white(Valya_shoes, Valya_dress)).