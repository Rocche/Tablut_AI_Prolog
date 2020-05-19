:- [utils].
% MOVE

% moves a piece from position X1,Y1 to position X2,Y2
move(X1, Y1, X2, Y2, Board, NewBoard) :- 
	% first element
	selectFromMatrix(X1, Y1, Board, E1),
	% second element
	selectFromMatrix(X2, Y2, Board, E2),
	% replace second row with first element,
	replaceInMatrix(X2, Y2, E1, Board, NewBoard1),
	% replace first row with second element
	replaceInMatrix(X1, Y1, E2, NewBoard1, NewBoard).

% utilities for getting a piece availabe moves

getAvailableMovesRight(X, Y, Board, Moves) :-
	getMatrixRow(Board, X, Row),
	splitList(Row, Y, _, RightList),
	StartingIndex is Y + 1,
	findall([ X, Y2 ], nthN(Y2, RightList, e, StartingIndex), EmptyCells),
	getAdjacentCells(X, Y, EmptyCells, Moves).

getAvailableMovesLeft(X, Y, Board, Moves) :-
	getMatrixRow(Board, X, Row),
	splitList(Row, Y, LeftList, _),
	findall([ X, Y2 ], nth0(Y2, LeftList, e), EmptyCells),
	reverse(EmptyCells, EmptyCellsReversed),
	getAdjacentCells(X, Y, EmptyCellsReversed, Moves).
	
getAvailableMovesDown(X, Y, Board, Moves) :-
	getMatrixCol(Board, Y, Col),
	splitList(Col, X, _, RightList),
	StartingIndex is X + 1,
	findall([ X2, Y ], nthN(X2, RightList, e, StartingIndex), EmptyCells),
	getAdjacentCells(X, Y, EmptyCells, Moves).

getAvailableMovesUp(X, Y, Board, Moves) :-
	getMatrixCol(Board, Y, Col),
	splitList(Col, X, LeftList, _),
	findall([ X2, Y ], nth0(X2, LeftList, e), EmptyCells),
    reverse(EmptyCells, EmptyCellsReversed),
    getAdjacentCells(X, Y, EmptyCellsReversed, Moves).

getAdjacentCells(_, _, [], []) :- !.
getAdjacentCells(X, Y, [[ X1 | Y1 ] | _], []) :-
	distance(X, Y, X1, Y1, D),
	D > 1,
	!.
getAdjacentCells(X, Y, [[ X1 | Y1 ] | T], [[ X1 | Y1 ] | Adj ]) :-
	distance(X, Y, X1, Y1, 1),
	getAdjacentCells(X1, Y1, T, Adj).

getAvailableMoves(X, Y, Board, Moves) :- 
	getAvailableMovesRight(X, Y, Board, R),
	getAvailableMovesDown(X, Y, Board, D),
	getAvailableMovesLeft(X, Y, Board, L),
	getAvailableMovesUp(X, Y, Board, U),
	append(R, D, RD),
	append(RD, L, RDL),
	append(RDL, U, TotalMoves),
	% remove [3,3]: it is the throne
	delete(TotalMoves, [3,3], Moves).

oneStepRight(X, Y, Board, [[X, Y1]]) :- Y1 is Y + 1, selectFromMatrix(X, Y1, Board, e), !.
oneStepRight(X, Y, Board, []) :- Y1 is Y + 1, \+ selectFromMatrix(X, Y1, Board, e).
oneStepDown(X, Y, Board, [[X1, Y]]) :- X1 is X + 1, selectFromMatrix(X1, Y, Board, e), !.
oneStepDown(X, Y, Board, []) :- X1 is X + 1, \+ selectFromMatrix(X1, Y, Board, e).
oneStepLeft(X, Y, Board, [[X, Y1]]) :- Y1 is Y - 1, selectFromMatrix(X, Y1, Board, e), !.
oneStepLeft(X, Y, Board, []) :- Y1 is Y - 1, \+ selectFromMatrix(X, Y1, Board, e).
oneStepUp(X, Y, Board, [[X1, Y]]) :- X1 is X - 1, selectFromMatrix(X1, Y, Board, e), !.
oneStepUp(X, Y, Board, []) :- X1 is X - 1, \+ selectFromMatrix(X1, Y, Board, e).

getAvailableOneStepMoves(X, Y, Board, Moves) :-
	oneStepRight(X, Y, Board, R),
	oneStepDown(X, Y, Board, D),
	oneStepLeft(X, Y, Board, L),
	oneStepUp(X, Y, Board, U),
	append(R, D, RD),
	append(RD, L, RDL),
	append(RDL, U, TotalMoves),
	% remove [3,3]: it is the throne
	delete(TotalMoves, [3,3], Moves).


getAllAvailableMoves(_, [], []) :- !.
getAllAvailableMoves(Board, [[X, Y] | T], Moves) :-
	getAvailableMoves(X, Y, Board, M),
	addElementToEachListElement([X, Y], M, M2),
	getAllAvailableMoves(Board, T, RemainingMoves),
	append(M2, RemainingMoves, Moves).

getAllPlayerAvailableMoves(a, Board, Moves) :-
	getPiecesCoordinates(a, Board, Coords),
	getAllAvailableMoves(Board, Coords, Moves).

getAllPlayerAvailableMoves(d, Board, Moves) :-
	getPiecesCoordinates(d, Board, DefCoords),
	getPiecesCoordinates(k, Board, KingCoords),
	append(DefCoords, KingCoords, Coords),
	getAllAvailableMoves(Board, Coords, Moves).