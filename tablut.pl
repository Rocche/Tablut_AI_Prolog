% [[e,e,e,a,a,a,e,e,e],[e,e,e,e,a,e,e,e,e],[e,e,e,e,d,e,e,e,e],[a,e,e,e,d,e,e,e,a],[a,a,d,d,k,d,d,a,a],[a,e,e,e,d,e,e,e,a],[e,e,e,e,d,e,e,e,e],[e,e,e,e,a,e,e,e,e],[e,e,e,a,a,a,e,e,e]]
initial([
	[e,e,e,a,a,a,e,e,e],
	[e,e,e,e,a,e,e,e,e],
	[e,e,e,e,d,e,e,e,e],
	[a,e,e,e,d,e,e,e,a],
	[a,a,d,d,k,d,d,a,a],
	[a,e,e,e,d,e,e,e,a],
	[e,e,e,e,d,e,e,e,e],
	[e,e,e,e,a,e,e,e,e],
	[e,e,e,a,a,a,e,e,e]
]).

% UTILS

replace([_|T], 0, X, [X|T]) :- !.
replace([H | T], I, X, [H | R]) :- NewI is I - 1, replace(T, NewI, X, R).

replaceInMatrix(X, Y, Element, M, R) :-
	nth0(X, M, Row),
	replace(Row, Y, Element, NewRow),
	replace(M, X, NewRow, R).

selectFromMatrix(X, Y, M, Element) :-
	nth0(X, M, Row),
	nth0(Y, Row, Element).

% MOVE

move(X1, Y1, X2, Y2, Board, NewBoard) :- 
	% first element
	selectFromMatrix(X1, Y1, Board, E1),
	% second element
	selectFromMatrix(X2, Y2, Board, E2),
	% replace second row with first element,
	replaceInMatrix(X2, Y2, E1, Board, NewBoard1),
	% replace first row with second element
	replaceInMatrix(X1, Y1, E2, NewBoard1, NewBoard).

canMove(X, Y1, X, Y2, Board) :- 
	freeTile(X, Y2, Board).

canMove(X1, Y, X2, Y, Board) :-
	freeTile(X2, Y, Board).

% BOARD

freeTile(X, Y, Board) :- selectFromMatrix(X, Y, Board, e).
