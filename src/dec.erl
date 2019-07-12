-module(dec).
-compile(export_all).
-include("money.hrl").
-export([start/2, stop/1, init/1]).

stop(_) -> ok.
init([]) -> {ok, { {one_for_one, 5, 10}, []} }.
start(_, _)  -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).

pow(X,0) -> 1;
pow(X,Y) -> X * pow(X,Y-1).
max3(A,B,C) -> max(max(A,B),C).

mul({A,B},{C,D}) -> norm({A+C,B*D}).

'div'(A, B) -> 'div'(A, B, 10).
'div'({A,B},{C,D}, M) when A > C -> norm({max3(A,C,M)+1, div2(max3(A,C,M), B, D*pow(10,abs(A-C)))});
'div'({A,B},{C,D}, M) -> norm({max3(A,C,M)+1, div2(max3(A,C,M), B*pow(10,abs(A-C)), D)}). 

div2(0, A, B ) -> A div B;
div2(M, A, B) ->  (A div B)*pow(10,M) + div2(M-1, (A rem B)*10, B).

norm({0,B}) -> {0,B};
norm({A,B}) when B rem 10 == 0 -> norm({A-1,B div 10});
norm({A,B}) -> {A,B}.

sub({A,B},{C,D}) when A > C -> norm({A, B - D*pow(10,abs(A-C))});
sub({A,B},{C,D}) -> norm({C, B*pow(10,abs(A-C)) - D}).

add({A,B},{C,D}) when A > C -> norm({A, B + D*pow(10,abs(A-C))});
add({A,B},{C,D}) -> norm({C, D + B*pow(10,abs(A-C))}).
