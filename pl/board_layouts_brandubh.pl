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

tryFindMove([
	[e,e,e,e,e,e,e],
	[e,d,a,e,e,e,e],
	[e,e,e,e,e,e,e],
	[e,e,e,d,e,e,e],
	[e,e,e,e,e,e,e],
	[e,e,e,e,e,e,e],
	[e,e,e,e,e,e,a]
]).

hsotile_vertical_test([
	[e,e,e,a,e,e,e],
	[d,e,e,a,e,e,a],
	[a,e,e,d,e,e,d],
	[a,a,d,k,d,a,a],
	[e,e,e,d,e,e,e],
	[e,e,e,a,e,e,e],
	[e,e,e,a,e,e,e]
]).

one_move([
	[e,e,e,a,k,e,e],
	[e,e,e,a,e,e,e],
	[a,e,e,a,e,e,d],
	[a,a,a,e,a,a,a],
	[e,e,e,a,e,e,e],
	[e,e,e,a,e,e,e],
	[e,e,e,a,e,e,e]
]).
