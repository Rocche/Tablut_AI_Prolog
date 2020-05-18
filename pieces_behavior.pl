% PIECES BEHAVIOR

% capture a piece in position X Y
capture(X, Y, Board, NewBoard) :- replaceInMatrix(X, Y, e, Board, NewBoard). 

% enemy relationships

enemy(k, a).
enemy(a, k).
enemy(d, a).
enemy(a, d).

isCapturedVertically(X, Y, Board) :-
	selectFromMatrix(X, Y, Board, Piece),
	UP is X - 1,
	DOWN is X + 1,
	selectFromMatrix(UP, Y, Board, UpperNeighbor),
	enemy(Piece, UpperNeighbor),
	selectFromMatrix(DOWN, Y, Board, BottomNeighbor),
	enemy(Piece, BottomNeighbor).

isCapturedHorizontally(X, Y, Board) :-
    selectFromMatrix(X, Y, Board, Piece),
    LEFT is Y - 1,
    RIGHT is Y + 1,
    selectFromMatrix(X, LEFT, Board, LeftNeighbor),
    enemy(Piece, LeftNeighbor),
    selectFromMatrix(X, RIGHT, Board, RightNeighbor),
    enemy(Piece, RightNeighbor).

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