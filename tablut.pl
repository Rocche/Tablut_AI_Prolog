:- [utils].
:- [movement].

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

% UPDATE BOARD

getPiecesCoordinates(_, [], _, []) :- !.
getPiecesCoordinates(Piece, [ Row | Remaining ], Counter, Coordinates) :-
	findall([ Counter, Y ], nth0(Y, Row, Piece), Coords),
	NextCounter is Counter + 1,
	getPiecesCoordinates(Piece, Remaining, NextCounter, RemainingCoords),
	append(Coords, RemainingCoords, Coordinates).

capturePieces([], Board, Board) :- !.
capturePieces([[ X, Y] | T ], Board, NewBoard) :-
	\+ isCaptured(X, Y, Board),
	capturePieces(T, Board, NewBoard),
	!.
capturePieces([[ X, Y] | T ], Board, NewBoard) :-
    isCaptured(X, Y, Board),
	capture(X, Y, Board, ModifiedBoard),
    capturePieces(T, ModifiedBoard, NewBoard).


updateBoard(a, Board, NewBoard) :-
	getPiecesCoordinates(d, Board, 0, DefCoords),
	getPiecesCoordinates(k, Board, 0, KingCoords),
	append(DefCoords, KingCoords, EnemyCoords),
	capturePieces(EnemyCoords, Board, NewBoard).
