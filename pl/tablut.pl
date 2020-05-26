:- [utils].
:- [movement].
:- [pieces_behavior].
:- [board_layouts_brandubh].
:- [heuristic].
%:- [minimax].
:- [new_minimax].

% GAME

defender_wins(B) :-
	kingWins(B).
attacker_wins(B) :-
	occurrencesInMatrix(B, k, 0).
game_over(Board) :-
	defender_wins(Board) ; attacker_wins(Board).

% UPDATE BOARD

getPiecesCoordinates(_, [], _, []) :- !.
getPiecesCoordinates(Piece, [ Row | Remaining ], Counter, Coordinates) :-
	findall([ Counter, Y ], nth0(Y, Row, Piece), Coords),
	NextCounter is Counter + 1,
	getPiecesCoordinates(Piece, Remaining, NextCounter, RemainingCoords),
	append(Coords, RemainingCoords, Coordinates).
getPiecesCoordinates(Piece, Board, Coordinates) :- getPiecesCoordinates(Piece, Board, 0, Coordinates).

capturePieces([], Board, Board) :- !.
capturePieces([[ X, Y] | T ], Board, NewBoard) :-
	\+ isCaptured(X, Y, Board),
	capturePieces(T, Board, NewBoard),
	!.
capturePieces([[ X, Y] | T ], Board, NewBoard) :-
    isCaptured(X, Y, Board),
	capture(X, Y, Board, ModifiedBoard),
    capturePieces(T, ModifiedBoard, NewBoard).

updateBoard(_, Board, []) :-
	game_over(Board).

updateBoard(a, Board, NewBoard) :-
	getPiecesCoordinates(d, Board, DefCoords),
	getPiecesCoordinates(k, Board, KingCoords),
	append(DefCoords, KingCoords, EnemyCoords),
	capturePieces(EnemyCoords, Board, NewBoard).

updateBoard(d, Board, NewBoard) :-
	getPiecesCoordinates(a, Board, EnemyCoords),
	capturePieces(EnemyCoords, Board, NewBoard).
% HEURISTICS

% calculate pieces differences

% returns a list of distances from a list of coordinates to a destination point
getDistancesList([], _, _, []).
getDistancesList([[ X, Y] | T], XDest, YDest, Distances) :- 
	distance(X, Y, XDest, YDest, D),
	getDistancesList(T, XDest, YDest, RemainingDistances),
	append([ D ], RemainingDistances, Distances).

% select the nearest coordinate to a destination point
getNearestCoordinates(Coords, XDest, YDest, R) :-
	getDistancesList(Coords, XDest, YDest, Distances),
	min_member(Min, Distances),
	getIndex(Min, Distances, I),
	nth0(I, Coords, R).

kingMovesToWinCell(Board, [], _, _, _, _) :- kingWins(Board), !.
kingMovesToWinCell(Board, Moves, CellX, CellY, [], ForbiddenCells) :-
	getPiecesCoordinates(k, Board, [[ X, Y ]]),
	getAvailableOneStepMoves(X, Y, Board, TotalAvailableMoves),
	ord_subtract(TotalAvailableMoves, ForbiddenCells, AvailableMoves),
	length(AvailableMoves, N),
	(
	N > 0
	-> 
	getNearestCoordinates(AvailableMoves, CellX, CellY, [ XMove , YMove ]),
	move(X, Y, XMove, YMove, Board, NewBoard),
	kingMovesToWinCell(NewBoard, RemainingMoves, CellX, CellY, [[ X, Y ]], ForbiddenCells),
	append([[ XMove, YMove ]], RemainingMoves, Moves)
	;
	kingMovesToWinCell(Board, [], CellX, CellY, [], [])
	),
	!.

kingMovesToWinCell(Board, Moves, CellX, CellY, PrevCells, ForbiddenCells) :-
	length(PrevCells, L),
	L =\= 0,
	getPiecesCoordinates(k, Board, [[ X, Y ]]),
	getAvailableOneStepMoves(X, Y, Board, TotalAvailableMoves),
	ord_subtract(TotalAvailableMoves, ForbiddenCells, AvailableMovesWithPrev),
	last(PrevCells, [ PrevCellX, PrevCellY ]),
	ord_subtract(AvailableMovesWithPrev, [[ PrevCellX, PrevCellY ]], AvailableMoves),
	length(AvailableMoves, N),
	(
	N > 0
	-> 
	getNearestCoordinates(AvailableMoves, CellX, CellY, [ XMove , YMove ]),
	move(X, Y, XMove, YMove, Board, NewBoard),
	append(PrevCells, [[ X, Y ]], NewPrevCells),
	kingMovesToWinCell(NewBoard, RemainingMoves, CellX, CellY, NewPrevCells, ForbiddenCells),
	append([[ XMove, YMove ]], RemainingMoves, Moves)
	;
	move(X, Y, PrevCellX, PrevCellY, Board, NewBoard),
	append(ForbiddenCells, [[ X, Y ]], NewForbiddenCells),
	delete(PrevCells, [ PrevCellX ,  PrevCellY ], NewPrevCells),
	kingMovesToWinCell(NewBoard, RemainingMoves, CellX, CellY, NewPrevCells, NewForbiddenCells),
	append([[ PrevCellX, PrevCellY ]], RemainingMoves, Moves)
	).

% kingMovesToWinUpperLeft(Board, []) :- kingWinsUpperLeft(Board), !.
kingMovesToWinUpperLeft(Board, Moves) :- kingMovesToWinCell(Board, Moves, 0, 0, [], []).
kingMovesToWinUpperRight(Board, Moves) :- kingMovesToWinCell(Board, Moves, 0, 6, [], []).
kingMovesToWinBottomRight(Board, Moves) :- kingMovesToWinCell(Board, Moves, 6, 6, [], []).
kingMovesToWinBottomLeft(Board, Moves) :- kingMovesToWinCell(Board, Moves, 6, 0, [], []).

