initial([
	[e,e,e,a,a,a,e,e,e],
	[e,e,e,e,a,e,e,e,e],
	[e,e,e,e,d,e,e,e,e],
	[a,e,e,e,d,e,e,e,a],
	[a,a,d,d,k,d,d,a,a],
	[a,e,e,e,d,e,e,e,a],
	[e,e,e,e,d,e,e,e,e],
	[e,e,e,e,a,e,e,e,e],
	[e,e,e,a,a,a,e,e,e]
]).

aCanCapture([
	[a,d,a,d,a,a,e,e,e],
	[e,e,e,e,a,e,e,e,e],
	[e,e,e,e,d,e,e,e,e],
	[a,e,e,e,d,e,e,e,a],
	[a,a,d,d,k,d,d,a,a],
	[a,e,e,e,d,e,e,e,a],
	[e,e,e,e,d,e,e,e,e],
	[e,e,e,e,a,e,e,e,e],
	[e,e,e,a,a,a,e,e,e]
]).

kingCanBeCaptured([
	[a,d,a,d,a,a,e,e,e],
	[e,a,e,e,a,e,e,e,e],
	[a,k,a,e,d,e,e,e,e],
	[a,a,e,e,d,e,e,e,a],
	[a,a,d,d,k,d,d,a,a],
	[a,e,e,e,d,e,e,e,a],
	[e,e,e,e,d,e,e,e,e],
	[e,e,e,e,a,e,e,e,e],
	[e,e,e,a,a,a,e,e,e]
]).

kingWinsUpperLeft([
	[k,_,_,_,_,_,_,_,_],
	[_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
	[_,_,_,_,_,_,_,_,_]
]).
kingWinsUpperRight([
	[_,_,_,_,_,_,_,_,k],
	[_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
	[_,_,_,_,_,_,_,_,_]
]).
kingWinsBottomRight([
	[_,_,_,_,_,_,_,_,_],
	[_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
	[_,_,_,_,_,_,_,_,k]
]).
kingWinsBottomLeft([
	[_,_,_,_,_,_,_,_,_],
	[_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
	[k,_,_,_,_,_,_,_,_]
]).
kingWins(B) :- 
	kingWinsUpperLeft(B);
	kingWinsUpperRight(B);
	kingWinsBottomRight(B);
	kingWinsBottomLeft(B).

tryKingUpperLeft([
	[e,e,e,e,e,e,e,e,e],
	[e,e,e,e,e,e,e,e,e],
	[e,a,e,e,e,a,e,e,e],
	[e,e,e,e,e,e,e,e,e],
	[e,e,e,e,e,e,e,e,e],
	[e,a,e,e,e,k,a,e,a],
	[e,e,e,e,e,a,e,e,e],
	[e,e,e,e,e,e,e,e,e],
	[e,e,e,e,e,e,e,a,e]
]).

blocked([
	[e,e,e,e,e,e,e,e,e],
	[e,e,e,e,e,e,e,e,e],
	[e,a,e,e,e,a,e,e,e],
	[e,e,e,e,e,a,e,e,e],
	[e,e,e,e,a,e,a,e,e],
	[e,a,e,e,a,k,a,e,a],
	[e,e,e,e,e,a,e,e,e],
	[e,e,e,e,e,e,e,e,e],
	[e,e,e,e,e,e,e,a,e]
]).