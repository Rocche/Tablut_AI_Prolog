initial([
	[e,e,e,a,e,e,e],
	[e,e,e,a,e,e,e],
	[e,e,e,d,e,e,e],
	[a,a,d,k,d,a,a],
	[e,e,e,d,e,e,e],
	[e,e,e,a,e,e,e],
	[e,e,e,a,e,e,e]
]).

kingWinsUpperLeft([
	[k,_,_,_,_,_,_],
	[_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_],
	[_,_,_,_,_,_,_]
]).
kingWinsUpperRight([
	[_,_,_,_,_,_,k],
	[_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_],
	[_,_,_,_,_,_,_]
]).
kingWinsBottomRight([
	[_,_,_,_,_,_,_],
	[_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_],
	[_,_,_,_,_,_,k]
]).
kingWinsBottomLeft([
	[_,_,_,_,_,_,_],
	[_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_],
	[k,_,_,_,_,_,_]
]).

kingWins(B) :- kingWinsUpperLeft(B), !.
kingWins(B) :- kingWinsUpperRight(B), !.
kingWins(B) :- kingWinsBottomRight(B), !.
kingWins(B) :- kingWinsBottomLeft(B).

problem([
	[e,e,e,e,a,e,e],
	[e,e,e,a,e,a,e],
	[e,e,e,d,d,e,e],
	[a,k,e,e,e,e,a],
	[e,e,d,d,e,e,e],
	[e,a,e,a,e,e,e],
	[e,e,e,a,e,e,e]
]).

problem2([
	[e,e,e,k,a,e,e],
	[e,e,a,e,e,a,e],
	[e,e,e,d,d,e,e],
	[a,e,e,e,e,e,a],
	[e,e,d,d,e,e,e],
	[e,a,e,a,e,e,e],
	[e,e,e,a,e,e,e]
]).

problem3([
	[e,e,e,e,a,e,e],
	[e,e,a,e,e,a,e],
	[e,e,e,d,d,e,e],
	[a,e,e,e,e,e,a],
	[e,e,d,d,e,e,e],
	[k,e,e,a,e,e,e],
	[e,e,a,a,e,e,e]
]).

problem4([
	[e,e,e,e,a,e,e],
	[e,e,a,e,e,a,e],
	[e,e,e,d,d,e,e],
	[e,e,e,e,e,e,a],
	[a,e,d,d,e,e,e],
	[k,e,e,a,e,e,e],
	[e,e,a,a,e,e,e]
]).

prova(R) :-
	problem3(B),
	move(3,0,4,0,B,B1),
	updateBoard(a, B1, NB),
	boardValue(a, NB, R),
	game_over(NB).