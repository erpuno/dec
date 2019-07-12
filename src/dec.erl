-module(dec).
-compile(export_all).
-include("money.hrl").
-export([start/2, stop/1, init/1]).

stop(_)      -> ok.
init([])     -> {ok, { {one_for_one, 5, 10}, []} }.
start(_, _)  -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).

pow(X,0) -> 1;
pow(X,Y) -> X * pow(X,Y-1).

mul({A,B},{C,D}) -> norm({A+C,B*D}).

ndiv({X,A}=N,{Y,B}=M) ->{F,K} = lift(N,length(integer_to_list(B))-X), norm({F-Y,K div B}).
'div'({X,A}=N,{Y,B}=M) -> ndiv(norm(N),norm(M)).

norm({0,B}) -> {0,B};
norm({A,B}) when B rem 10 == 0 -> norm({A-1,B div 10});
norm({A,B}) -> {A,B}.

lift({X,Y},N) -> {X+N,Y*pow(10,N)}.

sub({A,B},{C,D}) when A > C -> norm({A, B - D*pow(10,abs(A-C))});
sub({A,B},{C,D}) -> norm({C, D - B*pow(10,abs(A-C))}).

add({A,B},{C,D}) when A > C -> norm({A, B + D*pow(10,abs(A-C))});
add({A,B},{C,D}) -> norm({C, D + B*pow(10,abs(A-C))}).
