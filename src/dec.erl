-module(dec).
-compile(export_all).
-include("dec.hrl").
-include("money.hrl").
-export([start/2, stop/1, init/1]).

stop(_) -> ok.
init([]) -> {ok, { {one_for_one, 5, 10}, []} }.
start(_, _)  -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).

pow(_,0) -> 1;
pow(X,Y) -> X * pow(X,Y-1).

mul({money,A,B},{money,C,D}) -> norm({money,A+C,B*D}).

'div'(A, B) -> 'div'(A, B, application:get_env(dec,precision,10)).
'div'({money,A,B},{money,C,D}, M) when A > C -> norm({money,max3(A,C,M), div2(max3(A,C,M), B, D*pow(10,abs(A-C)))});
'div'({money,A,B},{money,C,D}, M) -> norm({money,max3(A,C,M), div2(max3(A,C,M), B*pow(10,abs(A-C)), D)}). 

r(N) when N > 5 -> 1;
r(_)->0.

div2(M, A, B ) when M =< 0 -> A div B + r((A rem B)*10 div B);
div2(M, A, B) ->  (A div B)*pow(10,M) + div2(M-1, (A rem B)*10, B).

max3(A,B,C) -> max(max(A,B),C).

norm({money,0,B}) -> {money,0,B};
norm({money,A,B}) when B rem 10 == 0 -> norm({money,A-1,B div 10});
norm({money,A,B}) -> {money,A,B}.

sub({money,A,B},{money,C,D}) when A > C -> norm({money,A, B - D*pow(10,abs(A-C))});
sub({money,A,B},{money,C,D}) -> norm({money,C, B*pow(10,abs(A-C)) - D}).

add({money,A,B},{money,C,D}) when A > C -> norm({money,A, B + D*pow(10,abs(A-C))});
add({money,A,B},{money,C,D}) -> norm({money,C, D + B*pow(10,abs(A-C))}).

test() ->
   {money,1, 2}            = dec:'div'({money,0,1}, {money,0,5}),
   {money,4, 625}          = dec:'div'({money,1,1}, {money,1,16}),
   {money,10, 6666666667}  = dec:'div'({money,0,2}, {money,0,3}),
   {money,10, 144927536}   = dec:'div'({money,0,1}, {money,0,69}),
   {money,10,3333333333}   = dec:'div'({money,0,1}, {money,0,3}),
   {money,10,33333333333}  = dec:'div'({money,0,10},{money,0,3}),

    {money,0, 5}           = dec:add({money,0,1}, {money,0,4}),
    {money,0, 5}           = dec:add({money,0,4}, {money,0,1}),
    {money,1, 3}           = dec:add({money,1,1}, {money,1,2}),
    {money,0, 28}          = dec:add({money,2,2000}, {money,1,80}),
    {money,0, 28}          = dec:add({money,1,80}, {money,2,2000}),

    {money,0, -3}           = dec:sub({money,0,1}, {money,0,4}),
    {money,0, 3}           = dec:sub({money,0,4}, {money,0,1}),
    {money,1, -1}           = dec:sub({money,1,1}, {money,1,2}),
    {money,0, 12}          = dec:sub({money,2,2000}, {money,1,80}),
    {money,0, -12}          = dec:sub({money,1,80}, {money,2,2000}),

    {money,0, 0}           = dec:mul({money,0,0}, {money,1,4}),
    {money,0, 4}           = dec:mul({money,0,4}, {money,0,1}),
    {money,0, 4}           = dec:mul({money,0,1}, {money,0,4}),
    {money,2, 2}           = dec:mul({money,1,1}, {money,1,2}),
    {money,0, 160}          = dec:mul({money,2,2000}, {money,1,80}),
    {money,0, 160}          = dec:mul({money,1,80}, {money,2,2000}),

   ok.

