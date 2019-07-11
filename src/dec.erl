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

'div'({A,N},{C,D}) -> norm({A+C+1,N*pow(10,A+C+1) div D}).

'norm'({0,B}) -> {0,B};
'norm'({A,B}) when B rem 10 == 0 -> 'norm'({A-1,B div 10});
'norm'({A,B}) -> {0,B*pow(10,A)}.

sub(A,B) -> nsub(norm(A),norm(B)).
nsub({A,B},{C,D}) -> {0,B - D}.

add(A,B) -> nadd(norm(A),norm(B)).
nadd({A,B},{C,D}) -> {0,B + D}.

