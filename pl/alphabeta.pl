changePlayer(d, a).
changePlayer(a, d).

alphabeta(AIPlayer, MovingPlayer, 0, Alpha, Beta, Board, GoodMove, Value) :-
    boardValue(AIPlayer, Board, Value),
    !.

alphabeta(AIPlayer, MovingPlayer, Depth, Alpha, Beta, Board, GoodMove, Value) :-
    game_over(Board),
    boardValue(AIPlayer, Board, Value),
    !.

alphabeta(AIPlayer, MovingPlayer, Depth, Alpha, Beta, Board, GoodMove, Value) :-
    Depth > 0,
    getAllPlayerAvailableMoves(MovingPlayer, Board, Moves),
    bounded_best(AIPlayer, MovingPlayer, Depth, Alpha, Beta, Moves, Board, GoodMove, Value).

bounded_best(AIPlayer, MovingPlayer, Depth, Alpha, Beta, [[[X1,Y1],[X2,Y2]] | Moves], Board, GoodMove, GoodVal) :-
    Depth > 0,
    move(X1, Y1, X2, Y2, Board, BoardWithNoCapture),
    updateBoard(MovingPlayer, BoardWithNoCapture, NewBoard),
    D is Depth - 1,
    changePlayer(MovingPlayer, NewMovingPlayer),
    alphabeta(AIPlayer, NewMovingPlayer, D, Alpha, Beta, NewBoard, _, Val),
    good_enough(AIPlayer, MovingPlayer, Depth, Alpha, Beta, Board, Moves, [[X1,Y1],[X2,Y2]], Val, GoodMove, GoodVal), !.

good_enough(AIPlayer, MovingPlayer, Depth, Alpha, Beta, Board, [], Move, Val, Move, Val) :- !.

good_enough(AIPlayer, MovingPlayer, Depth, Alpha, Beta, Board, Moves, Move, Val, Move, Val) :-
    AIPlayer == MovingPlayer,
    Val > Beta, !
    ;
    AIPlayer \= MovingPlayer,
    Val < Alpha, !.

good_enough(AIPlayer, MovingPlayer, Depth, Alpha, Beta, Board, Moves, Move, Val, GoodMove, GoodVal) :-
    new_bounds(AIPlayer, MovingPlayer, Alpha, Beta, Move, Val, NewAlpha, NewBeta),
    bounded_best(AIPlayer, MovingPlayer, Depth, NewAlpha, NewBeta, Moves, Board, Move1, Val1),
    betterOf(AIPlayer, MovingPlayer, Move, Val, Move1, Val1, GoodMove, GoodVal).

new_bounds(AIPlayer, MovingPlayer, Alpha, Beta, Move, Val, Val, Beta) :-
    AIPlayer == MovingPlayer,
    Val > Alpha,
    !.

new_bounds(AIPlayer, MovingPlayer, Alpha, Beta, Move, Val, Alpha, Val) :-
    AIPlayer \= MovingPlayer,
    Val < Beta,
    !.

new_bounds(AIPlayer, MovingPlayer, Alpha, Beta, _, _, Alpha, Beta).


betterOf(AIPlayer, MovingPlayer, Move0, Val0, _, Val1, Move0, Val0) :-   % Pos0 better than Pos1
    AIPlayer == MovingPlayer,                         % MIN to move in Pos0
    Val0 > Val1, !                             % MAX prefers the greater value
    ;
    AIPlayer \= MovingPlayer,                         % MAX to move in Pos0
    Val0 < Val1, !.                            % MIN prefers the lesser value

betterOf(_,_, _, _, Move1, Val1, Move1, Val1).


alphabeta(Player, Depth, Board, [Move, Value]) :-
    alphabeta(Player, Player, Depth, -1000, 1000, Board, Move, Value).