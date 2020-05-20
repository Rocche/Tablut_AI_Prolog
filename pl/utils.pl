% UTILS

% util function for nthN
nth0_det(0, [Elem|_], Elem) :- !.
nth0_det(1, [_,Elem|_], Elem) :- !.
nth0_det(2, [_,_,Elem|_], Elem) :- !.
nth0_det(3, [_,_,_,Elem|_], Elem) :- !.
nth0_det(4, [_,_,_,_,Elem|_], Elem) :- !.
nth0_det(5, [_,_,_,_,_,Elem|_], Elem) :- !.
nth0_det(N, [_,_,_,_,_,_   |Tail], Elem) :-
  M is N - 6,
  M >= 0,
  nth0_det(M, Tail, Elem).
  
nth_gen(_, Elem, Elem, Base, Base).
nth_gen([H|Tail], Elem, _, N, Base) :-
  succ(N, M),
  nth_gen(Tail, Elem, H, M, Base).

% take an element from a list with a given index: list starts with index N

nthN(Index, List, Elem, N) :-
  (   integer(Index)
  ->  Index0 is Index - N,
  nth0_det(Index0, List, Elem)        % take nth deterministically
  ;   var(Index)
  ->  List = [H|T],
  nth_gen(T, Elem, H, N, Index)       % match
  ;   must_be(integer, Index)
  ).

% replace element at index I with another element
replace([_|T], 0, X, [X|T]) :- !.
replace([H | T], I, X, [H | R]) :- NewI is I - 1, replace(T, NewI, X, R).

% split list in two halves based on a pivot index, which will not be included
splitList([_|T], 0, [], T) :- !.
splitList([H|T], I, [H|T1], S2) :-
	I1 is I - 1,
	splitList(T, I1, T1, S2).

% replace element at coordinates X Y with another element

replaceInMatrix(X, Y, Element, M, R) :-
	nth0(X, M, Row),
	replace(Row, Y, Element, NewRow),
	replace(M, X, NewRow, R).

% select the element at coordinates X Y from matrix M
selectFromMatrix(X, Y, M, Element) :-
	nth0(X, M, Row),
	nth0(Y, Row, Element).

% gets the Ith row of matrix M
getMatrixRow(M, I, Row) :- nth0(I, M, Row).

% gets the Ith col of matrix M
getMatrixCol(M, I, Col) :-
    transpose(M, MT),
    getMatrixRow(MT, I, Col).

% utils fuctions for getMatrixColumn function
transpose([[]|_], []) :- !.
transpose([[I|Is]|Rs], [Col|MT]) :-
    first_column([[I|Is]|Rs], Col, [Is|NRs]),
    transpose([Is|NRs], MT).

first_column([], [], []).
first_column([[]|_], [], []).
first_column([[I|Is]|Rs], [I|Col], [Is|Rest]) :-
    first_column(Rs, Col, Rest).


% function that gets the manhattan distance between two points
distance(X1, Y1, X2, Y2, D) :- D is abs(X1 - X2) + abs(Y1 - Y2).

% function that gets the number of occurrences of a certain element in a list
occurrencesInList([], _ ,0) :- !.
occurrencesInList([ X | T ],X,Y):- occurrencesInList(T,X,Z), Y is 1+Z, !.
occurrencesInList([ X1 | T ],X,Z):- X1 \= X, occurrencesInList(T,X,Z).

% function that gets the number of occurrences of a certain element in a matrix
occurrencesInMatrix([], _, 0) :- !.
occurrencesInMatrix([ Row | Remaining ], X, R) :- 
	occurrencesInList(Row, X, ResultRow),
	occurrencesInMatrix(Remaining, X, ResultRemaining),
	R is ResultRow + ResultRemaining .

% get indexes of a certain element in list
getIndexes(E, L, Indexes) :- findall(I, nth0(I, L, E), Indexes).

% get only the first index of an element in list
getIndex(E, [ E | _ ], 0) :- !.
getIndex(E, [ H | T], I) :-
	E \= H,
	getIndex(E, T, NewI),
	I is NewI + 1.

addElementToEachListElement(_, [], []) :-  !.
addElementToEachListElement(E, [H | T], R) :-
  addElementToEachListElement(E, T, Remaining),
  append([[E, H]], Remaining, R).


ord_subtract_alternative(List, [], List) :- !.
ord_subtract_alternative(List, [H | T], R) :-
  delete(List, H, NewList),
  ord_subtract_alternative(NewList, T, R).
  