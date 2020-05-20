% PIECES BEHAVIOR

% capture a piece in position X Y
capture(X, Y, Board, NewBoard) :- replaceInMatrix(X, Y, e, Board, NewBoard). 

% enemy relationships

enemy(k, a).
enemy(a, k).
enemy(d, a).
enemy(a, d).


hostile(a, _, 3, 3) :- !.
hostile(d, Board, 3, 3) :- selectFromMatrix(3, 3, Board, e), !.
hostile(_, _, 0, 0) :- !.
hostile(_, _, 0, 6) :- !.
hostile(_, _, 6, 0) :- !.
hostile(_, _, 6, 6) :- !.

restricted(_, 0, 0) :- !.
restricted(_, 0, 6) :- !.
restricted(_, 6, 0) :- !.
restricted(_, 6, 6) :- !.
restricted(_, 3, 3) :- !.

isCapturedVertically(X, Y, Board) :-
	selectFromMatrix(X, Y, Board, Piece),
	UP is X - 1,
	DOWN is X + 1,
	selectFromMatrix(UP, Y, Board, UpperNeighbor),
	(enemy(Piece, UpperNeighbor) ;  hostile(Piece, Board, UP, Y)),
	selectFromMatrix(DOWN, Y, Board, BottomNeighbor),
	(enemy(Piece, BottomNeighbor) ;  hostile(Piece, Board, DOWN, Y)).

isCapturedHorizontally(X, Y, Board) :-
    selectFromMatrix(X, Y, Board, Piece),
    LEFT is Y - 1,
    RIGHT is Y + 1,
    selectFromMatrix(X, LEFT, Board, LeftNeighbor),
    (enemy(Piece, LeftNeighbor) ;  hostile(Piece, Board, X, LEFT)),
    selectFromMatrix(X, RIGHT, Board, RightNeighbor),
    (enemy(Piece, RightNeighbor) ;  hostile(Piece, Board, X, RIGHT)).

isCaptured(X, Y, Board) :- 
	\+ selectFromMatrix(X, Y, Board, k),
	isCapturedVertically(X, Y, Board), !.
isCaptured(X, Y, Board) :- 
    \+ selectFromMatrix(X, Y, Board, k),
    isCapturedHorizontally(X, Y, Board), !.
isCaptured(X, Y, Board) :- 
    selectFromMatrix(X, Y, Board, k),
    isCapturedVertically(X, Y, Board),
	isCapturedHorizontally(X, Y, Board).