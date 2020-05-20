:- [utils].

piecesDifference(Board, R) :-
	occurrencesInMatrix(Board, d, Defenders),
    occurrencesInMatrix(Board, a, Attackers),
    R is ((2 * Defenders) - Attackers) / ((2 * Defenders) + Attackers).

piecesDifference2(a, Board, R) :-
	occurrencesInMatrix(Board, d, Defenders),
    occurrencesInMatrix(Board, a, Attackers),
    R is Attackers - Defenders.

piecesDifference2(d, Board, R) :-
	occurrencesInMatrix(Board, d, Defenders),
    occurrencesInMatrix(Board, a, Attackers),
    R is Defenders - Attackers.

game_over(_, Board, 0) :- \+ game_over(Board).
game_over(d, Board, 80) :-
    defender_wins(Board).
game_over(d, Board, -80) :-
    attacker_wins(Board).
game_over(a, Board, 80) :-
    attacker_wins(Board).
game_over(a, Board, -80) :-
    defender_wins(Board).

boardValue(P, Board, R) :-
    piecesDifference2(P, Board, R1),
    game_over(P, Board, R2),
    R is R1 + R2.