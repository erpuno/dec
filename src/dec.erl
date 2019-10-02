-module(dec).
-compile(export_all).
-include("money.hrl").
-export([start/2, stop/1, init/1]).

stop(_) -> ok.
init([]) -> {ok, { {one_for_one, 5, 10}, []} }.
start(_, _)  -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).

pow(_,0) -> 1;
pow(X,Y) -> X * pow(X,Y-1).

mul({dec,A,B},{dec,C,D}) -> norm({dec,A+C,B*D}).

'div'(A, B) -> 'div'(A, B, application:get_env(dec,precision,10)).
'div'({dec,A,B},{dec,C,D}, M) when A > C -> norm({dec,max3(A,C,M), div2(max3(A,C,M), B, D*pow(10,abs(A-C)))});
'div'({dec,A,B},{dec,C,D}, M) -> norm({dec,max3(A,C,M), div2(max3(A,C,M), B*pow(10,abs(A-C)), D)}). 

r(N) when N > 5 -> 1;
r(_)->0.

div2(M, A, B ) when M =< 0 -> A div B + r((A rem B)*10 div B);
div2(M, A, B) ->  (A div B)*pow(10,M) + div2(M-1, (A rem B)*10, B).

max3(A,B,C) -> max(max(A,B),C).

norm({dec,0,B}) -> {dec,0,B};
norm({dec,A,B}) when B rem 10 == 0 -> norm({dec,A-1,B div 10});
norm({dec,A,B}) -> {dec,A,B}.

sub({dec,A,B},{dec,C,D}) when A > C -> norm({dec,A, B - D*pow(10,abs(A-C))});
sub({dec,A,B},{dec,C,D}) -> norm({dec,C, B*pow(10,abs(A-C)) - D}).

add({dec,A,B},{dec,C,D}) when A > C -> norm({dec,A, B + D*pow(10,abs(A-C))});
add({dec,A,B},{dec,C,D}) -> norm({dec,C, D + B*pow(10,abs(A-C))}).

test() ->
   {dec,1, 2}            = dec:'div'({dec,0,1}, {dec,0,5}),
   {dec,4, 625}          = dec:'div'({dec,1,1}, {dec,1,16}),
   {dec,10, 6666666667}  = dec:'div'({dec,0,2}, {dec,0,3}),
   {dec,10, 144927536}   = dec:'div'({dec,0,1}, {dec,0,69}),
   {dec,10,3333333333}   = dec:'div'({dec,0,1}, {dec,0,3}),
   {dec,10,33333333333}  = dec:'div'({dec,0,10},{dec,0,3}),

    {dec,0, 5}           = dec:add({dec,0,1}, {dec,0,4}),
    {dec,0, 5}           = dec:add({dec,0,4}, {dec,0,1}),
    {dec,1, 3}           = dec:add({dec,1,1}, {dec,1,2}),
    {dec,0, 28}          = dec:add({dec,2,2000}, {dec,1,80}),
    {dec,0, 28}          = dec:add({dec,1,80}, {dec,2,2000}),

    {dec,0, -3}           = dec:sub({dec,0,1}, {dec,0,4}),
    {dec,0, 3}           = dec:sub({dec,0,4}, {dec,0,1}),
    {dec,1, -1}           = dec:sub({dec,1,1}, {dec,1,2}),
    {dec,0, 12}          = dec:sub({dec,2,2000}, {dec,1,80}),
    {dec,0, -12}          = dec:sub({dec,1,80}, {dec,2,2000}),

    {dec,0, 0}           = dec:mul({dec,0,0}, {dec,1,4}),
    {dec,0, 4}           = dec:mul({dec,0,4}, {dec,0,1}),
    {dec,0, 4}           = dec:mul({dec,0,1}, {dec,0,4}),
    {dec,2, 2}           = dec:mul({dec,1,1}, {dec,1,2}),
    {dec,0, 160}          = dec:mul({dec,2,2000}, {dec,1,80}),
    {dec,0, 160}          = dec:mul({dec,1,80}, {dec,2,2000}),

   ok.

