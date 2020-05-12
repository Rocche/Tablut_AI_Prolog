:- [utils].

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

getAvailableMovesRight(X, Y, Board, Moves) :-
	getMatrixRow(Board, X, Row),
	splitList(Row, Y, _, RightList),
	StartingIndex is Y + 1,
	findall([X, Y2], nthN(Y2, RightList, e, StartingIndex), Moves).

%getAvailableMoves(X1, Y1, Board, L) :-
%	findall([X2, Y2], canMove(X1, Y1, X2, Y2, Board), L).

% BOARD

%freeTile(X, Y, Board) :- selectFromMatrix(X, Y, Board, e).
