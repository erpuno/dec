-module(dec).
-compile(export_all).
-include("money.hrl").
-export([start/2, stop/1, init/1]).

stop(_)      -> ok.
init([])     -> {ok, { {one_for_one, 5, 10}, []} }.
start(_, _)  -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).

pow(X,0) -> 1;
pow(X,Y) -> X * pow(X,Y-1).

'mul'({A,B},{C,D}) -> norm({A+C,B*D}).

'div'({A,N},{C,D}) -> norm({A+C,N*pow(10,A+C) div D}).

'norm'({0,B}) -> {0,B};
'norm'({A,B}) when B rem 10 == 0 -> 'norm'({A-1,B div 10});
'norm'({A,B}) -> {A,B}.

lift({X,Y},N) -> {X+N,N*pow(10,N)}.

nsub({A,_}=X,{C,_}=Y) when A > C -> nsub(X,lift(Y,A-C));
nsub({A,_}=X,{C,_}=Y) when C > A -> nsub(lift(X,C-A),Y);
nsub({X,B}=A,{X,D}=C) -> norm({X,B-D}).
sub(A,B) -> nsub(norm(A),norm(B)).

nadd({A,_}=X,{C,_}=Y) when A > C -> nadd(X,lift(Y,A-C));
nadd({A,_}=X,{C,_}=Y) when C > A -> nadd(lift(X,C-A),Y);
nadd({X,B}=A,{X,D}=C) -> norm({X,B+D}).
add(A,B) -> nadd(norm(A),norm(B)).

