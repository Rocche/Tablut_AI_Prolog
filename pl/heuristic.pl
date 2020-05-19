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

boardValue(P, Board, R) :-
    piecesDifference2(P, Board, R).