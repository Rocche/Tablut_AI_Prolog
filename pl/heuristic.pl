:- [utils].

piecesDifference(d, Board, R) :-
	occurrencesInMatrix(Board, d, Defenders),
    occurrencesInMatrix(Board, a, Attackers),
    R is ((2 * Defenders) - Attackers).% / ((2 * Defenders) + Attackers).

piecesDifference(a, Board, R) :-
	occurrencesInMatrix(Board, d, Defenders),
    occurrencesInMatrix(Board, a, Attackers),
    R is (Attackers - (2 * Defenders)).% / ((2 * Defenders) + Attackers).

attackerInCorner(X, Y, Board, 1) :- selectFromMatrix(X, Y, Board, a), !.
attackerInCorner(_, _, _, 0).

attackersInCorners(Board, R) :-
    attackerInCorner(1,1,Board,R1),
    attackerInCorner(1,5,Board,R2),
    attackerInCorner(5,1,Board,R3),
    attackerInCorner(5,5,Board,R4),
    R is R1 + R2 + R3 + R4.


kingNeighborScore(X, Y, Board, 0) :- selectFromMatrix(X, Y, Board, e), !.
kingNeighborScore(X, Y, Board, 1) :- selectFromMatrix(X, Y, Board, d), !.
kingNeighborScore(X, Y, Board, -1) :- selectFromMatrix(X, Y, Board, a), !.
kingNeighborScore(X, Y, Board, 0)  :- \+ selectFromMatrix(X, Y, Board, _).

kingNeighbors(Board, R) :-
    getPiecesCoordinates(k, Board, [[ X, Y ]]),
    X1 is X -1,
    X2 is X + 1,
    Y1 is Y - 1,
    Y2 is Y + 1,
    kingNeighborScore(X, Y2, Board, R1),
    kingNeighborScore(X, Y1, Board, R2),
    kingNeighborScore(X2, Y, Board, R3),
    kingNeighborScore(X1, Y, Board, R4),
    R is R1 + R2 + R3 + R4.

game_over(_, Board, 0) :- \+ game_over(Board), !.
game_over(d, Board, 1) :-
    defender_wins(Board).
game_over(d, Board, -1) :-
    attacker_wins(Board).
game_over(a, Board, 1) :-
    attacker_wins(Board).
game_over(a, Board, -1) :-
    defender_wins(Board).

boardValue(P, Board, R) :- 
    game_over(P, Board, 0),
    piecesDifference(P, Board, PD),
    attackersInCorners(Board, AC),
    kingNeighbors(Board, KN),
    (
    P == a 
    -> 
    R is PD + AC - KN
    ;
    R is PD + KN
    ),
    !.

boardValue(P, Board, R) :- 
    game_over(P, Board, GO),
    GO =\= 0,
    R is GO * 80.