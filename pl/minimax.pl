:- [heuristic].
:- [movement].

choose_best_move(_, [], _, _, Alpha, _, Move, [Move, Alpha]) :- !.
choose_best_move(Player, [[[X1,Y1],[X2,Y2]] | Moves], Board, D, Alpha, Beta, Move1, BestMove) :-
    move(X1, Y1, X2, Y2, Board, BoardWithNoCapture),
    updateBoard(Player, BoardWithNoCapture, NewBoard),
    alpha_beta(Player, D, NewBoard, Alpha, Beta, _, Value),
    Value1 is -Value,
    cutoff(Player, [[X1,Y1],[X2,Y2]], Value1, D, Alpha, Beta, Moves, Board, Move1, BestMove).

alpha_beta(Player, 0, Board, _, _, _, Value) :-
    boardValue(Player, Board, Value),
    !.
    
alpha_beta(Player, D, Board, Alpha, Beta, Move, Value) :-
    D > 0,
    getAllPlayerAvailableMoves(Player, Board, Moves),
    Alpha1 is -Beta,
    Beta1 is -Alpha,
    D1 is D - 1,
    choose_best_move(Player, Moves, Board, D1, Alpha1, Beta1, nil, [Move, Value]).

cutoff(_, Move, Value, _, _, Beta, _, _, _, [Move, Value]) :-
    Value >= Beta,
    !.
cutoff(Player, Move, Value, D, Alpha, Beta, Moves, Board, _, BestMove) :-
    Alpha < Value,
    Value < Beta,
    choose_best_move(Player, Moves, Board, D, Value, Beta, Move, BestMove),
    !.
cutoff(Player, _, Value, D, Alpha, Beta, Moves, Board, Move1, BestMove) :-
    Value =< Alpha,
    choose_best_move(Player, Moves, Board, D, Alpha, Beta, Move1, BestMove).

choose_best_move(Player, Board, Depth, Best) :-
    getAllPlayerAvailableMoves(Player, Board, Moves),
    choose_best_move(Player, Moves, Board, Depth, -1000, 1000, nil, Best).