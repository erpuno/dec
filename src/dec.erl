-module(dec).
-compile(export_all).
-include("money.hrl").
-export([start/2, stop/1, init/1]).

stop(_) -> ok.
init([]) -> {ok, { {one_for_one, 5, 10}, []} }.
start(_, _)  -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).

pow(_,0) -> 1;
pow(X,Y) -> X * pow(X,Y-1).

mul({'Dec',A,B},{'Dec',C,D}) -> norm({'Dec',A+C,B*D}).

'div'(A, B) -> 'div'(A, B, application:get_env(dec,precision,10)).
'div'({'Dec',A,B},{'Dec',C,D}, M) when A > C -> norm({'Dec',max3(A,C,M), div2(max3(A,C,M), B, D*pow(10,abs(A-C)))});
'div'({'Dec',A,B},{'Dec',C,D}, M) -> norm({'Dec',max3(A,C,M), div2(max3(A,C,M), B*pow(10,abs(A-C)), D)}). 

r(N) when N > 5 -> 1;
r(_)->0.

div2(M, A, B ) when M =< 0 -> A div B + r((A rem B)*10 div B);
div2(M, A, B) ->  (A div B)*pow(10,M) + div2(M-1, (A rem B)*10, B).

max3(A,B,C) -> max(max(A,B),C).

norm({'Dec',0,B}) -> {'Dec',0,B};
norm({'Dec',A,B}) when B rem 10 == 0 -> norm({'Dec',A-1,B div 10});
norm({'Dec',A,B}) -> {'Dec',A,B}.

sub({'Dec',A,B},{'Dec',C,D}) when A > C -> norm({'Dec',A, B - D*pow(10,abs(A-C))});
sub({'Dec',A,B},{'Dec',C,D}) -> norm({'Dec',C, B*pow(10,abs(A-C)) - D}).

add({'Dec',A,B},{'Dec',C,D}) when A > C -> norm({'Dec',A, B + D*pow(10,abs(A-C))});
add({'Dec',A,B},{'Dec',C,D}) -> norm({'Dec',C, D + B*pow(10,abs(A-C))}).

test() ->
   {'Dec',1, 2}            = dec:'div'({'Dec',0,1}, {'Dec',0,5}),
   {'Dec',4, 625}          = dec:'div'({'Dec',1,1}, {'Dec',1,16}),
   {'Dec',10, 6666666667}  = dec:'div'({'Dec',0,2}, {'Dec',0,3}),
   {'Dec',10, 144927536}   = dec:'div'({'Dec',0,1}, {'Dec',0,69}),
   {'Dec',10,3333333333}   = dec:'div'({'Dec',0,1}, {'Dec',0,3}),
   {'Dec',10,33333333333}  = dec:'div'({'Dec',0,10},{'Dec',0,3}),

    {'Dec',0, 5}           = dec:add({'Dec',0,1}, {'Dec',0,4}),
    {'Dec',0, 5}           = dec:add({'Dec',0,4}, {'Dec',0,1}),
    {'Dec',1, 3}           = dec:add({'Dec',1,1}, {'Dec',1,2}),
    {'Dec',0, 28}          = dec:add({'Dec',2,2000}, {'Dec',1,80}),
    {'Dec',0, 28}          = dec:add({'Dec',1,80}, {'Dec',2,2000}),

    {'Dec',0, -3}           = dec:sub({'Dec',0,1}, {'Dec',0,4}),
    {'Dec',0, 3}           = dec:sub({'Dec',0,4}, {'Dec',0,1}),
    {'Dec',1, -1}           = dec:sub({'Dec',1,1}, {'Dec',1,2}),
    {'Dec',0, 12}          = dec:sub({'Dec',2,2000}, {'Dec',1,80}),
    {'Dec',0, -12}          = dec:sub({'Dec',1,80}, {'Dec',2,2000}),

    {'Dec',0, 0}           = dec:mul({'Dec',0,0}, {'Dec',1,4}),
    {'Dec',0, 4}           = dec:mul({'Dec',0,4}, {'Dec',0,1}),
    {'Dec',0, 4}           = dec:mul({'Dec',0,1}, {'Dec',0,4}),
    {'Dec',2, 2}           = dec:mul({'Dec',1,1}, {'Dec',1,2}),
    {'Dec',0, 160}          = dec:mul({'Dec',2,2000}, {'Dec',1,80}),
    {'Dec',0, 160}          = dec:mul({'Dec',1,80}, {'Dec',2,2000}),

   ok.

