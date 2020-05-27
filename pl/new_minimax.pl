changePlayer(d, a).
changePlayer(a, d).

minimax(AIPlayer, MovingPlayer, 0, Board, BestMove, Value) :-
    boardValue(AIPlayer, Board, Value),
    !.

minimax(AIPlayer, MovingPlayer, Depth, Board, BestMove, Value) :-
    game_over(Board),
    boardValue(AIPlayer, Board, Value),
    !.

minimax(AIPlayer, MovingPlayer, Depth, Board, BestMove, Value) :-
    Depth > 0,
    getAllPlayerAvailableMoves(MovingPlayer, Board, Moves),
    best(AIPlayer, MovingPlayer, Depth, Moves, Board, BestMove, Value).

best(AIPlayer, MovingPlayer, Depth, [[[X1,Y1],[X2,Y2]]], Board, [[X1,Y1],[X2,Y2]], BestVal) :- 
    Depth > 0,
    length([[[X1,Y1],[X2,Y2]]], 1),
    move(X1, Y1, X2, Y2, Board, BoardWithNoCapture),
    updateBoard(MovingPlayer, BoardWithNoCapture, NewBoard),
    D is Depth - 1,
    changePlayer(MovingPlayer, NewMovingPlayer),
    minimax(AIPlayer, NewMovingPlayer, D, NewBoard, _, BestVal),
    !.
best(AIPlayer, MovingPlayer, Depth, [[[X1,Y1],[X2,Y2]] | Moves], Board, BestMove, BestVal) :-
    Depth > 0,
    move(X1, Y1, X2, Y2, Board, BoardWithNoCapture),
    updateBoard(MovingPlayer, BoardWithNoCapture, NewBoard),
    D is Depth - 1,
    changePlayer(MovingPlayer, NewMovingPlayer),
    minimax(AIPlayer, NewMovingPlayer, D, NewBoard, _, Val1),
    best(AIPlayer, MovingPlayer, Depth, Moves, Board, Move2, Val2), %%
    betterOf(AIPlayer, MovingPlayer, [[X1,Y1],[X2,Y2]], Val1, Move2, Val2, BestMove, BestVal),
    !.



betterOf(AIPlayer, MovingPlayer, Move0, Val0, _, Val1, Move0, Val0) :-   % Pos0 better than Pos1
    AIPlayer == MovingPlayer,                         % MIN to move in Pos0
    Val0 > Val1, !                             % MAX prefers the greater value
    ;
    AIPlayer \= MovingPlayer,                         % MAX to move in Pos0
    Val0 < Val1, !.                            % MIN prefers the lesser value

betterOf(_,_, _, _, Move1, Val1, Move1, Val1).

