:- [heuristic].
:- [movement].

changePlayer(d, a).
changePlayer(a, d).

choose_best_move(_, _, [], _, _, Alpha, _, Move, [Move, Alpha]) :- !.
choose_best_move(Player, PlayerToMove, [[[X1,Y1],[X2,Y2]] | Moves], Board, D, Alpha, Beta, Move1, BestMove) :-
    move(X1, Y1, X2, Y2, Board, BoardWithNoCapture),
    updateBoard(PlayerToMove, BoardWithNoCapture, NewBoard),
    alpha_beta(Player, PlayerToMove, D, NewBoard, Alpha, Beta, _, Value),
    Value1 is -Value,
    cutoff(Player, PlayerToMove, [[X1,Y1],[X2,Y2]], Value1, D, Alpha, Beta, Moves, Board, Move1, BestMove).

alpha_beta(Player, _, 0, Board, _, _, _, Value) :-
    boardValue(Player, Board, Value),
    !.

alpha_beta(Player, _, _, Board, _, _, _, Value) :-
    game_over(Board),
    boardValue(Player, Board, Value),
    !.
    
alpha_beta(Player, PlayerToMove, D, Board, Alpha, Beta, Move, Value) :-
    D > 0,
    changePlayer(PlayerToMove, NewPlayerToMove),
    getAllPlayerAvailableMoves(NewPlayerToMove, Board, Moves),
    Alpha1 is -Beta,
    Beta1 is -Alpha,
    D1 is D - 1,
    choose_best_move(Player, NewPlayerToMove, Moves, Board, D1, Alpha1, Beta1, nil, [Move, Value]).

cutoff(_, PlayerToMove, Move, Value, _, _, Beta, _, _, _, [Move, Value]) :-
    Value >= Beta,
    !.
cutoff(Player, PlayerToMove, Move, Value, D, Alpha, Beta, Moves, Board, _, BestMove) :-
    Alpha < Value,
    Value < Beta,
    choose_best_move(Player, PlayerToMove, Moves, Board, D, Value, Beta, Move, BestMove),
    !.
cutoff(Player, PlayerToMove, _, Value, D, Alpha, Beta, Moves, Board, Move1, BestMove) :-
    Value =< Alpha,
    choose_best_move(Player, PlayerToMove, Moves, Board, D, Alpha, Beta, Move1, BestMove).

choose_best_move(Player, Board, Depth, Best) :-
    getAllPlayerAvailableMoves(Player, Board, Moves),
    choose_best_move(Player, Player, Moves, Board, Depth, -1000, 1000, nil, Best).


choose_move(_, [], _, _, _, Record, Record) :- !.
choose_move(Player, [[[X1,Y1],[X2,Y2]] | Moves], Board, D, MaxPlayer, Record, BestMove) :-
    move(X1, Y1, X2, Y2, Board, BoardWithNoCapture),
    (
    MaxPlayer == -1 %means that move belongs to Player
    ->
    updateBoard(Player, BoardWithNoCapture, NewBoard)
    ;
    changePlayer(Player, Opponent),
    updateBoard(Opponent, BoardWithNoCapture, NewBoard)
    ),
    minimax(Player, D, NewBoard, MaxPlayer, _, Value),
    updateBestMove([[X1,Y1],[X2,Y2]], Value, Record, Record1),
    choose_move(Player, Moves, Board, D, MaxPlayer, Record1, BestMove).

minimax(Player, _, Board, MaxPlayer, _, Value) :-
    game_over(Board),
    boardValue(Player, Board, Value1),
    Value is Value1 * (-MaxPlayer), !.
minimax(Player, 0, Board, MaxPlayer, _, Value) :-
    boardValue(Player, Board, Value1),
    Value is Value1 * (-MaxPlayer).
minimax(Player, D, Board, MaxPlayer, Move, Value) :-
    D > 0,
    (
    MaxPlayer == 1
    ->
    getAllPlayerAvailableMoves(Player, Board, Moves)
    ;
    changePlayer(Player, Opponent),
    getAllPlayerAvailableMoves(Opponent, Board, Moves)
    ),
    D1 is D - 1,
    MaxPlayer1 is 0-MaxPlayer,
    choose_move(Player, Moves, Board, D1, MaxPlayer1, [nil, -1000], [Move, Value]).

updateBestMove(_, Value, [Move1, Value1], [Move1, Value1]) :-
    Value =< Value1, !.
updateBestMove(Move, Value, [_, Value1], [Move, Value]) :-
    Value > Value1.

choose_move(Player, Board, Depth, [Move, Value]) :-
    minimax(Player, Depth, Board, 1, Move, Value),!.